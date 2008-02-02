package com.bourre.plugin
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
	import com.bourre.events.EventChannel;
	import com.bourre.log.Log;
	import com.bourre.log.Logger;
	import com.bourre.log.PixlibStringifier;

	public class PluginDebug
		implements Log
	{
		public static var isOn : Boolean = true;
		private static const _M : HashMap = new HashMap();

		protected var _channel : EventChannel;
		protected var _owner : Plugin;
		protected var _bIsOn : Boolean;

		public function PluginDebug(  access : PrivateConstructorAccess, owner : Plugin = null ) 
		{
				_owner = owner;
				_channel = owner.getChannel();
				on();
		}
		
		public function getOwner() : Plugin
		{
			return _owner;
		}
		
		public function isOn() : Boolean
		{
			return _bIsOn;
		}
		
		public function on() : void
		{
			_bIsOn = true;
		}
		
		public function off() : void
		{
			_bIsOn = false;
		}

		public function getChannel() : EventChannel
		{
			return _channel;
		}
	
		public static function getInstance ( owner : Plugin = null ) : PluginDebug
		{
			if ( owner == null ) owner = NullPlugin.getInstance();
			if ( !(PluginDebug._M.containsKey( owner )) ) PluginDebug._M.put( owner, new PluginDebug( new PrivateConstructorAccess(), owner ) );
			return PluginDebug._M.get( owner );
		}

		public static function release( owner : Plugin ) : Boolean
		{
			if ( PluginDebug._M.containsKey( owner ) ) 
			{
				PluginDebug._M.remove( owner );
				return true;

			} else
			{
				return false;
			}
		}

		public function debug( o : * ) : void
		{
			if ( PluginDebug.isOn && _bIsOn ) Logger.DEBUG( o, _channel );
		}
		
		public function info( o : * ) : void
		{
			if ( PluginDebug.isOn && _bIsOn ) Logger.INFO( o, _channel );
		}
		
		public function warn( o : * ) : void
		{
			if ( PluginDebug.isOn && _bIsOn ) Logger.WARN( o, _channel );
		}
		
		public function error( o : * ) : void
		{
			if ( PluginDebug.isOn && _bIsOn ) Logger.ERROR( o, _channel );
		}
		
		public function fatal( o : * ) : void
		{
			if ( PluginDebug.isOn && _bIsOn ) Logger.FATAL( o, _channel );
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

internal class PrivateConstructorAccess {}