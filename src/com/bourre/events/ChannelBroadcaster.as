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
	
	import flash.events.Event;
	import com.bourre.log.*;
	
	public class ChannelBroadcaster
	{
		private var _oDefaultChannel :EventChannel;
		private var _mChannel : HashMap;
		
		public function ChannelBroadcaster( oChannel : EventChannel = null )
		{
			empty();
			setDefaultChannel( oChannel );
		}
		
		public function getDefaultDispatcher() : EventBroadcaster
		{
			return _mChannel.get( _oDefaultChannel );
		}
		
		public function getDefaultChannel() : EventChannel
		{
			return _oDefaultChannel;
		}
		
		public function setDefaultChannel( oChannel : EventChannel = null ) : void
		{
			_oDefaultChannel = (oChannel == null) ? DefaultChannel.CHANNEL : oChannel;
			getChannelDispatcher( getDefaultChannel() );
		}
		
		public function empty() : void
		{
			_mChannel = new HashMap();
			
			var channel : EventChannel = getDefaultChannel();
			if ( channel != null ) getChannelDispatcher( channel );
		}
		
		public function isRegistered( listener : Object, type : String, oChannel : EventChannel ) : Boolean
		{
			return getChannelDispatcher( oChannel ).isRegistered( listener, type );
		}
		
		public function hasChannelDispatcher( oChannel : EventChannel ) : Boolean
		{
			return oChannel == null ? _mChannel.containsKey( _oDefaultChannel ) : _mChannel.containsKey( oChannel );
		}
		
		public function hasChannelListener( type : String, oChannel : EventChannel = null ) : Boolean
		{
			if ( hasChannelDispatcher( oChannel ) )
			{
				return getChannelDispatcher( oChannel ).hasListenerCollection( type );
				
			} else
			{
				return false;
			}
		}
		
		public function getChannelDispatcher( oChannel : EventChannel = null ) : EventBroadcaster
		{
			if ( hasChannelDispatcher( oChannel ) )
			{
				return oChannel == null ? _mChannel.get( _oDefaultChannel ) : _mChannel.get( oChannel );
				
			} else
			{
				var eb : EventBroadcaster = new EventBroadcaster();
				_mChannel.put( oChannel, eb );
				return eb;
			}
		}
		
		public function addListener( o : Object, oChannel : EventChannel = null ) : void
		{
			getChannelDispatcher( oChannel ).addListener( o );
		}
		
		public function removeListener( o : Object, oChannel : EventChannel = null ) : void
		{
			getChannelDispatcher( oChannel ).removeListener( o );
		}
		
		public function addEventListener( type : String, o : Object, oChannel : EventChannel = null ) : void
		{
			getChannelDispatcher( oChannel ).addEventListener( type, o );
		}
		
		public function removeEventListener( type : String, o : Object, oChannel : EventChannel = null ) : void
		{
			getChannelDispatcher( oChannel ).removeEventListener( type, o );
		}
		
		public function broadcastEvent( e : Event, channel : EventChannel = null ) : void
		{
			getChannelDispatcher( channel ).broadcastEvent( e );
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
	
	public function DefaultChannel()
	{
		super();
	}
}