package com.bourre.core 
{
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
	 */	import flash.utils.Dictionary;
	
	import com.bourre.collection.HashMap;
	import com.bourre.collection.TypedContainer;
	import com.bourre.core.Locator;
	import com.bourre.error.IllegalArgumentException;
	import com.bourre.error.NoSuchElementException;
	import com.bourre.events.EventBroadcaster;
	import com.bourre.log.PixlibDebug;
	import com.bourre.log.PixlibStringifier;	

	public class AbstractLocator 
		implements Locator, TypedContainer
	{
		protected var _m : HashMap;
		protected var _oEB : EventBroadcaster;
		protected var _cType : Class;

		public function AbstractLocator( type : Class = null, typeListener : Class = null ) 
		{
			_cType = ( type != null ) ? type : Object;
			_m = new HashMap();
			_oEB = new EventBroadcaster( this, typeListener );
		}

		public function isRegistered( name : String ) : Boolean
		{
			return _m.containsKey( name );
		}

		public function register( name : String, o : Object ) : Boolean
		{
			if ( _m.containsKey( name ) )
			{
				var msg : String = " instance is already registered with '" + name + "' name in " + this;
				PixlibDebug.ERROR( msg );
				throw new IllegalArgumentException( msg );

				return false;

			} else
			{
				_m.put( name, o );
				onRegister( name, o );
				return true;
			}
		}

		protected function onRegister( name : String = null, o : Object = null ) : void
		{
			// override me if you need me
		}

		public function unregister( name : String ) : Boolean
		{
			if ( isRegistered( name ) )
			{
				_m.remove( name );
				onUnregister( name );
				return true;

			} else
			{
				return false;
			}
		}

		protected function onUnregister( name : String = null ) : void
		{
			// override me if you need me
		}

		public function locate( name : String ) : Object
		{
			if ( isRegistered( name ) ) 
			{
				return _m.get( name );

			} else
			{
				var msg : String = "Can't find '" + getType().toString() + "' instance with '" + name + "' name in " + this;
				PixlibDebug.FATAL( msg );
				throw new NoSuchElementException( msg );
			}
		}

		public function add( d : Dictionary ) : void
		{
			for ( var key : * in d ) 
			{
				try
				{
					register( key, d[ key ] as _cType );

				} catch( e : IllegalArgumentException )
				{
					e.message = this + ".add() fails. " + e.message;
					PixlibDebug.ERROR( e.message );
					throw( e );
				}
			}
		}

		public function matchType( o : * ) : Boolean
		{
			return o is _cType || o == null;
		}

		public function getType() : Class
		{
			return _cType;
		}

		public function isTyped() : Boolean
		{
			return _cType != null;
		}

		//
		public function addEventListener( type : String, listener : Object, ... rest ) : Boolean
		{
			return _oEB.addEventListener.apply( _oEB, rest.length > 0 ? [ type, listener ].concat( rest ) : [ type, listener ] );
		}

		public function removeEventListener( type : String, listener : Object ) : Boolean
		{
			return _oEB.removeEventListener( type, listener );
		}

		/**
		 * Returns the string representation of this instance.
		 * @return the string representation of this instance
		 */
		public function toString () : String
		{
			var hasType : Boolean = getType() != null;
			var parameter : String = "";

			if ( hasType )
			{
				parameter = getType().toString();
				parameter = "<" + parameter.substr( 7, parameter.length - 8 ) + ">";
			}

			return PixlibStringifier.stringify( this ) + parameter;
		}
	}}