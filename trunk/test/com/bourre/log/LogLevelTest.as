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
	import com.bourre.log.*;

	public class LogLevelTest 
		extends TestCase
	{
		public function testConstruct() : void
		{
			var o : LogLevel = new LogLevel();
			assertNotNull( "LogLevel constructor returns null", o );
		}
		
		/*public function testLevelHierarchy() : void
		{
			assertTrue( "LogLevel.ALL.getLevel() >= LogLevel.DEBUG.getLevel()", LogLevel.ALL.getLevel() < LogLevel.DEBUG.getLevel() );
			assertTrue( "LogLevel.DEBUG.getLevel() >= LogLevel.INFO.getLevel()", LogLevel.DEBUG.getLevel() < LogLevel.INFO.getLevel() );
			assertTrue( "LogLevel.INFO.getLevel() >= LogLevel.WARN.getLevel()", LogLevel.INFO.getLevel() < LogLevel.WARN.getLevel() );
			assertTrue( "LogLevel.WARN.getLevel() >= LogLevel.ERROR.getLevel()", LogLevel.WARN.getLevel() < LogLevel.ERROR.getLevel() );
			assertTrue( "LogLevel.ERROR.getLevel() >= LogLevel.FATAL.getLevel()", LogLevel.ERROR.getLevel() < LogLevel.FATAL.getLevel() );
			assertTrue( "LogLevel.FATAL.getLevel() >= LogLevel.OFF.getLevel()", LogLevel.FATAL.getLevel() < LogLevel.OFF.getLevel() );
		}*/
		
		public function testAllLevel() : void
		{
			var o : LogLevel = LogLevel.ALL;
			assertEquals( "LogLevel.All.getLevel() doesn't return expected level", o.getLevel(), uint.MIN_VALUE );
			assertEquals( "LogLevel.All.getLevel() doesn't return expected name", o.getName(), "ALL" );
		}
		
		public function testDebugLevel() : void
		{
			var o : LogLevel = LogLevel.DEBUG;
			assertEquals( "LogLevel.DEBUG.getLevel() doesn't return expected level", o.getLevel(), 10000 );
			assertEquals( "LogLevel.DEBUG.getLevel() doesn't return expected name", o.getName(), "DEBUG" );
		}
		
		public function testInfoLevel() : void
		{
			var o : LogLevel = LogLevel.INFO;
			assertEquals( "LogLevel.INFO.getLevel() doesn't return expected level", o.getLevel(), 20000 );
			assertEquals( "LogLevel.INFO.getLevel() doesn't return expected name", o.getName(), "INFO" );
		}
		
		public function testWarnLevel() : void
		{
			var o : LogLevel = LogLevel.WARN;
			assertEquals( "LogLevel.WARN.getLevel() doesn't return expected level", o.getLevel(), 30000 );
			assertEquals( "LogLevel.WARN.getLevel() doesn't return expected name", o.getName(), "WARN" );
		}
		
		public function testErrorLevel() : void
		{
			var o : LogLevel = LogLevel.ERROR;
			assertEquals( "LogLevel.ERROR.getLevel() doesn't return expected level", o.getLevel(), 40000 );
			assertEquals( "LogLevel.ERROR.getLevel() doesn't return expected name", o.getName(), "ERROR" );
		}
		
		public function testFatalLevel() : void
		{
			var o : LogLevel = LogLevel.FATAL;
			assertEquals( "LogLevel.FATAL.getLevel() doesn't return expected level", o.getLevel(), 50000 );
			assertEquals( "LogLevel.FATAL.getLevel() doesn't return expected name", o.getName(), "FATAL" );
		}
		
		public function testOffLevel() : void
		{
			var o : LogLevel = LogLevel.OFF;
			assertEquals( "LogLevel.OFF.getLevel() doesn't return expected level", o.getLevel(), uint.MAX_VALUE );
			assertEquals( "LogLevel.OFF.getLevel() doesn't return expected name", o.getName(), "OFF" );
		}
	}
}