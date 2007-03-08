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

package com.bourre.utils
{
	import com.bourre.log.LogLevel;
	import com.bourre.log.Logger;
	import com.bourre.log.PixlibDebug;
	
	import flexunit.framework.TestCase;
	import com.bourre.events.EventChannel;

	public class SosLayoutTest 
		extends TestCase
	{
		public function testConstruct() : void
		{
			assertNotNull( "SosLayout.getInstance() returns null", SosLayout.getInstance() );
		}
		
		public function testAsLogListener() : void
		{
			Logger.getInstance().removeAllListeners();
			
			Logger.getInstance().addLogListener( SosLayout.getInstance(), PixlibDebug.CHANNEL );
			assertTrue( "", Logger.getInstance().hasListener( PixlibDebug.CHANNEL ) );
		}
		
		public function testLogDispatch() : void
		{
			Logger.getInstance().removeAllListeners();
			Logger.getInstance().setLevel( LogLevel.ALL );
			
			Logger.getInstance().addLogListener( SosLayout.getInstance(), PixlibDebug.CHANNEL );
			assertTrue( "", Logger.getInstance().hasListener( PixlibDebug.CHANNEL ) );
			
			var b : Boolean = Logger.LOG( "hello", LogLevel.DEBUG, PixlibDebug.CHANNEL );
			assertTrue( "Logger.getInstance().log() didn't return true", b );
		}
		
		public override function tearDown() : void
		{
			Logger.getInstance().removeAllListeners();
			Logger.getInstance().setLevel( LogLevel.ALL );
			Logger.getInstance().addLogListener( SosLayout.getInstance(), PixlibDebug.CHANNEL );
			Logger.getInstance().addLogListener( FlashInspectorLayout.getInstance(), PixlibDebug.CHANNEL );
		}
	}
}