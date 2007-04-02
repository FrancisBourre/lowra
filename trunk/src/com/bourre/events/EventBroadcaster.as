/*
 * Copyright the original author or authors.
 * 
 * Licensed under the MOZILLA PUBLIC LICENSE, Version 1.1 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *      http://www.mozilla.org/MPL/MPL-1.1.html
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/**
 * @author Francis Bourre
 * @version 1.0
 */

package com.bourre.events
{
	import com.bourre.collection.*;
	import com.bourre.commands.Delegate;
	import com.bourre.error.UnsupportedOperationException;
	import com.bourre.log.*;

	import flash.events.Event;
	import flash.utils.getQualifiedClassName;

	public class EventBroadcaster
	{
		private static var _oI : EventBroadcaster = null;
		
		private var _oTarget : Object;
		private var _mAll : Collection;
		private var _mType : HashMap;
		private var _mEventListener : HashMap;
		
		public function EventBroadcaster( target : Object = null )
		{
			_oTarget = ( target == null ) ? this : target;
			
			_mAll = new WeakCollection();
			_mType = new HashMap();
			_mEventListener = new HashMap();
		}
		
		public static function getInstance() : EventBroadcaster
		{
			if ( !(EventBroadcaster._oI is EventBroadcaster) ) EventBroadcaster._oI = new EventBroadcaster();
			return EventBroadcaster._oI;
		}
		
		public function hasListenerCollection( type : String ) : Boolean
		{
			return _mType.containsKey( type );
		}
		
		public function getListenerCollection( type : String ) : Collection
		{
			return _mType.get( type );
		}
		
		public function removeListenerCollection( type : String ) : void
		{
			_mType.remove( type );
		}
		
		public function isRegistered( listener : Object, type : String = null ) : Boolean
		{
			if (type == null)
			{
				return _mAll.contains( listener );
				
				
			} else
			{
				if ( hasListenerCollection( type ) )
				{
					return getListenerCollection( type ).contains( listener );
				} else
				{
					return false;
				}
			}
		}
		
		public function addListener( listener : Object ) : Boolean
		{
			if ( _mAll.add( listener ) ) 
			{
				_flushRef( listener );
				return true;

			} else
			{
				return false;
			}
		}
		
		public function removeListener( listener : Object ) : Boolean
		{
			var b : Boolean = _flushRef( listener );
			b = b || _mAll.contains( listener );
			_mAll.remove( listener );
			return b;
		}
		
		public function addEventListener( type : String, listener : Object, ...rest ) : Boolean
		{
			if (listener is Function)
			{
				var d : Delegate = new Delegate( listener as Function );
				if ( rest != null ) d.setArgumentsArray( rest );
				listener = d;
				
			} else
			{
				try
				{
					listener[type] is Function;
					
				} catch ( e : Error )
				{
					try
					{
						listener.handleEvent is Function;
						
					} catch ( e : Error )
					{
						var msg : String;
						msg = "EventBroadcaster.addEventListener() failed, you must implement '" 
						+ type + "' method or 'handleEvent' method in '" + 
						getQualifiedClassName(listener) + "' class";
									
						PixlibDebug.ERROR( msg );
						throw( new UnsupportedOperationException( msg ) );
					}
				}
			}
			
			if ( !(isRegistered(listener)) )
			{
				if ( !(hasListenerCollection(type)) ) _mType.put( type, new WeakCollection() );
				if ( getListenerCollection(type).add( listener ) ) 
				{
					_storeRef( type, listener );
					return true;
				} 
			}
			
			return false;
		}
		
		public function removeEventListener( type : String, listener : Object ) : Boolean
		{
			if ( hasListenerCollection( type ) )
			{
				var c : Collection = getListenerCollection( type );
				if ( c.remove( listener ) )
				{
					_removeRef( type, listener );
					if ( c.isEmpty() ) removeListenerCollection( type );
					return true;

				} else
				{
					return false;
				}

			} else
			{
				return false;
			}
		}
		
		public function removeAllListeners() : void
		{
			_mAll.clear();
			_mType.clear();
			_mEventListener.clear();
		}
		
		public function isEmpty() : Boolean
		{
			return _mAll.isEmpty() && _mType.isEmpty();
		}
		
		public function dispatchEvent( o : Object ) : void
		{
			var e : DynBasicEvent = new DynBasicEvent( o["type"] );
			for ( var p : String in o ) if (p != "type") e[p] = o[p];
			broadcastEvent( e );
		}
		
		public function broadcastEvent( e : Event ) : void
		{
			if ( hasListenerCollection(e.type) ) _broadcastEvent( getListenerCollection(e.type), e );
			if ( !(_mAll.isEmpty()) ) _broadcastEvent( _mAll, e );
		}
		
		public function _broadcastEvent( c : Collection, e : Event ) : void
		{
			var type : String = e.type;
			var a : Array = c.toArray();
			var l : Number = a.length;
			
			while ( --l > -1 ) 
			{
				var listener : Object = a[l];
				
				if ( listener.hasOwnProperty( "handleEvent" ) )
				{
					listener.handleEvent(e);
					
				} else if ( listener.hasOwnProperty( type ) )
				{
					listener[type](e);
					
				} else
				{
					var msg : String;
					msg = "EventBroadcaster.broadcastEvent() failed, you must implement '" 
					+ type + "' method or 'handleEvent' method in '" + 
					getQualifiedClassName(listener) + "' class";
					
					PixlibDebug.ERROR( msg );
					throw( new UnsupportedOperationException( msg ) );
				}
			}
		}
		
		/**
		 * Returns the string representation of this instance.
		 * @return the string representation of this instance
		 */
		public function toString() : String 
		{
			return PixlibStringifier.stringify( this );
		}
		
		//
		private function _storeRef( type : String, listener : Object ) : void
		{
			if ( !(_mEventListener.containsKey( listener )) ) _mEventListener.put( listener, new HashMap() );
			_mEventListener.get( listener ).put( type, listener );
		}
		
		private function _removeRef( type : String, listener : Object ) : void
		{
			var m : HashMap = _mEventListener.get( listener );
			m.remove( type );
			if ( m.isEmpty() ) _mEventListener.remove( listener );
			
		}
		
		private function _flushRef( listener : Object ) : Boolean
		{
			var b : Boolean = false;
			var m : HashMap = _mEventListener.get( listener );
			if ( m != null )
			{
				var a : Array = m.getKeys();
				var l : Number = a.length;
				while( --l > -1 ) b = removeEventListener( a[l], listener ) || b;
				_mEventListener.remove( listener );
			}
			return b;
		}
	}
}