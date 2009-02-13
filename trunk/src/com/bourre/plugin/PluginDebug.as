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
package com.bourre.plugin
{
	import com.bourre.collection.HashMap;
	import com.bourre.error.PrivateConstructorException;
	import com.bourre.events.EventChannel;
	import com.bourre.log.Log;
	import com.bourre.log.Logger;
	import com.bourre.log.PixlibStringifier;	

	/**
	 * The PluginDebug class defines "logging tunnel" for plugin logging feature.
	 * 
	 * <p>Each Plugin has his unique logging tunnel to log message throw 
	 * LowRA Logging API.</p>
	 * 
	 * @author 	Francis Bourre
	 */
	public class PluginDebug implements Log
	{
		private static const _M : HashMap = new HashMap( );

		
		/** 
		 * Channel is open or not.
		 * 
		 * @default true
		 */
		public static var isOn : Boolean = true;

		/** Event channel for this log target. */
		protected var _channel : EventChannel;

		/** Plugin owner. */
		protected var _owner : Plugin;

		/** @private */
		protected var _bIsOn : Boolean;

		
		/**
		 * Returns <code>PluginDebug</code> for passed-in plugin.
		 * 
		 * <p>If <code>PluginDebug</code> is not created, creates it.</p>
		 * 
		 * <p>If owner is <code>null</code>, use the <code>NullPlugin</code> instance.
		 * 
		 * @param	owner	Target plugin
		 * 
		 * @return The <code>PluginDebug</code> for passed-in plugin
		 */
		public static function getInstance( owner : Plugin = null ) : PluginDebug
		{
			if ( owner == null ) owner = NullPlugin.getInstance( );
			if ( !(PluginDebug._M.containsKey( owner )) ) PluginDebug._M.put( owner, new PluginDebug( new ConstructorAccess( ), owner ) );
			return PluginDebug._M.get( owner );
		}

		/**
		 * Releases <code>PluginDebug</code> instance for passed-in plugin.
		 * 
		 * @param	owner	Target plugin
		 */
		public static function release( owner : Plugin ) : Boolean
		{
			if ( PluginDebug._M.containsKey( owner ) ) 
			{
				PluginDebug._M.remove( owner );
				return true;
			} 
			else
			{
				return false;
			}
		}

		/**
		 * @private
		 */
		public function PluginDebug(  access : ConstructorAccess, owner : Plugin = null ) 
		{
			if ( !(access is ConstructorAccess) ) throw new PrivateConstructorException( );
				
			_owner = owner;
			_channel = owner.getChannel( );
			on( );
		}

		/**
		 * Returns plugin owner.
		 */
		public function getOwner() : Plugin
		{
			return _owner;
		}

		/**
		 * @inheritDoc
		 */
		public function isOn() : Boolean
		{
			return _bIsOn;
		}

		/**
		 * @inheritDoc
		 */
		public function on() : void
		{
			_bIsOn = true;
		}

		/**
		 * @inheritDoc
		 */
		public function off() : void
		{
			_bIsOn = false;
		}

		/**
		 * @inheritDoc
		 */
		public function getChannel() : EventChannel
		{
			return _channel;
		}

		/**
		 * @inheritDoc
		 */
		public function debug( o : * ) : void
		{
			if ( PluginDebug.isOn && _bIsOn ) Logger.DEBUG( o, _channel );
		}

		/**
		 * @inheritDoc
		 */
		public function info( o : * ) : void
		{
			if ( PluginDebug.isOn && _bIsOn ) Logger.INFO( o, _channel );
		}

		/**
		 * @inheritDoc
		 */
		public function warn( o : * ) : void
		{
			if ( PluginDebug.isOn && _bIsOn ) Logger.WARN( o, _channel );
		}

		/**
		 * @inheritDoc
		 */
		public function error( o : * ) : void
		{
			if ( PluginDebug.isOn && _bIsOn ) Logger.ERROR( o, _channel );
		}

		/**
		 * @inheritDoc
		 */
		public function fatal( o : * ) : void
		{
			if ( PluginDebug.isOn && _bIsOn ) Logger.FATAL( o, _channel );
		}

		/**
		 * Returns the string representation of this instance.
		 * 
		 * @return the string representation of this instance
		 */
		public function toString() : String 
		{
			return PixlibStringifier.stringify( this );
		}
	}
}

internal class ConstructorAccess 
{
}