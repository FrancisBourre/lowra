package com.bourre.plugin
{
	import flexunit.framework.TestCase;
	
	import com.bourre.plugin.NullPlugin;
	import com.bourre.model.ModelLocator;
	import com.bourre.view.ViewLocator;	
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
	 * @author Steve Lombard
	 * @version 1.0
	 */		
	public class NullPluginTest
		extends TestCase
	{
		private var _nP : NullPlugin;
		public override function setUp() : void
		{
			_nP = NullPlugin.getInstance();
		}
		
		public function testConstruct() : void
		{
			assertNotNull( "NullPlugin getInstance() return null", _nP );
			assertTrue( "NullPlugin getInstance() not return an object 'NullPlugin'", _nP is NullPlugin );
			assertStrictlyEquals( "NullPlugin getInstance() not return an object 'NullPlugin'", _nP, NullPlugin.getInstance() );			
		}		
		
		public function testGetLogger() : void
		{
			assertNotNull( "NullPlugin getLogger() return null", _nP.getLogger() );
			assertTrue( "NullPlugin getLogger() not return an object 'PluginDebug'", _nP.getLogger() is PluginDebug );			
		}
		
		public function testGetModelLocator() : void
		{
			assertNotNull( "NullPlugin getModelLocator() return null", _nP.getModelLocator() );
			assertTrue( "NullPlugin getModelLocator() not return an object 'PluginDebug'", _nP.getModelLocator() is ModelLocator );			
		}	
		
		public function testGetViewLocator() : void
		{
			assertNotNull( "NullPlugin getViewLocator() return null", _nP.getViewLocator() );
			assertTrue( "NullPlugin getViewLocator() not return an object 'PluginDebug'", _nP.getViewLocator() is ViewLocator );			
		}			
			
	}
}