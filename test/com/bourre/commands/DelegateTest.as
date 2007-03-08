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

package com.bourre.commands
{
	import flexunit.framework.TestCase;
	import flash.events.Event;

	public class DelegateTest 
		extends TestCase
	{
		private var _e : Event;
		private var _n : int;
		
		public override function setUp() : void
		{
			_e = null;
			_n = -1;
			
		}
		
		public function standardCallback( n : int ) : void
		{
			_n = n;
		}
		
		public function eventCallbackNoArgs( e : Event ) : void
		{
			_e = e;
		}
		
		public function eventCallbackArgs( e : Event, n : int ) : void
		{
			_e = e;
			_n = n;
		}
		
		public function testConstruct() : void
		{
			assertNotNull( "Delegate constructor returns null", new Delegate( standardCallback, 0 ) );
		}
		
		public function testExecute() : void
		{
			var d : Delegate = new Delegate( standardCallback, 0 );
			d.execute();
			assertEquals( "Delegate.execute() failed", _n, 0 );
		}
		
		public function testHandleEventWithoutArguments() : void
		{
			var d : Delegate = new Delegate( eventCallbackNoArgs );
			d.handleEvent( new Event("test") );
			assertNotNull( "Delegate.handleEvent() without arguments failed", _e );
		}
		
		public function testHandleEventWithArguments() : void
		{
			var d : Delegate = new Delegate( eventCallbackArgs, 1 );
			d.handleEvent( new Event("test") );
			assertNotNull( "Delegate.handleEvent() with arguments failed", _e );
			assertEquals( "Delegate.handleEvent() with arguments failed", _n, 1 );
		}
	}
}