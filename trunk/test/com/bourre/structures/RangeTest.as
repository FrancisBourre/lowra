package com.bourre.structures
{
	import flexunit.framework.TestCase;

	public class RangeTest extends TestCase
	{
		private var _r : Range;
		
		public override function setUp () : void
		{
			_r = new Range ( 10, 150 ); 
		}
		
		public function testConstruct () : void
		{
			assertNotNull ( "Range constructor return null - test1 failed", _r ); 
		}
		
		public function testClone () : void
		{
			var r1 : Range = _r.clone();
			
			assertTrue ( _r + ".clone() don't return a copy of itself - test1 failed", _r.equals( r1 ) );
			assertFalse ( _r + ".clone() return a reference instead of a clone - test2 failed", _r === r1 );
		}
		public function testOverLap () : void
		{
			var r1 : Range = new Range ( 20, 120 );
			var r2 : Range = new Range ( 0, 120 );
			var r3 : Range = new Range ( 0, 160 );
			var r4 : Range = new Range ( 0, 10 );
			
			assertTrue ( _r + ".overlap failed - test1 failed", _r.overlap( r1 ) ); 
			assertTrue ( _r + ".overlap failed - test2 failed", _r.overlap( r2 ) ); 
			assertTrue ( _r +".overlap failed - test3 failed", _r.overlap( r3 ) ); 
			assertFalse ( _r + ".overlap failed - test4 failed", _r.overlap( r4 ) ); 
		}
		
		public function testEquals () : void
		{
			var r : Range = new Range ( 10, 150 );
			
			assertTrue ( _r + ".equals failed - test1 failed", _r.equals( r ) ); 
		}
		
		public function testSurround () : void
		{
			var n1 : Number = 0;
			var n2 : Number = 50;
			var n3 : Number = 180;
			
			assertFalse ( _r + ".surround failed - test1 failed", _r.surround( n1 ) ); 
			assertTrue (  _r + ".surround failed - test2 failed", _r.surround( n2 ) ); 
			assertFalse ( _r + ".surround failed - test3 failed", _r.surround( n3 ) ); 
		} 
		
		public function testInside () : void
		{
			var r1 : Range = new Range ( 20, 120 );
			var r2 : Range = new Range ( 0, 165 );
			
			assertFalse ( _r + ".inside failed - test1 failed", _r.inside( r1 ) ); 
			assertTrue ( _r + ".inside failed - test2 failed", _r.inside( r2 ) ); 
		}
	}
}