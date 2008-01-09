package com.bourre.collection
{
	import flexunit.framework.TestCase;

	import com.bourre.collection.Queue;

	public class QueueTest extends TestCase
	{
		private var _oQ : Queue;

		public override function setUp () : void
		{
			_oQ = new Queue( );
		}

		public function testConstruct () : void
		{
			assertNotNull( "create new untyped Queue : ", _oQ );
		}

		public function testAdd () : void
		{
			assertTrue( _oQ + ".add() failled to add 42 [test 1]", _oQ.add( 42 ) );
			assertTrue( _oQ + ".add() failled to add \"hello\" [test 2]", _oQ.add( "hello" ) );
			var obj : Object = {id: "test"};
			assertTrue( _oQ + ".add() failled to add " + obj + "[test 3]", _oQ.add( obj ) );
			assertTrue( _oQ + ".add() failled to add twiss" + obj + "[test 4]", _oQ.add( obj ) );
			assertTrue( _oQ + ".add() failled to add  a Queue [test 5]", _oQ.add( new Stack( ) ) );
		}

		public function testContains () : void
		{
			assertFalse( _oQ + ".contains() failled on empty Collection", _oQ.contains( "hello" ) );
			_oQ.add( 'hello' );
			assertFalse( _oQ + ".contains() failled with 2", _oQ.contains( 2 ) );
			assertTrue( _oQ + ".contains() failled with string 'hello'", _oQ.contains( "hello" ) );
			_oQ.add( 2 );
			assertTrue( _oQ + ".contains() failled with number 2", _oQ.contains( 2 ) );
		}

		public function testSize () : void
		{
			assertEquals( _oQ + ".size() failled with empty Collection", _oQ.size( ), 0 );
			_oQ.add( 'hello' );
			assertEquals( _oQ + ".size() failled to return 1", _oQ.size( ), 1 );
			_oQ.add( 1 );
			assertEquals( _oQ + ".size() failled to return 2", _oQ.size( ), 2 );
		}

		public function testRemove () : void
		{
			var obj : Object = {id: "test"};
			
			_oQ.add( 42 );
			_oQ.add( 42 );
			_oQ.add( 42 );
			_oQ.add( 40 );
			_oQ.add( obj );
			_oQ.add( obj );
			
			assertTrue( _oQ + ".remove() failed to remove " + obj, _oQ.remove( obj ) );
			assertEquals( _oQ + ".size() failed to return 5 after remove [1]", 5, _oQ.size( ) );
			
			assertTrue( _oQ + ".remove() failed with" + obj, _oQ.remove( obj ) );
			assertFalse( _oQ + ".remove() failed with" + obj, _oQ.remove( obj ) );
			
			assertEquals( _oQ + ".size() failled to return 4 after remove [2]", 4, _oQ.size() );
			assertTrue( _oQ + ".remove() failled to remove " + obj, _oQ.remove( 42 ) );
			assertEquals( _oQ + ".size() failled to return 3 after remove", 3, _oQ.size() );
		}

		public function testContainAll () : void
		{
			_oQ.add( 12 );
			_oQ.add( 'bugOrNot' );
			_oQ.add( 10 );
			
			var stack2 : Queue = new Queue( );
			stack2.add( 12 );
			stack2.add( 'bugOrNot' );
			stack2.add( 'bugOrYes' );
			stack2.add( 50 );
			
			assertTrue( _oQ + ".containsAll() failled to return  true with an empty queue", _oQ.containsAll( new Queue( ) ) );
			assertFalse( _oQ + ".containsAll() failled to return false", _oQ.containsAll( stack2 ) );
			stack2.add( 10 );
			assertFalse( _oQ + ".containsAll() failled to return false [2]", _oQ.containsAll( stack2 ) );
			
			_oQ.add( 'bugOrYes' );
			_oQ.add( 50 );
			assertTrue( _oQ + ".containsAll() (" + _oQ.toArray() + "|" + stack2.toArray() +
						") failled to return true [2]",	_oQ.containsAll( stack2 ) );
		}

		public function testRetainAll () : void
		{
			_oQ.add( 12 );
			_oQ.add( 'bugOrNot' );
			_oQ.add( 'bugOrNot' );
			_oQ.add( 'bugOrYes' );
			_oQ.add( 'bugOrYes' );
			_oQ.add( 'bugOrYes' );
			_oQ.add( 'bugOrBug' );
			_oQ.add( 'bugOrBug' );
			_oQ.add( 50 );
			
			var Queue2 : Queue = new Queue( );
			Queue2.add( 12 );
			Queue2.add( 'bugOrBug' );
			Queue2.add( "hello" );
			
			assertTrue( _oQ + ".retainAll() failled  to return true with " + Queue2, _oQ.retainAll( Queue2 ) );
			assertEquals( _oQ + ".size() failled to return 3 after retainAll", 3, _oQ.size( ) );
			assertFalse( _oQ + ".retainAll() failled  to return false with " + Queue2, _oQ.retainAll( Queue2 ) );
			assertTrue( _oQ + ".retainAll() failled  to return true with empty Collection", _oQ.retainAll( new Stack( ) ) );
			assertEquals( _oQ + ".size() failled to return 0 after retainAll", 0, _oQ.size( ) );
		}

		public function testAddAll () : void
		{
			var Queue2 : Queue = new Queue( );
			Queue2.add( 12 );
			Queue2.add( 'bugOrBug' );
			Queue2.add( "hello" );
			Queue2.add( "hello" );
			
			assertTrue( _oQ + ".addAll() failled  to return true with " + Queue2, _oQ.addAll( Queue2 ) );
			assertEquals( _oQ + ".size() failled to return 3 after retainAll", 4, _oQ.size( ) );
			assertTrue( _oQ + ".containsAll() failled to return true", _oQ.containsAll( Queue2 ) );
			assertFalse( _oQ + ".addAll() failled  to return False with  an empty Collection", _oQ.addAll( new Stack( ) ) );
		}

		public function testRemoveAll () : void
		{
			var Queue2 : Queue = new Queue( );
			Queue2.add( 12 );
			Queue2.add( 'bugOrBug' );
			Queue2.add( "hello" );
			Queue2.add( "hello" );
			
			
			_oQ.add( 13 );
			_oQ.add( "hello" );
			
			assertTrue( _oQ + ".removeAll() failled  to return true [1]", _oQ.removeAll( Queue2 ) );
			assertEquals( _oQ + ".size() failled to return 1 after removeAll", 1, _oQ.size( ) );

			assertFalse( _oQ + ".removeAll() failled  to return false if no elements to remove", _oQ.removeAll( Queue2 ) );

			assertFalse( _oQ + ".removeAll() failled  to return false with empty Queue", _oQ.removeAll( new Queue ) );
			_oQ.addAll( Queue2 );
			_oQ.addAll( Queue2 );
			assertTrue( _oQ + ".removeAll() failled  to return true [2]", _oQ.removeAll( Queue2 ) );
			assertEquals( _oQ + ".size() failled to return 1 after removeAll", 1, _oQ.size( ) );
		}
		
		public function testpeek () : void
		{
			_oQ.add( 1 );
			_oQ.add( 2 );
			_oQ.add( 3 );
			_oQ.add( 4 );
			
			assertEquals( _oQ + ".peek() failled to return 1", 1, _oQ.peek( ) );
			assertEquals( _oQ + ".size() failled to return 4 after peek", 4, _oQ.size( ) );
			assertEquals( _oQ + ".peek() failled to return 1 after peek", 1, _oQ.peek( ) );
		}

		public function testpoll () : void
		{
			_oQ.add( 1 );
			_oQ.add( 2 );
			_oQ.add( 3 );
			_oQ.add( 4 );
			
			assertEquals( _oQ + ".pop() failled to return 1", 1, _oQ.poll( ) );
			assertEquals( _oQ + ".size() failled to return 3 after poll", 3, _oQ.size( ) );
			assertEquals( _oQ + ".pop() failled to return 2 after  poll", 2, _oQ.poll( ) );
		}
	}
}