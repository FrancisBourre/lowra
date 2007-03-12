package com.bourre.load
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

	import flexunit.framework.TestCase;
	
	public class AbstractLoaderTest 
		extends TestCase
	{
		private var _l : MockAbstractLoader;

		public override function setUp() : void
		{
			_l = new MockAbstractLoader();
		}

		public function testConstruct() : void
		{
			assertNotNull( "MockLoader constructor returns null", _l );
		}

		public function testGetSetURL() : void
		{
			var url : String = "http://www.tweenpix.net";
			_l.setURL( url );
			assertEquals( "AbstractLoader.getURL doesn't return value passed to AbstractLoader.setURL", url, _l.getURL() );
		}

		public function testGetSetTimeOut() : void
		{
			var time : Number = 1000;
			_l.setTimeOut( time );
			assertEquals( "AbstractLoader.getTimeOut doesn't return value passed to AbstractLoader.setTimeOut", time, _l.getTimeOut() );
		}

		public function testGetSetAntiCache() : void
		{
			var b : Boolean = true;
			_l.setAntiCache( b );
			assertEquals( "AbstractLoader.isAntiCache doesn't return value passed to AbstractLoader.setAntiCache", b, _l.isAntiCache() );
		}

		public function testPrefixURL() : void
		{
			var prefix : String = "http://www.tweenpix.net/";
			var url : String = "blog";
			
			_l.setURL( url );
			_l.prefixURL( prefix );
			assertEquals( "AbstractLoader.getURL doesn't return value passed to AbstractLoader.setURL and AbstractLoader.prefixURL", prefix+url, _l.getURL());
		}
	}
}