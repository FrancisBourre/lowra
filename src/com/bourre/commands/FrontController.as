package com.bourre.commands
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
	 */

	import com.bourre.collection.HashMap;
	import com.bourre.events.EventBroadcaster;
	import com.bourre.log.*;
	import com.bourre.plugin.*;

	import flash.utils.*;
	import flash.events.Event;

	public class FrontController 
	{
		protected var _oEB : EventBroadcaster;
		protected var _owner : Plugin;
		protected var _mEventList : HashMap;

		public function FrontController( owner : Plugin = null ) 
		{
			setOwner( owner );
			_mEventList = new HashMap();
		}

		final public function setOwner( owner : Plugin ) : void
		{
			if ( _oEB ) _oEB.removeListener( this );

			if ( owner!= null )
			{
				_owner = owner;
				_oEB = new EventBroadcaster( getOwner() );
				
			} else
			{
				_owner = NullPlugin.getInstance();
				_oEB = EventBroadcaster.getInstance();
			}
			_oEB.addListener( this );
		}

		final public function getOwner() : Plugin
		{
			return _owner;
		}

		public function getLogger() : PluginDebug
		{
			return PluginDebug.getInstance( getOwner() );
		}

		final public function getBroadcaster() : EventBroadcaster
		{
			return _oEB;
		}

		public function pushCommandClass( eventName : String, commandClass : Class ) : void
		{
			_mEventList.put( eventName.toString(), commandClass );
		}

		public function pushCommandInstance( eventName : String, command : Command ) : void
		{
			_mEventList.put( eventName.toString(), command );
		}

		public function remove( eventName : String ) : void
		{
			_mEventList.remove( eventName.toString() );
		}

		final public function handleEvent( event : Event ) : void
		{
			var type : String = event.type.toString();

			if( _mEventList.containsKey( type ) )
			{
				var o : Object = _mEventList.get( type );

				if ( o is Class)
				{
					var cmd : Command = new ( o as Class )();
					if ( cmd is AbstractCommand ) ( cmd as AbstractCommand ).setOwner( getOwner() );
					cmd.execute( event );

				} else if ( o is Command )
				{
					if ( o is AbstractCommand ) 
					{
						var acmd : AbstractCommand = ( o as AbstractCommand );
						if ( acmd.getOwner() == null ) acmd.setOwner( getOwner() );
					}

					o.execute( event );
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
	}
}