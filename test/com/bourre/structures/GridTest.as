package com.bourre.structures
{
	import com.bourre.log.PixlibDebug;	
	
	import flash.geom.Point;
	
	import com.bourre.collection.Iterator;
	
	import flexunit.framework.TestCase;	

	public class GridTest extends TestCase
	{
		private var _g : Grid;
		
		public override function setUp () : void
		{
			_g = new Grid ( new Dimension( 3, 3 ) ); 
		}
   		
   		/*------------------------------------------------------------------*
   		*  Test functions
   		*-------------------------------------------------------------------*/
   		
   		public function testConstruct () : void
   		{
   			assertNotNull ( "Grid constructor returns null - test1 failed", _g );
   		}
   		
   		public function testSize() : void
   		{
   			assertEquals ( "g1.size() == 9 - test1 failed", 9, _g.size() );
   		}
   		
   		public function testGetSize() : void
   		{
   			var size1:Dimension = _g.getSize();
   			assertEquals ( "size1.width == 3", 3, size1.width );
   			assertEquals ( "size1.height == 3", 3, size1.height );
   			
			var g2:Grid = new Grid( new Dimension( 0, 0 ) );
   			var size2:Dimension = g2.getSize();
   			assertEquals ( "size2.width == 0", 0, size2.width );
   			assertEquals ( "size2.height == 0", 0, size2.height );
   		}
   		
   		public function testInvalidInsertion () : void
   		{
   			var p : Point = new Point ( 3, 1 );
   			var b : Boolean = false;
   			
   			try
   			{
   				_g.setVal( p, 20 );
   			}
   			catch( e : Error )
   			{
   				b = true;
   			}
   			assertTrue ( _g + ".setVal() don't failed with incorrect coords - test1 failed", b );
   			
   			b = false;
   			try
   			{
   				_g.getVal( p );
   			}
   			catch( e : Error )
   			{
   				b = true;
   			}
   			assertTrue ( _g + ".getVal() don't fail with incorrect coords  - test2 failed", b );
   			
   			assertFalse ( _g + ".remove() don't return false when removing an invalid entry - test3 failed", _g.remove( 20 ) );
   		}
   		
   		public function testSingleInsertion () : void
   		{
   			var p : Point = new Point ( 1, 2 );
   			
   			assertTrue ( _g + ".setVal() failed with good coords - test1 failed", _g.setVal( p, 15 ) );
   			assertTrue ( _g + ".contains() failed to find the last inserted element - test2 failed", _g.contains( 15 ) );
   			assertNotNull ( _g + ".getVal() failed with good coords - test3 failed", _g.getVal ( p ) );
   			assertEquals ( _g + ".getVal() don't return a correct value - test4 failed", _g.getVal( p ), 15 );
   			assertTrue ( _g + ".remove() failed with last insertion - test5 failed", _g.remove( 15 ) );
   			assertFalse ( _g + ".remove() failed to return false on the second call - test6 failed", _g.remove( 15 ) );
   			assertNull ( _g + ".getVal() don't return a null value after a remove() call - test7 failed", _g.getVal ( p ) );
   			assertFalse ( _g + ".contains() return true when searching a removed element - test2 failed", _g.contains( 15 ) );
   		}
   		public function testDuplicateInsertion () : void
   		{
   			var p1 : Point = new Point ( 0, 1 );
   			var p2 : Point = new Point ( 1, 1 );
   			
   			assertTrue ( _g + ".setVal() don't insert the value  - test1 failed", _g.setVal( p1, 15 ) ); 
   			assertTrue ( _g + ".setVal() don't insert the value a second time - test2 failed", _g.setVal( p2, 15 ) ); 
   			assertTrue ( _g + ".contains() failed to find the last inserted element - test3 failed", _g.contains( 15 ) );
   			assertTrue ( _g + ".remove() failed with last insertion - test4 failed", _g.remove( 15 ) );
   			assertTrue ( _g + ".contains() doesn't find the value - test5 failed", _g.contains( 15 ) );	
   			assertTrue ( _g + ".remove() failed with last insertion - test6 failed", _g.remove( 15 ) );
   			assertFalse ( _g + ".contains() allready find the value - test7 failed", _g.contains( 15 ) );	
   			assertFalse ( _g + ".remove() don't return false when removing a non-existing value - test8 failed", _g.remove( 15 ) );
   		}
   		public function testToArray() : void
   		{
   			_g.setVal( new Point ( 1, 0 ), 45 );
   			_g.setVal( new Point ( 2, 1 ), "45" );
   			
   			var a : Array = _g.toArray();
   			
   			assertNotNull ( _g + ".toArray() return null - test1 failed", a );
   			assertEquals ( _g + ".toArray() result have not a correct size - test2 failed", a.length, 9 );
   			assertEquals ( "element is not at the right place in the array - test3 failed", a[ 1 ], 45 );
   			assertEquals ( "element is not at the right place in the array - test4 failed", a[ 5 ], "45" ); 
   			assertNull ( "undefined elements of the grid are incorrectly filled - test5 failed", a[0] );  		
   			assertTrue ( _g + ".toArray() contain values that are not in the grid - test6 failed", _g.contains ( a[1] ) );
   			assertTrue ( _g + ".toArray() contain values that are not in the grid - test7 failed", _g.contains ( a[5] ) );	
   		}
   		public function testIterator() : void
   		{
			_g.setVal( new Point( 0, 0 ), 25 );
			_g.setVal( new Point( 2, 2 ), "25" );
			var i : Iterator = _g.iterator();
			assertNotNull( _g  + ".iterator() returns null - test1 failed", i );
			var n : uint = 0;
			var a : Array = [ 25  ,	null, null, 
							  null, null, null, 
							  null, null, "25" ];
			while( i.hasNext() ) 
			{
				var o : Object = i.next();
				
				PixlibDebug.DEBUG("i.next return : " + o);
				
				assertEquals ( _g + ".iterator() don't return expected value - test2("+n+") failed", o, a[n] );
				n++;
			}
			assertEquals( _g + ".iterator() iterations count doesn't equals " + _g + ".size() - test3 failed", _g.size(), n );
			i.remove();
			assertEquals( _g + ".iterator().remove() failed - test4 failed", _g.getVal( new Point( 2, 2 ) ), null );
   		}
   		
   		public function testRemoveAll () : void
   		{
   			_g.setVal( new Point ( 0, 0 ), 15 );
   			_g.setVal( new Point ( 2, 1 ), 15 );
   			_g.setVal( new Point ( 0, 2 ), 15 );
   			
   			_g.setVal( new Point ( 2, 0 ), "15" );
   			_g.setVal( new Point ( 0, 1 ), "15" );
   			_g.setVal( new Point ( 2, 2 ), "15" );
   			
   			_g.setVal( new Point ( 1, 0 ), this );
   			_g.setVal( new Point ( 1, 1 ), this );
   			_g.setVal( new Point ( 1, 2 ), null );
   			
   			var g : Grid = new Grid( new Dimension( 2, 1 ) );
   			g.setVal( new Point ( 0, 0 ), 15 );
   			g.setVal( new Point ( 1, 0 ), "15" );
   			
   			assertTrue ( _g + ".removeAll() return false when deleting objects from another grid - test1 failed", _g.removeAll( g ) );
   			assertFalse ( _g + ".contains() allready find an instance of deleted values - test2 failed", _g.contains( 15 ) );
   			assertFalse ( _g + ".contains() allready find an instance of deleted values - test3 failed", _g.contains( 25 ) );
   			assertTrue ( _g + ".contains() don't find a value that haven't been removed - test4 failed", _g.contains( this ) );
   			assertFalse ( _g + ".removeAll() return true on a second call - test5 failed", _g.removeAll( g ) );
   		}
   		
   		public function testRetainAll () : void
   		{
   			_g.setVal( new Point ( 0, 0 ), 15 );
   			_g.setVal( new Point ( 2, 1 ), 15 );
   			_g.setVal( new Point ( 0, 2 ), 15 );
   			
   			_g.setVal( new Point ( 2, 0 ), "15" );
   			_g.setVal( new Point ( 0, 1 ), "15" );
   			_g.setVal( new Point ( 2, 2 ), "15" );
   			
   			_g.setVal( new Point ( 1, 0 ), this );
   			_g.setVal( new Point ( 1, 1 ), this );
   			_g.setVal( new Point ( 1, 2 ), null );
   			
   			var g : Grid = new Grid( new Dimension( 2, 1 ) );
   			g.setVal( new Point ( 0, 0 ), 15 );
   			g.setVal( new Point ( 1, 0 ), "15" );
   			
   			assertTrue ( _g + ".retainAll() return false when retaining objects from another grid - test1 failed", _g.retainAll( g ) );
   			assertTrue ( _g + ".contains() don't find an instance normally retained - test2 failed", _g.contains( 15 ) );
   			assertTrue ( _g + ".contains() don't find an instance normally retained - test3 failed", _g.contains( "15" ) );
   			assertFalse ( _g + ".contains() find a value that have been removed - test4 failed", _g.contains( this ) );
   			assertFalse ( _g + ".retainAll() return true on a second call - test5 failed", _g.retainAll( g ) );
   		}
   		
   		public function testContainsAll () : void
   		{
   			var g : Grid = new Grid ( new Dimension( 3,1 ) );
   			g.setVal( new Point ( 0, 0 ), 15 );
   			g.setVal( new Point ( 1, 0 ), "15" );
   			
   			assertFalse ( _g + ".containsAll() find an element that is not present in the grid - test1 failed", _g.containsAll( g ) );
   			
   			_g.setVal( new Point ( 0, 0 ), 15 );   			
   			_g.setVal( new Point ( 1, 0 ), "15" );		
   			_g.setVal( new Point ( 2, 0 ), this );
   			
   			assertTrue ( _g + ".containsAll() don't find all the values - test2 failed", _g.containsAll( g ) ); 
   			
   			g.setVal( new Point ( 2, 0 ), this );
   			
   			assertTrue ( _g + ".containsAll() failed after adding '"+this+"' - test3 failed", _g.containsAll( g ) ); 	   			
   		}
   		
   		public function testSetContent () : void
   		{
   			var a1 : Array = [ 15, 15, 15, "15", "15", "15", this, this, this ];
   			var a2 : Array = [ 25, "25" ];
   			
   			assertTrue ( _g + ".setContent() failed to add an array of the right size - test1 failed", _g.setContent( a1 ) );
   			
   			assertTrue ( _g + ".contains() failed to find an object added with setContent() - test2 failed", _g.contains( 15 ) );
   			assertTrue ( _g + ".contains() failed to find an object added with setContent() - test3 failed", _g.contains( "15" ) );
   			
   			assertFalse ( _g + ".setContent() don't failed with an array of the wrong size - test4 failed", _g.setContent( a2 ) );
   			assertFalse ( _g + ".contains() don't failed to find a non inserted value.", _g.contains( 25 ) );
   			assertTrue ( _g + ".contains().", _g.contains( 15 ) );
   			
   		}
   		
   		public function testConstructWithArgument () : void
   		{
   			var a1 : Array = [ 15, 15, 15, "15", "15", "15", this, this, this ];
   			var a2 : Array = [ 25, "25" ];
   			
   			var g1 : Grid = new Grid ( new Dimension( 3, 3 ), a1 );
   			var g2 : Grid = new Grid ( new Dimension( 3, 3 ), a2 );
   			   			
   			assertTrue ( g1 + ".contains() failed to find an object added in constructor - test1 failed", g1.contains( 15 ) );
   			assertTrue ( g1 + ".contains() failed to find an object added in constructor - test2 failed", g1.contains( "15" ) );
   			
   			assertFalse ( g2 + ".contains() don't failed to find a non inserted value - test3 failed", g2.contains( 25 ) );
   			assertFalse ( g2 + ".contains() don't failed to find a non inserted value - test4 failed", g2.contains("25" ) );
   		}
   		
   		public function testClear () : void
   		{
   			var a : Array = [ 15, 15, 15, "15", "15", "15", this, this, this ];
   			
   			assertTrue ( _g + ".setContent() failed to change the grid - test1 failed", _g.setContent( a ) );
   			assertTrue ( _g + ".contains failed to find an object added in constructor - test2 failed", _g.contains( 15 ) );
   			
   			_g.clear()
   			
   			assertFalse ( _g + ".contains() allready find a value after a clear() call - test3 failed", _g.contains( 15 ) );
   			assertFalse ( _g + ".contains() allready find a value after a clear() call - test4 failed", _g.contains( "15" ) );
   			assertFalse ( _g + ".contains() allready find a value after a clear() call - test5 failed", _g.contains( this ) );
   		}
   		
   		public function testIsEmpty() : void
   		{
   			assertTrue ( _g + ".isEmpty() return false after creation  - test1 failed", _g.isEmpty() );
   			
   			_g.setVal( new Point ( 1, 0 ), "15" );
   			
   			assertFalse ( _g + ".isEmpty() return true after inserting a value  - test2 failed", _g.isEmpty() );
   			
   			_g.clear();
   			
   			assertTrue ( _g + ".isEmpty() return false after a clear() call  - test2 failed", _g.isEmpty() );
   		}
   		
   		public function testDefaultValue () : void
   		{
   			var g : Grid = new Grid ( new Dimension( 3, 3 ), [ null, null, null, null, 15, "15", this, this, this ], 0 );
   			
   			assertEquals ( g + ".fill() haven't does it's job - test1 failed", g.getVal( new Point ( 0, 0 ) ), 0 );
   			assertEquals ( g + ".fill() haven't does it's job - test2 failed", g.getVal( new Point ( 1, 1 ) ), 15 );
   			assertEquals ( g + ".fill() haven't does it's job - test3 failed", g.getVal( new Point ( 2, 1 ) ), "15" );
   			
   			g.remove( 15 );
   			g.removeAt( new Point( 2, 1 ) );
   			
   			assertEquals ( g + ".remove() don't replace the value by the default one - test4 failed", g.getVal( new Point ( 1, 1 ) ), 0 );
   			assertEquals ( g + ".removeAt() don't replace the value by the default one - test5 failed", g.getVal( new Point ( 2, 1 ) ), 0 );
   			
   			g.fill( 1 );
   			
   			assertEquals ( g + ".fill() haven't does it's job - test6 failed", g.getVal( new Point ( 0, 0 ) ), 1 );
   			assertEquals ( g + ".fill() haven't does it's job - test7 failed", g.getVal( new Point ( 1, 1 ) ), 1 );
   			
   			var i : Iterator = g.iterator();
   			
   			while ( i.hasNext() )
   			{
   				i.next();
   				i.remove();
   			}
   			
   			assertEquals ( g + ".iterator().remove() don't replace element by the default value  - test6 failed", g.getVal( new Point ( 2, 0 ) ), 0 );
   			assertTrue ( g + ".isEmpty() return false after removing all values  - test7 failed", g.isEmpty() );
   		}
	}
}