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
	import flexunit.framework.TestCase;
	
	public class LogEventTest 
		extends TestCase
	{
		public function testConstruct() : void
		{
			var o : LogEvent = new LogEvent( LogLevel.ALL );
			assertNotNull( "LogEvent constructor returns null", o );
		}
		
		public function testOnLogConst() : void
		{
			assertEquals( "LogEvent.onLogEVENT doesn't return expected String value", LogEvent.onLogEVENT, "onLog" );
		}
		
		public function testLevelProperty() : void
		{
			var o : LogEvent = new LogEvent( LogLevel.DEBUG );
			assertStrictlyEquals( "LogEvent.level doesn't return expected LogLevel instance", o.level, LogLevel.DEBUG );
		}
		
		public function testMessageProperty() : void
		{
			var o : LogEvent = new LogEvent( LogLevel.DEBUG, "hello" );
			assertEquals( "LogEvent.message doesn't return expected String value", o.message, "hello" );
		}
		
		public function testClone() : void
		{
			var o1 : LogEvent = new LogEvent( LogLevel.DEBUG, "hello" );
			var o2 : LogEvent = o1.clone() as LogEvent;
			assertStrictlyEquals( "LogEvent.clone mehtod failed, 'level' property wasn't cloned as expected", o1.level, o2.level );
			assertEquals( "LogEvent.clone mehtod failed, 'message' property wasn't cloned as expected", o1.message, o2.message );
		}
	}
}