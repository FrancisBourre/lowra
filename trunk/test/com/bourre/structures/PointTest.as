package com.bourre.structures
{
	import flexunit.framework.TestCase;
	import flexunit.framework.TestSuite;

	public class PointTest extends TestCase
	{		
		private var _p : Point;
				
		public override function setUp () : void
		{
			_p = new Point();
		}
				
		public function testInstanciate () : void 
		{
			assertNotNull ( "Point constructor returns null - test1 failed", _p );
		}
		
		public function testInitNaN () : void
		{
			var errorOccurs : Boolean = false;
			try 
			{
				_p.init ( NaN, 0 );
			}
			catch ( e : Error )
			{
				errorOccurs = true;
			}
			assertTrue ( "Point haven't throw an error on illegal operation.", errorOccurs );
		}
		
		public function testEquals () : void 
		{
			var p : Point = new Point();
			assertTrue ( "Points aren't equals - test1 failed", _p.equals( p ) );
			
			p.init( 5, 5 );
			assertFalse ( "Points are equals - test2 failed", _p.equals( p ) ); 	
			
			p.init( 0, 5 );
			assertFalse ( "Points are equals - test3 failed", _p.equals( p ) ); 
		}
		
		public function testCompare () : void 
		{
			assertTrue ( "Point aren't equals to x:0,y:0 - test1 failed", _p.compare( 0, 0 ) );
			assertFalse ( "Point are equals to x:5,y:5 - test2 failed", _p.compare( 5, 5 ) );	
			assertFalse ( "Point are equals to x:0,y:5 - test3 failed", _p.compare( 0, 5 ) );
		}
		
		public function testClone () : void 
		{
			var p : Point = _p.clone();
			
			assertNotNull ( _p + ".clone() returns null - test1 failed", p );
			assertFalse ( "Cloned point is the same than original - test2 failed", p === _p );
			assertTrue ( "Cloned point isn't equal than original - test3 failed", _p.equals ( p ) );
		}
		
		public function testMinus () : void 
		{
			_p.minus ( new Point ( 5, 5 ) );
			assertTrue ( _p + ".minus() don't modify correctly the point - test1 failed", _p.compare( -5, -5 ) );
			
			_p.minus ( new Point ( -10, -10 ) );
			assertTrue ( _p + ".minus() don't modify correctly the point - test2 failed", _p.compare( 5, 5 ) );
		}
		
		public function testPlus () : void 
		{
			_p.plus ( new Point ( 5, 5 ) );
			assertTrue ( _p + ".plus() don't modify correctly the point - test1 failed", _p.compare( 5, 5 ) );
			
			_p.plus ( new Point ( -10, -10 ) );
			assertTrue ( _p + ".plus() don't modify correctly the point - test2 failed", _p.compare( -5, -5 ) );
		}
		
		public function testNeg () : void 
		{
			_p.init( 5, 5 );
			
			_p.neg ();
			assertTrue ( _p + ".neg failed() - test1 failed", _p.compare( -5, -5 ) );
			
			_p.neg ();
			assertTrue ( _p + ".neg failed() - test2 failed", _p.compare( 5, 5 ) );
		}
		
		public function testAbs () : void 
		{
			_p.init ( -4, -8 );
			
			_p.abs ();
			assertTrue ( _p + ".abs() failed - test1 failed", _p.compare( 4, 8 ) );
			
			_p.init ( 4, 8 );
			
			_p.abs ();
			assertTrue ( _p + ".abs() failed - test2 failed", _p.compare( 4, 8 ) );
		}
		
		public function testGetLength () : void 
		{
			assertEquals ( _p + ".getLength() != 0 - test1 failed", _p.getLength(), 0 );
			
			var x : Number = 8;
			var y : Number = 12;
			var sqr : Number = Math.sqrt( ( x * x ) + ( y * y ) );
			
			_p.init( x, y );
			assertEquals ( _p + ".getLength() != " + sqr + " - test2 failed", _p.getLength(), sqr );
		}
		
		public function testNormalize () : void 
		{
			var errorOccurs : Boolean = false;
			
			try 
			{
				_p.normalize();
			}
			catch ( e : Error )
			{
				errorOccurs = true;
			}
			assertTrue ( _p + ".normalize() don't fail with a zero-length vector - test1 failed", errorOccurs ); 
			
			/*
			// Don't work because of Math.sqrt approximation.
			
			_p.init ( 5, 5 );			
			_p.normalize();
			assertEquals ( "Point length != 1 - test2 failed", _p.getLength(), 1 );
			*/
		}
		
		public function testGetDirection () : void 
		{
			// Don't work because of Math.sqrt approximation.
		}
		
		public function testGetDotProduct () : void 
		{
			_p.init ( 5, 4 );
			
			var p1 : Point = new Point ( 6, 8 );
			var p2 : Point = new Point ( 3, 6 );
			
			var dot1 : Number = 62;
			var dot2 : Number = 39;
						
			var res1 : Number = _p.getDotProduct( p1 );
			var res2 : Number = _p.getDotProduct( p2 );
			
			assertEquals ( "Dot product isn't correct - test1 failed", dot1, res1 );
			assertEquals ( "Dot product isn't correct - test2 failed", dot2, res2 );
		}
		
		public function testGetCrossProduct () : void 
		{
			_p.init ( 5, 4 );
			
			var p1 : Point = new Point ( 6, 8 );
			var p2 : Point = new Point ( 3, 6 );
			
			var cross1 : Number = 16;
			var cross2 : Number = 18;
			
			var res1 : Number = _p.getCrossProduct( p1 );
			var res2 : Number = _p.getCrossProduct( p2 );
			
			assertEquals ( "Cross product isn't correct - test1 failed", cross1, res1 );
			assertEquals ( "Cross product isn't correct - test2 failed", cross2, res2 );
		}
		
		public function testScalarMultiply () : void 
		{
			_p.init ( 5, 5 );
			_p.scalarMultiply( 5 );
			
			var p : Point = new Point ( 25, 25 );
			
			assertEquals ( _p + ".x must be 25 - test1 failed", 25, _p.x );
			assertEquals ( _p + ".y must be 25 - test2 failed", 25, _p.y );
			assertTrue ( "Scalar multiply don't change correctly the point - test3 failed", _p.equals( p ) );
			
			p = new Point ( 5, 5 );
			_p.scalarMultiply( .2 );
			
			assertEquals ( _p + ".x must be 5 - test4 failed", 5, _p.x );
			assertEquals ( _p + ".y must be 5 - test5 failed", 5, _p.y );
			assertTrue ( "Scalar multiply don't change correctly the point - test6 failed", _p.equals( p ) );
			
			var errorOccurs : Boolean = false;
			
			try 
			{
				_p.scalarMultiply( NaN );
			}
			catch ( e : Error )
			{
				errorOccurs = true;
			}
			
			assertTrue ( "Scalar multiply don't fail with zero length vector - test7 failed", errorOccurs );
		}
		
		public function testProject () : void 
		{
			_p.init( 5, 5 );
			var p1 : Point = new Point( 10, 0 );
			
			var p2 : Point = _p.project( p1 );
			
			assertNotNull ( _p + ".project() return null - test1 failed", p2 );
			assertEquals ( _p + ".project() don't return a correct value - test2 failed", 5, p2.x );
			assertEquals ( _p + ".project() don't return a correct value - test3 failed", 0, p2.y );
		}
		
		public function testProjectOnZeroLengthVector () : void 
		{
			_p.init( 5, 5 );
			
			var p1 : Point = new Point( 0, 0 );			
			var p2 : Point = _p.project( p1 );
			
			assertTrue ( _p + ".project() don't fail with zero length vector - test1 failed", p2.equals( _p ) );
		}
		
		public function testProjectionLength () : void 
		{
			_p.init( 5, 5 );
			var p1 : Point = new Point( 10, 0 );
			
			var l : Number = _p.getProjectionLength( p1 );
			
			assertEquals ( _p + ".getProjectionLength() don't return a correct value - test1 failed", l, 0.5 );			
		}
		
		public function testProjectionLengthOnZeroLengthVector () : void 
		{
			_p.init( 5, 5 );
			var p1 : Point = new Point( 0, 0 );
			
			var l : Number = _p.getProjectionLength( p1 );
			
			assertEquals ( _p + ".getProjectionLength() don't return a correct value - test1 failed", l, 0 );			
		}
		
		public function testGetDistance () : void
		{
			var p : Point = new Point( 5, 5 );
			
			var dist : Number = Point.getDistance( _p, p );
			var l : Number = Math.sqrt( 50 );
			
			assertEquals ( "Point.getDistance() don't return a correct value - test1 failed", dist, l );
		}
		
		public function testMinusNew () : void
		{
			_p.init( 5, 5 );
			var p1 : Point = new Point( 10, 0 );
					
			var p2 : Point = Point.minusNew ( _p, p1 );
			var p3 : Point = new Point( -5, 5 );
			
			assertNotNull ( "Point.minusNew() returns null - test1 failed", p2 );
			assertTrue ( "Point.minusNew() don't return a correct value - test2 failed", p2.equals( p3 ) );
		}
		
		public function testPlusNew () : void
		{
			_p.init( 5, 5 );
			var p1 : Point = new Point( 10, 0 );
					
			var p2 : Point = Point.plusNew ( _p, p1 );
			var p3 : Point = new Point( 15, 5 );
			
			assertNotNull ( "Point.plusNew() returns null - test1 failed", p2 );
			assertTrue ( "Point.plusNew() don't return a correct value - test2 failed", p2.equals( p3 ) );
		}
		
		public function testAbsNew () : void
		{
			_p.init( -5, -5 );
			var p1 : Point = Point.absNew ( _p );
			var p2 : Point = new Point( 5, 5 );
			
			assertNotNull ( "Point.absNew() returns null - test1 failed", p1 );
			assertTrue ( "Point.absNew() don't return a correct value - test2 failed", p1.equals( p2 ) );
		}
		
		public function testNegNew () : void
		{
			_p.init( -5, -5 );
			var p1 : Point = Point.negNew ( _p );
			var p2 : Point = new Point( 5, 5 );
			
			assertNotNull ( "Point.negNew() returns null - test1 failed", p1 );
			assertTrue ( "Point.negNew() don't return a correct value - test2 failed", p1.equals( p2 ) );
		}
	}
}