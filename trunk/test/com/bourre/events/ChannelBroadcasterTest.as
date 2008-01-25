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
	import flexunit.framework.TestCase;
	import flash.events.Event;
	import com.bourre.log.LogLevel;
	import com.bourre.log.PixlibDebug;
	
	public class ChannelBroadcasterTest 
		extends TestCase
	{
		private const CALL_TIMEOUT:int = 1000;
		
		public var cb : ChannelBroadcaster;
		public var channel : EventChannel;
		
		private var _e : Event;
		
		public override function setUp() : void
		{
			channel = PixlibDebug.CHANNEL;
			cb = new ChannelBroadcaster( EventBroadcaster, channel );
			
		}
		
		public function onTestEvent( e : Event ) : void
		{
			_e = e;
		}
		
		public function testConstruct() : void
		{
			assertNotNull( "ChannelBroadcaster constructor returns null", cb );
		}
		
		public function testGetChannelDispatcher() : void
		{
			assertTrue( "ChannelBroadcaster.getChannelDispatcher() doesn't return EventDispatcher instance", cb.getChannelDispatcher( channel ) is EventBroadcaster);
		}
		
		public function testHasChannelDispatcher() : void
		{
			cb.empty();

			assertTrue( "ChannelBroadcaster.hasChannelDispatcher() doesn't return true", cb.hasChannelDispatcher( channel ));
		}
		
		public function testAddEventListenerWithoutChannel() : void
		{
			cb.empty();
			cb.addEventListener( "onTestEvent", this);

			assertTrue( "ChannelBroadcaster.addEventListener( null ) failed", cb.getChannelDispatcher().hasListenerCollection( "onTestEvent" ));
		}
		
		public function testRemoveEventListenerWithoutChannel() : void
		{
			cb.empty();
			cb.addEventListener( "onTestEvent", this );
			cb.removeEventListener( "onTestEvent", this );
			
			assertFalse( "ChannelBroadcaster.removeEventListener( null ) failed", cb.getChannelDispatcher().hasListenerCollection( "onTestEvent" ));
		}
		
		public function testAddEventListenerWithChannel() : void
		{
			cb.empty();
			cb.addEventListener( "onTestEvent", this, channel );

			assertTrue( "ChannelBroadcaster.addEventListener( channel ) failed", cb.getChannelDispatcher( channel ).hasListenerCollection( "onTestEvent" ));
		}
		
		public function testRemoveEventListenerWithChannel() : void
		{
			cb.empty();
			cb.addEventListener( "onTestEvent", this, channel );
			cb.removeEventListener( "onTestEvent", this, channel );
			
			assertFalse( "ChannelBroadcaster.removeEventListener( channel ) failed", cb.getChannelDispatcher( channel ).hasListenerCollection( "onTestEvent" ));
		}
		
		public function testRemoveEventListenerOnWrongChannel() : void
		{
			cb.empty();
			cb.addEventListener( "onTestEvent", this, PixlibDebug.CHANNEL );
			cb.removeEventListener( "onTestEvent", this, new OtherChannel() );
			
			assertTrue( "ChannelBroadcaster.removeEventListener( channel ) doesn't work as expected", cb.getChannelDispatcher( channel ).hasListenerCollection( "onTestEvent" ));
		}
		
		public function testDispatchEventWithChannel() : void
		{
			_e = null;
			cb.empty();
			cb.addEventListener( "onTestEvent", this, channel );
			cb.broadcastEvent( new Event( "onTestEvent" ), channel );
			assertNotNull( "ChannelBroadcaster.dispatchEvent() with channel failed", _e );
		}
		
		public function testDispatchEventWithoutChannel() : void
		{
			_e = null;
			cb.empty();
			cb.addEventListener( "onTestEvent", this );
			cb.broadcastEvent( new Event( "onTestEvent" ) );
			assertNotNull( "ChannelBroadcaster.dispatchEvent() without channel failed", _e );
		}
	}
}

import com.bourre.events.EventChannel;

internal class OtherChannel 
	extends EventChannel
{
	public static const CHANNEL : EventChannel = new OtherChannel();
	
	public function OtherChannel()
	{
	}
}