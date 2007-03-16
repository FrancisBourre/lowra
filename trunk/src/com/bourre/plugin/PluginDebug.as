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

	import com.bourre.events.*;
	import com.bourre.log.*;
	import com.bourre.collection.HashMap;
	
	public class PluginDebug
	{
		public static var isOn : Boolean = true;
		private static const _M : HashMap = new HashMap();
		private var _channel : EventChannel;
		private var _owner : IPlugin;
		
		public function PluginDebug(  access : PrivateConstructorAccess, owner : IPlugin = null ) 
		{
			_owner = owner ? owner : NullPlugin.getInstance();
			_channel = _owner.getChannel();
		}
		
		public function getOwner() : IPlugin
		{
			return _owner;
		}
		
		public function getChannel() : EventChannel
		{
			return _channel;
		}
	
		public static function getInstance( owner : IPlugin = null ) : PluginDebug
		{
			if ( !(PluginDebug._M.containsKey( owner )) ) PluginDebug._M.put( owner, new PluginDebug( new PrivateConstructorAccess(), owner ) );
			return PluginDebug._M.get( owner );
		}
		
		public function debug( o : * ) : void
		{
			if (PluginDebug.isOn) Logger.LOG( o, LogLevel.DEBUG, _channel );
		}
		
		public function info( o : * ) : void
		{
			if (PluginDebug.isOn) Logger.LOG( o, LogLevel.INFO, _channel );
		}
		
		public function warn( o : * ) : void
		{
			if (PluginDebug.isOn) Logger.LOG( o, LogLevel.WARN, _channel );
		}
		
		public function error( o : * ) : void
		{
			if (PluginDebug.isOn) Logger.LOG( o, LogLevel.ERROR, _channel );
		}
		
		public function fatal( o : * ) : void
		{
			if (PluginDebug.isOn) Logger.LOG( o, LogLevel.FATAL, _channel );
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