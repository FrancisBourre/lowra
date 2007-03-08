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
	import com.bourre.collection.*;
	
	public class HashMapTest 
		extends TestCase
	{
		private var _m : HashMap;
		
		public override function setUp() : void
		{
			_m = new HashMap();
		}
		
		public function testConstruct() : void
		{
			assertNotNull( "Map constructor returns null", _m );
		}
		
		public function testPutObjectObject() : void
		{
			var o1 : Object = new Object();
			var o2 : Object = new Object();
			_m.put( o1, o2 );
			
			assertStrictlyEquals( "Map.put( Object, Object ) - test1 failed", _m.get( o1 ), o2 );
			assertTrue( "Map.put( Object, Object ) - test2 failed", _m.containsKey( o1 ) );
			assertTrue( "Map.put( Object, Object ) - test3 failed", _m.containsValue( o2 ) );
			assertEquals( "Map.put( Object, Object ) - test4 failed", _m.size(), 1 );
		}
		
		public function testPutStringObject() : void
		{
			var s : String = "test";
			var o : Object = new Object();
			_m.put( s, o );
			
			assertStrictlyEquals( "Map.put( String, Object ) - test1 failed", _m.get( s ), o );
			assertTrue( "Map.put( String, Object ) - test2 failed", _m.containsKey( s ) );
			assertTrue( "Map.put( String, Object ) - test3 failed", _m.containsValue( o ) );
			assertEquals( "Map.put( String, Object ) - test4 failed", _m.size(), 1 );
		}
		
		public function testPutNumberObject() : void
		{
			var n : Number = 12.27;
			var o : Object = new Object();
			_m.put( n, o );
			
			assertStrictlyEquals( "Map.put( Number, Object ) - test1 failed", _m.get( n ), o );
			assertTrue( "Map.put( Number, Object ) - test2 failed", _m.containsKey( n ) );
			assertTrue( "Map.put( Number, Object ) - test3 failed", _m.containsValue( o ) );
			assertEquals( "Map.put( Number, Object ) - test4 failed", _m.size(), 1 );
		}
		
		public function testRemoveObjectObject() : void
		{
			var o1 : Object = new Object();
			var o2 : Object = new Object();
			_m.put( o1, o2 );
			
			var r : * = _m.remove( o1 );
			
			assertNull( "Map.remove( Object ) with Object key - test1 failed", _m.get( o1 ) );
			assertFalse( "Map.remove( Object ) with Object key - test2 failed", _m.containsKey( o1 ) );
			assertFalse( "Map.remove( Object ) with Object key - test3 failed", _m.containsValue( o2 ) );
			assertEquals( "Map.remove( Object ) with Object key - test4 failed", _m.size(), 0 );
			assertStrictlyEquals( "Map.remove( Object ) with Object key - test5 failed", r, o2 );
			assertNull( "Map.remove( Object ) with Object key - test6 failed", _m.remove( o1 ) );
		}
		
		public function testRemoveStringObject() : void
		{
			var s : String = "test";
			var o : Object = new Object();
			_m.put( s, o );
			
			var r : * = _m.remove( s );
			
			assertNull( "Map.remove( String ) with Object key - test1 failed", _m.get( s ) );
			assertFalse( "Map.remove( String ) with Object key - test2 failed", _m.containsKey( s ) );
			assertFalse( "Map.remove( String ) with Object key - test3 failed", _m.containsValue( o ) );
			assertEquals( "Map.remove( String ) with Object key - test4 failed", _m.size(), 0 );
			assertStrictlyEquals( "Map.remove( String ) with Object key - test5 failed", r, o );
			assertNull( "Map.remove( String ) with Object key - test6 failed", _m.remove( s ) );
		}
		
		public function testRemoveNumberObject() : void
		{
			var n : Number = 12.27;
			var o : Object = new Object();
			_m.put( n, o );
			
			var r : * = _m.remove( n );
			
			assertNull( "Map.remove( Number ) with Object key - test1 failed", _m.get( n ) );
			assertFalse( "Map.remove( Number ) with Object key - test2 failed", _m.containsKey( n ) );
			assertFalse( "Map.remove( Number ) with Object key - test3 failed", _m.containsValue( o ) );
			assertEquals( "Map.remove( Number ) with Object key - test4 failed", _m.size(), 0 );
			assertStrictlyEquals( "Map.remove( Number ) with Object key - test5 failed", r, o );
			assertNull( "Map.remove( Number ) with Object key - test6 failed", _m.remove( n ) );
		}
		
		public function testPutSameKeyTwice() : void
		{
			var k : Object = new Object();
			var v1 : Object = new Object();
			var v2 : Object = new Object();
			
			_m.put( k, v1 );
			_m.put( k, v2 );
			
			assertStrictlyEquals( "Map.put( Object, Object ) twice with the same key - test1 failed", _m.get( k ), v2 );
			assertEquals( "Map.put( Object, Object ) twice with the same key - test2 failed", _m.size(), 1 );
			assertTrue( "Map.put( Object, Object ) twice with the same key - test3 failed", _m.containsValue( v2 ) );
			assertFalse( "Map.put( Object, Object ) twice with the same key - test4 failed", _m.containsValue( v1 ) );
		}
		
		public function testRemoveWithKeyPutTwice() : void
		{
			var k : Object = new Object();
			var v1 : Object = new Object();
			var v2 : Object = new Object();
			
			_m.put( k, v1 );
			_m.put( k, v2 );
			
			var r : * = _m.remove( k );
			
			assertNull( "Map.remove( Object ) put twice with the same key - test1 failed", _m.get( k ) );
			assertEquals( "Map.remove( Object ) put twice with the same key - test2 failed", _m.size(), 0 );
			assertStrictlyEquals( "Map.remove( Object ) put twice with the same key - test3 failed", r, v2 );
			assertFalse( "Map.remove( Object ) put twice with the same key - test4 failed", _m.containsValue( v1 ) );
			assertFalse( "Map.remove( Object ) put twice with the same key - test5 failed", _m.containsValue( v2 ) );
		}
		
		public function testPutSameValueTwice() : void
		{
			var k1 : Object = new Object();
			var k2 : Object = new Object();
			var v : Object = new Object();
			
			_m.put( k1, v );
			_m.put( k2, v );
			
			assertStrictlyEquals( "Map.put( Object, Object ) twice with the same value - test1 failed", _m.get( k1 ), v );
			assertStrictlyEquals( "Map.put( Object, Object ) twice with the same value - test2 failed", _m.get( k2 ), v );
			assertEquals( "Map.put( Object, Object ) twice with the same value - test3 failed", _m.size(), 2 );
			assertTrue( "Map.put( Object, Object ) twice with the same value - test 4 failed", _m.containsValue( v ) );
		}
		
		public function testRemoveWithValuePutTwice() : void
		{
			var k1 : Object = new Object();
			var k2 : Object = new Object();
			var v : Object = new Object();
			
			_m.put( k1, v );
			_m.put( k2, v );		
			var r : * = _m.remove( k2 );
			
			assertStrictlyEquals( "Map.remove( Object ) put twice with the same value - test1 failed", _m.get( k1 ), v );
			assertNull( "Map.remove( Object ) put twice with the same value - test2 failed", _m.get( k2 ) );
			assertEquals( "Map.remove( Object ) put twice with the same value - test3 failed", _m.size(), 1 );
			assertTrue( "Map.remove( Object ) put twice with the same value - test4 failed", _m.containsValue( v ) );
		}
		
		public function testGetKeys() : void
		{
			var k : Object = new Object();
			var v : Object = new Object();
			
			_m.put( k, v );
			
			var a : Array = _m.getKeys();
			
			assertStrictlyEquals( "Map.getKeys() - test1 failed", a[0], k );
			assertEquals( "Map.getKeys() - test2 failed", a.length, 1 );
		}
		
		public function testGetValues() : void
		{
			var k : Object = new Object();
			var v : Object = new Object();
			
			_m.put( k, v );
			var a : Array = _m.getValues();

			assertStrictlyEquals( "Map.getValues() - test1 failed", a[0], v );
			assertEquals( "Map.getValues() - test2 failed", a.length, 1 );
		}
	}
}