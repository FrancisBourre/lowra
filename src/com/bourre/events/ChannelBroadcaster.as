package com.bourre.events
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
	 
	import flash.events.Event;
	
	import com.bourre.collection.*;
	import com.bourre.log.*;

	public class ChannelBroadcaster
	{
		private var _oDefaultChannel :EventChannel;
		private var _mChannel : HashMap;
		
		public function ChannelBroadcaster( channel : EventChannel = null )
		{
			empty();
			setDefaultChannel( channel );
		}
		
		public function getDefaultDispatcher() : EventBroadcaster
		{
			return _mChannel.get( _oDefaultChannel );
		}
		
		public function getDefaultChannel() : EventChannel
		{
			return _oDefaultChannel;
		}
		
		public function setDefaultChannel( channel : EventChannel = null ) : void
		{
			_oDefaultChannel = (channel == null) ? DefaultChannel.CHANNEL : channel;
			getChannelDispatcher( getDefaultChannel() );
		}
		
		public function empty() : void
		{
			_mChannel = new HashMap();
			
			var channel : EventChannel = getDefaultChannel();
			if ( channel != null ) getChannelDispatcher( channel );
		}
		
		public function isRegistered( listener : Object, type : String, channel : EventChannel ) : Boolean
		{
			return getChannelDispatcher( channel ).isRegistered( listener, type );
		}
		
		public function hasChannelDispatcher( channel : EventChannel ) : Boolean
		{
			return channel == null ? _mChannel.containsKey( _oDefaultChannel ) : _mChannel.containsKey( channel );
		}
		
		public function hasChannelListener( type : String, channel : EventChannel = null ) : Boolean
		{
			if ( hasChannelDispatcher( channel ) )
			{
				return getChannelDispatcher( channel ).hasListenerCollection( type );
				
			} else
			{
				return false;
			}
		}
		
		public function getChannelDispatcher( channel : EventChannel = null, owner : Object = null ) : EventBroadcaster
		{
			if ( hasChannelDispatcher( channel ) )
			{
				return channel == null ? _mChannel.get( _oDefaultChannel ) : _mChannel.get( channel );
				
			} else
			{
				var eb : EventBroadcaster = new EventBroadcaster( owner );
				_mChannel.put( channel, eb );
				return eb;
			}
		}

		public function releaseChannelDispatcher( channel : EventChannel ) : Boolean
		{
			if ( hasChannelDispatcher( channel ) )
			{
				var eb : EventBroadcaster = _mChannel.get( channel ) as EventBroadcaster;
				eb.removeAllListeners();
				_mChannel.remove( channel );

				return true;

			} else
			{
				return false;
			}
		}

		public function addListener( o : Object, channel : EventChannel = null ) : Boolean
		{
			return getChannelDispatcher( channel ).addListener( o );
		}
		
		public function removeListener( o : Object, channel : EventChannel = null ) : Boolean
		{
			return getChannelDispatcher( channel ).removeListener( o );
		}
		
		public function addEventListener( type : String, o : Object, channel : EventChannel = null ) : Boolean
		{
			return getChannelDispatcher( channel ).addEventListener( type, o );
		}
		
		public function removeEventListener( type : String, o : Object, channel : EventChannel = null ) : Boolean
		{
			return getChannelDispatcher( channel ).removeEventListener( type, o );
		}
		
		public function broadcastEvent( e : Event, channel : EventChannel = null ) : void
		{
			getChannelDispatcher( channel ).broadcastEvent( e );
			if ( channel ) getChannelDispatcher().broadcastEvent( e );
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

import com.bourre.events.EventChannel;

internal class DefaultChannel 
	extends EventChannel
{
	public static const CHANNEL : DefaultChannel = new DefaultChannel();
}