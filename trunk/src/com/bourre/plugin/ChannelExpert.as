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
	import com.bourre.events.ApplicationBroadcaster;
	import com.bourre.events.EventChannel;
	import com.bourre.log.PixlibStringifier;
	
	import flash.utils.Dictionary;	

	/**
	 * The ChannelExpert class is a repository for 
	 * <code>EventChannel</code> object.
	 * 
	 * @see com.bourre.events.EventChannel
	 * 
	 * @author 	Francis Bourre
	 * @author 	Romain Flacher
	 */
	public class ChannelExpert
	{
		//--------------------------------------------------------------------
		// Private properties
		//--------------------------------------------------------------------
				
		private static var _oI 	: ChannelExpert;
		private static var _N 	: uint = 0;

		private var _m 				: HashMap;
		private var _oRegistered 	: Dictionary;
		
		
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
				
		/**
		 * Returns singleton instance of ChannelExpert.
		 * 
		 * @return singleton instance of ChannelExpert
		 */
		public static function getInstance() : ChannelExpert 
		{
			if ( !( ChannelExpert._oI is ChannelExpert ) ) ChannelExpert._oI = new ChannelExpert( new ConstructorAccess() );
			return ChannelExpert._oI;
		}
		
		/**
		 * Releases instance.
		 */
		public static function release():void
		{
			if ( ChannelExpert._oI is ChannelExpert ) 
			{
				ChannelExpert._oI = null;
				ChannelExpert._N = 0;
			}
		}
		
		/**
		 * @private
		 */
		public function ChannelExpert( access : ConstructorAccess )
		{
			if ( !(access is ConstructorAccess) ) throw new PrivateConstructorException();
			
			_m = new HashMap();
			_oRegistered = new Dictionary( true );
		}
		
		/**
		 * Returns <code>EventChannel</code> for passed-in plugin.
		 * 
		 * @param	plugin	Plugin to check
		 * 
		 * @return <code>EventChannel</code> for passed-in plugin.
		 */
		public function getChannel( o : Plugin ) : EventChannel
		{
			if( _oRegistered[o] == null )
			{
				if ( _m.containsKey( ChannelExpert._N ) )
				{
					var channel : EventChannel = _m.get( ChannelExpert._N ) as EventChannel;
					_oRegistered[o] = channel;
					++ ChannelExpert._N;
					return channel;
		
				} else
				{
					PluginDebug.getInstance().debug( this + ".getChannel() failed on " + o );
					_oRegistered[o] = ApplicationBroadcaster.getInstance().NO_CHANNEL;
					return ApplicationBroadcaster.getInstance().NO_CHANNEL;
				}
			}
			else
			{
				 return _oRegistered[o] as EventChannel;
			}
		}
		
		/**
		 * Releases event channel of passed-in plugin
		 * 
		 * @param	plugin	Plugin to check
		 */
		public function releaseChannel( o : Plugin ) : Boolean
		{
			if( _oRegistered[o] )
			{
				if ( _m.containsKey( o.getChannel() ) ) _m.remove( o.getChannel() );
				_oRegistered[o] = null;

				return true;
			}
			else
			{
				 return false;
			}
		}
		
		/**
		 * Registers passed-in event channel in hashmap.
		 * 
		 * @param channel Event channel to store.
		 */
		public function registerChannel( channel : EventChannel ) : void
		{
			_m.put( ChannelExpert._N, channel );
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

internal class ConstructorAccess {}