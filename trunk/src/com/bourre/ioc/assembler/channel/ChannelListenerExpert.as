package com.bourre.ioc.assembler.channel
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
	import com.bourre.commands.Batch;
	import com.bourre.core.AbstractLocator;
	import com.bourre.events.ApplicationBroadcaster;
	import com.bourre.ioc.bean.BeanFactory;
	import com.bourre.plugin.PluginChannel;		
	public class ChannelListenerExpert 
		extends AbstractLocator
	{
		private static var _oI : ChannelListenerExpert;

		public static function getInstance() : ChannelListenerExpert
		{
			if ( !(ChannelListenerExpert._oI is ChannelListenerExpert) ) 
				ChannelListenerExpert._oI = new ChannelListenerExpert( new PrivateConstructorAccess() );

			return ChannelListenerExpert._oI;
		}
		
		public static function release():void
		{
			ChannelListenerExpert._oI = null ;
		}
		
		public function ChannelListenerExpert( access : PrivateConstructorAccess )
		{
			super( ChannelListener, ChannelListenerExpertListener, null );
		}

		override protected function onRegister( id : String = null, channelListener : Object = null ) : void
		{
			broadcastEvent( new ChannelListenerEvent( ChannelListenerEvent.onRegisterChannelListenerEVENT, id, channelListener as ChannelListener ) );
		}

		override protected function onUnregister( id : String = null ) : void
		{
			broadcastEvent( new ChannelListenerEvent( ChannelListenerEvent.onUnregisterChannelListenerEVENT, id ) );
		}

		public function assignAllChannelListeners() : void
		{
			Batch.process( assignChannelListener, getKeys() );
		}

		public function assignChannelListener( id : String ) : Boolean
		{
			var channelListener : ChannelListener = locate( id ) as ChannelListener;
			var listener : Object = BeanFactory.getInstance().locate( channelListener.listenerID );
			var channel : PluginChannel = PluginChannel.getInstance( channelListener.channelName );

			var args : Array = channelListener.arguments;
			
			if ( args && args.length > 0 )
			{
				var l : int = args.length;
				for ( var i : int; i < l; i++ )
				{
					var o : Object = args[ i ];
					var method : String = o.method;
					listener = ( method && listener.hasOwnProperty(method) && listener[method] is Function) ? listener[method] : listener[o.type];
					ApplicationBroadcaster.getInstance().addEventListener( o.type, listener, channel );
				}

				return true;

			} else 
			{
				return ApplicationBroadcaster.getInstance().addListener( listener, channel );
			}
		}

		public function addListener( listener : ChannelListenerExpertListener ) : Boolean
		{
			return getBroadcaster().addListener( listener );
		}

		public function removeListener( listener : ChannelListenerExpertListener ) : Boolean
		{
			return getBroadcaster().removeListener( listener );
		}
	}
}

internal class PrivateConstructorAccess {}