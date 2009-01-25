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
	 
package com.bourre.ioc.assembler.channel
{
	import com.bourre.commands.Batch;
	import com.bourre.core.AbstractLocator;
	import com.bourre.error.PrivateConstructorException;
	import com.bourre.events.ApplicationBroadcaster;
	import com.bourre.ioc.bean.BeanFactory;
	import com.bourre.plugin.PluginChannel;	
	
	/**
	 *  Dispatched when a channel listener is registered.
	 *  
	 *  @eventType com.bourre.ioc.assembler.channel.ChannelListenerEvent.onRegisterChannelListenerEVENT
	 */
	[Event(name="onRegisterChannelListener", type="com.bourre.ioc.assembler.channel.ChannelListenerEvent")]
	
	/**
	 *  Dispatched when a channel listener is unregistered.
	 *  
	 *  @eventType com.bourre.ioc.assembler.channel.ChannelListenerEvent.onUnregisterChannelListenerEVENT
	 */
	[Event(name="onUnregisterChannelListener", type="com.bourre.ioc.assembler.channel.ChannelListenerEvent")]
	
	/**
	 * The ChannelListenerExpert class is a locator for 
	 * <code>ChannelListener</code> object.
	 * 
	 * @see ChannelListener	 * 
	 * @author Francis Bourre
	 */
	public class ChannelListenerExpert extends AbstractLocator
	{
		//--------------------------------------------------------------------
		// Private properties
		//--------------------------------------------------------------------

		private static var _oI : ChannelListenerExpert;

		
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
		
		/**
		 * Returns the unique <code>ChannelListenerExpert</code> instance.
		 * 
		 * @return The unique <code>ChannelListenerExpert</code> instance.
		 */
		public static function getInstance() : ChannelListenerExpert
		{
			if ( !(ChannelListenerExpert._oI is ChannelListenerExpert) ) 
				ChannelListenerExpert._oI = new ChannelListenerExpert( new PrivateConstructorAccess( ) );

			return ChannelListenerExpert._oI;
		}
		
		/**
		 * Releases singleton.
		 */
		public static function release() : void
		{
			ChannelListenerExpert._oI = null ;
		}
		
		/**
		 * Dispatches <code>ChannelListenerEvent</code> event using passed-in 
		 * arguments as event properties when a <code>ChannelListener</code> is 
		 * registered in locator.
		 * 
		 * <p>Event type is <code>ChannelListenerEvent.onRegisterChannelListenerEVENT</code></p>
		 * 
		 * @param	name	Name of the registered <code>ChannelListener</code>
		 * @param	o		The registered <code>ChannelListener</code>
		 * 
		 * @see ChannelListener
		 * @see ChannelListenerEvent
		 * @see ChannelListenerEvent#onRegisterChannelListenerEVENT
		 */
		override protected function onRegister( id : String = null, channelListener : Object = null ) : void
		{
			broadcastEvent( new ChannelListenerEvent( ChannelListenerEvent.onRegisterChannelListenerEVENT, id, channelListener as ChannelListener ) );
		}
		
		/**
		 * Dispatches <code>ChannelListenerEvent</code> event using passed-in 
		 * arguments as event properties when a <code>ChannelListener</code> is 
		 * unregistered from locator.
		 * 
		 * <p>Event type is <code>ChannelListenerEvent.onUnregisterChannelListenerEVENT</code></p>
		 * 
		 * @param	name	Name of the registredred <code>ChannelListener</code>
		 * @param	o		The registered <code>ChannelListener</code>
		 * 
		 * @see ChannelListener
		 * @see ChannelListenerEvent
		 * @see ChannelListenerEvent#onUnregisterChannelListenerEVENT
		 */
		override protected function onUnregister( id : String = null ) : void
		{
			broadcastEvent( new ChannelListenerEvent( ChannelListenerEvent.onUnregisterChannelListenerEVENT, id ) );
		}
		
		/**
		 * Assign all channels.
		 * 
		 * @see #assignChannelListener()
		 */
		public function assignAllChannelListeners() : void
		{
			Batch.process( assignChannelListener, getKeys( ) );
		}
		
		/**
		 * Assign channel for passed-in channel listener ID.
		 * 
		 * @param	id	ID of a registered <code>ChannelListener</code>
		 * 
		 * @return	<code>true</code> if success
		 */
		public function assignChannelListener( id : String ) : Boolean
		{
			var channelListener : ChannelListener = locate( id ) as ChannelListener;
			var listener : Object = BeanFactory.getInstance( ).locate( channelListener.listenerID );
			var channel : PluginChannel = PluginChannel.getInstance( channelListener.channelName );

			var args : Array = channelListener.arguments;
			
			if ( args && args.length > 0 )
			{
				var l : int = args.length;
				for ( var i : int; i < l ; i++ )
				{
					var o : Object = args[ i ];
					var method : String = o.method;
					listener = ( method && listener.hasOwnProperty( method ) && listener[method] is Function) ? listener[method] : listener[o.type];
					ApplicationBroadcaster.getInstance( ).addEventListener( o.type, listener, channel );
				}

				return true;
			} 
			else 
			{
				return ApplicationBroadcaster.getInstance( ).addListener( listener, channel );
			}
		}
		
		/**
		 * @copy com.bourre.events.Broadcaster#addListener()
		 */
		public function addListener( listener : ChannelListenerExpertListener ) : Boolean
		{
			return getBroadcaster( ).addListener( listener );
		}
		
		/**
		 * @copy com.bourre.events.Broadcaster#removeListener()
		 */
		public function removeListener( listener : ChannelListenerExpertListener ) : Boolean
		{
			return getBroadcaster( ).removeListener( listener );
		}
		
		//--------------------------------------------------------------------
		// Private implementation
		//--------------------------------------------------------------------
		
		/** @private */
		function ChannelListenerExpert( access : PrivateConstructorAccess )
		{
			super( ChannelListener, ChannelListenerExpertListener, null );
			
			if ( !(access is PrivateConstructorAccess) ) throw new PrivateConstructorException( );
		}		
	}
}

internal class PrivateConstructorAccess 
{
}