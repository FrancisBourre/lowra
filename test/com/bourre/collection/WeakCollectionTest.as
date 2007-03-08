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

package com.bourre.collection
{
	import flexunit.framework.TestCase;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	public class WeakCollectionTest
		extends TestCase
	{
		private const CALL_TIMEOUT:int = 500;
		
		private var _c : WeakCollection;
		private var _o : Object;
		
		public override function setUp() : void
		{
			_c = new WeakCollection();
			_o = new Object();
		}
		
		public function testConstruct() : void
		{
			assertNotNull( "WeakCollection constructor returns null", new WeakCollection() );
			var c : WeakCollection = new WeakCollection( [this, _o] );
			assertFalse( "WeakCollection.isEmpty() returns 'true'", c.isEmpty() );
			assertEquals( "WeakCollection.size() doesn't return '2'", c.size(), 2 );
			assertTrue( "WeakCollection.contains(this) doesn't return true", c.contains( this ) );
			assertTrue( "WeakCollection.contains(_o) doesn't return true", c.contains( _o ) );
		}
		
		public function testWeak() : void
		{
			_c.add( new Object() );
			_c.add(this);
			var t : Timer = new Timer( CALL_TIMEOUT, 1 );
			t.addEventListener( TimerEvent.TIMER, addAsync( _onTestWeak, CALL_TIMEOUT + 500 ) );
			t.start();
		}
		
		private function _onTestWeak( event : TimerEvent ) : void
		{
			assertEquals( "WeakCollection instance is not weak", _c.size(), 1 );
		}

		public function testAdd() : void
		{
			assertTrue( "WeakCollection instance is not empty", _c.isEmpty() );
			assertFalse( "WeakCollection.contains(this) returns true with no push", _c.contains( this ) );
			assertTrue( "WeakCollection.add(this) doesn't return true", _c.add( this ) );
			assertFalse( "WeakCollection.add(this) doesn't return false on second add", _c.add( this ) );
			assertFalse( "WeakCollection instance is empty", _c.isEmpty() );
			assertTrue( "WeakCollection.contains() doesn't return true after push", _c.contains( this ) );
			assertEquals( "WeakCollection.size() doesn't return '1' after adding 'this'", _c.size(), 1 );
		}
		
		public function testRemove() : void
		{
			_c.add( this );
			assertTrue( "WeakCollection.remove(this) doesn't return true", _c.remove( this ) );
			assertFalse( "WeakCollection.remove(this) doesn't return false on second remove", _c.remove( this ) );
			assertTrue( "WeakCollection instance is not empty", _c.isEmpty() );
			assertFalse( "WeakCollection.contains(this) returns true after remove call", _c.contains( this ) );
			assertFalse( "WeakCollection.size() doesn't return '1' after aading 'this'", ( _c.size() > 0 ) );
		}
		
		public function testClear() : void
		{
			_c.add( this );
			_c.clear();
			assertTrue( "WeakCollection instance is not empty", _c.isEmpty() );
		}
		
		public function testToArray() : void
		{
			var c : WeakCollection = new WeakCollection( [1, 2] );
			var a : Array = c.toArray();
			assertTrue( "WeakCollection.toArray() returns Array with abnormal length", a.length == 2 );
			assertTrue( "WeakCollection.toArray() returns Array with identical values", a[0] != a[1] );
			assertTrue( "WeakCollection.toArray() returns Array with values not contained in WeakCollection", c.contains(a[0]) && c.contains(a[1]) );
			assertNotNull( "WeakCollection.toArray() returns Array with null value",  a[0] );
			assertNotNull( "WeakCollection.toArray() returns Array with null value",  a[1] );
		}
		
		public function testIterator() : void
		{
			_c.add( this );
			_c.add( _o );
			var i : Iterator = _c.iterator();
			assertNotNull( "WeakCollection.iterator() returns null", i );
			var n : uint = 0;
			while( i.hasNext() ) 
			{
				n++;
				var o : Object = i.next();
				assertTrue( "WeakCollection.iterator().next() doesn't return expected value", (o == this) || (o == _o) );
			}
			assertEquals( "WeakCollection.iterator() iterations count doesn't equals WeakCollection.size()", _c.size(), n );
			i.remove();
			assertEquals( "WeakCollection.iterator().remove() failed", _c.size(), 1 );
		}
		
		public function testContainsAll() : void
		{
			var c : WeakCollection = new WeakCollection( [this, _o] );
			assertFalse( "WeakCollection.containsAll( c ) returns true", _c.containsAll( c ) );
			_c.add( this );
			_c.add( _o );
			assertTrue( "WeakCollection.containsAll( c ) returns false", _c.containsAll( c ) );
			var o : Object = new Object();
			_c.add( o );
			assertTrue( "WeakCollection.containsAll( c ) returns false after adding '4'", _c.containsAll( c ) );
		}
		
		public function testAddAll() : void
		{
			var c : WeakCollection = new WeakCollection( [this, _o] );
			assertTrue( "WeakCollection.addAll( c ) returns false", _c.addAll( c ) );
			assertFalse( "WeakCollection.addAll( c ) returns true on second add", _c.addAll( c ) );
			assertTrue( "WeakCollection.containsAll( c ) returns false", _c.containsAll( c ) );
		}
		
		public function testRemoveAll() : void
		{
			var c : WeakCollection = new WeakCollection( [this, _o] );
			_c.addAll( c );
			var o : Object = new Object();
			_c.add( o );
			assertTrue( "WeakCollection.removeAll( c ) returns false", _c.removeAll( c ) );
			assertFalse( "WeakCollection.removeAll( c ) returns true on second remove", _c.removeAll( c ) );
			assertTrue( "WeakCollection.contains(o) returns false", _c.contains(o) );
		}
		
		public function testRetainAll() : void
		{
			var c : WeakCollection = new WeakCollection( [this, _o] );
			_c.addAll( c );
			var o : Object = new Object();
			_c.add( o );
			assertTrue( "WeakCollection.retainAll( c ) returns false", _c.retainAll( c ) );
			assertFalse( "WeakCollection.retainAll( c ) returns true on second retain", _c.retainAll( c ) );
			assertFalse( "WeakCollection.contains(o) returns true", _c.contains(o) );
		}
	}
}