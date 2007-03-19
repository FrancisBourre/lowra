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

package com.bourre.log
{
	import com.bourre.events.EventChannel;
	import com.bourre.utils.FlashInspectorLayout;
	import com.bourre.utils.SosLayout;
	
	import flexunit.framework.TestCase;
	
	public class LoggerTest 
		extends TestCase 
		implements ILogListener
	{
		private const CALL_TIMEOUT:int = 1000;
		private var _e : LogEvent;
		
		public override function tearDown() : void
		{
			Logger.getInstance().removeAllListeners();
			Logger.getInstance().setLevel( LogLevel.ALL );
			Logger.getInstance().addLogListener( SosLayout.getInstance(), PixlibDebug.CHANNEL );
			Logger.getInstance().addLogListener( FlashInspectorLayout.getInstance(), PixlibDebug.CHANNEL );
		}
		
		public function onLog( e : LogEvent ) : void
		{
			_e = e;
		}
		
		public function testConstruct() : void
		{
			assertNotNull( "Logger.getInstance() returns null", Logger.getInstance() );
		}
		
		public function testLevelAccessor() : void
		{
			Logger.getInstance().setLevel( LogLevel.FATAL );
			assertStrictlyEquals( "Logger.getInstance().getLevel() doesn't return expected LogLevel instance", Logger.getInstance().getLevel(), LogLevel.FATAL );
		}
		
		public function testHasListener() : void
		{
			Logger.getInstance().removeAllListeners();
			
			assertFalse( "Logger.getInstance().hasListener() doesn't return false", Logger.getInstance().hasListener() );
			Logger.getInstance().addLogListener( this );
			assertTrue( "Logger.getInstance().hasListener() doesn't return true", Logger.getInstance().hasListener() );
		}
		
		public function testRemoveListener() : void
		{
			Logger.getInstance().removeAllListeners();
			
			Logger.getInstance().addLogListener( this );
			Logger.getInstance().removeLogListener( this );
			assertFalse( "Logger.getInstance().removeListener() failed", Logger.getInstance().hasListener() );
		}
		
		public function testRemoveAllListeners() : void
		{
			Logger.getInstance().addLogListener( this );
			
			Logger.getInstance().removeAllListeners();
			assertFalse( "Logger.getInstance().removeAllListeners() failed", Logger.getInstance().hasListener() );
		}
		
		public function testBasicLog() : void
		{
			_e = null;
			Logger.getInstance().removeAllListeners();
			Logger.getInstance().setLevel( LogLevel.ALL );

			Logger.getInstance().addLogListener( this );
			
			assertTrue( "Logger.getInstance().hasListener() doesn't return true", Logger.getInstance().hasListener() );
			
			var b : Boolean = Logger.getInstance().log( new LogEvent( LogLevel.WARN, "hello" ) );
			
			assertTrue( "Logger.getInstance().log() didn't return true with default log level", b );
			assertEquals( "Wrong LogEvent.message received", _e.message, "hello" );
			assertStrictlyEquals( "Wrong LogEvent.level received", _e.level, LogLevel.WARN );
		}
		
		public function testBasicLogWithLevelOff() : void
		{
			Logger.getInstance().removeAllListeners();
			Logger.getInstance().setLevel( LogLevel.OFF );

			Logger.getInstance().addLogListener( this );
			
			assertTrue( "Logger.getInstance().hasListener() doesn't return true", Logger.getInstance().hasListener() );
			var b : Boolean = Logger.getInstance().log( new LogEvent( LogLevel.FATAL, "hello" ) );
			
			assertFalse( "Logger.getInstance().log() returns true with LogLevel.OFF", b );
		}
		
		public function testBasicLogWithChannel() : void
		{
			_e = null;
			Logger.getInstance().removeAllListeners();
			Logger.getInstance().setLevel( LogLevel.ALL );

			var channel : EventChannel = new Channel1();
			Logger.getInstance().addLogListener( this, channel );
			
			assertTrue( "Logger.getInstance().hasListener() doesn't return true on specified channel", Logger.getInstance().hasListener( channel ) );
			var b : Boolean = Logger.getInstance().log( new LogEvent( LogLevel.WARN, "hello"), channel );
			
			assertTrue( "Logger.getInstance().log() didn't return true with default log level", b );
			assertEquals( "Wrong LogEvent.message received", _e.message, "hello" );
			assertStrictlyEquals( "Wrong LogEvent.level received", _e.level, LogLevel.WARN );
		}
		
		public function testBasicLogWith2Channels() : void
		{
			_e = null;
			Logger.getInstance().removeAllListeners();
			Logger.getInstance().setLevel( LogLevel.ALL );

			var channel1 : EventChannel = new Channel1();
			var channel2 : EventChannel = new Channel2();
			
			Logger.getInstance().addLogListener( this, channel1 );
			assertTrue( "Logger.getInstance().hasListener() doesn't return true on channel1", Logger.getInstance().hasListener( channel1 ) );
			
			var b2 : Boolean = Logger.getInstance().log( new LogEvent( LogLevel.WARN, "hello"), channel2 );
			assertTrue( "Logger.getInstance().log() didn't return true with LogLevel.ALL on channel2", b2 );
			assertNull( "Logger.getInstance().log() suceeded on unexpected channel", _e );
		}
	}
}
	
import com.bourre.events.EventChannel;

internal class Channel1 
	extends EventChannel
{
	public static const CHANNEL : EventChannel = new Channel1();
	
	public function Channel1()
	{
		super( eventChannelConstructorAccess );
	}
}

internal class Channel2 
	extends EventChannel
{
	public static const CHANNEL : EventChannel = new Channel2();
	
	public function Channel2()
	{
		super( eventChannelConstructorAccess );
	}
}