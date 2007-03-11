package com.bourre.structures
{
	import flexunit.framework.TestCase;

	public class RectangleTest extends TestCase
	{
		private var _r : Rectangle;
				
		public override function setUp () : void
		{
			_r = new Rectangle( 10, 10, 20, 15);
		}	
		
		public function testConstruct () : void
		{
			assertNotNull ( "Rectangle constructor return null - test1failed", _r );
		}	
		
		public function testClone () : void
		{
			var r1 : Rectangle = _r.clone();
			
			assertTrue ( _r + ".clone() don't return a copy of itself - test1 failed", _r.equals( r1 ) );
			assertFalse ( _r + ".clone() return a reference instead of a clone - test2 failed", _r === r1 );
		}
		public function testGetBorders () : void
		{
			var t : Number = _r.getTop();
			var b : Number = _r.getBottom();
			var l : Number = _r.getLeft();
			var r : Number = _r.getRight();

			assertEquals ( "Top border isn't valid - test1 failed", t, 15 );
			assertEquals ( "Bottom border isn't valid - test2 failed", b, 25 );
			assertEquals ( "Left border isn't valid - test3 failed", l, 20 );
			assertEquals ( "Right border isn't valid - test4 failed", r, 30 );
		}
		public function testGetCorners () : void
		{
			var tl : Point = _r.getTopLeft();
			var tr : Point = _r.getTopRight();
			var bl : Point = _r.getBottomLeft();
			var br : Point = _r.getBottomRight();
			
			var ttl : Point = new Point ( 20, 15 );
			var ttr : Point = new Point ( 30, 15 );
			var tbl : Point = new Point ( 20, 25 );
			var tbr : Point = new Point ( 30, 25 );
			
			assertNotNull ( "Rectangle can't retreive Top Left corner - test1 failed", tl );
			assertNotNull ( "Rectangle can't retreive Top Right corner - test2 failed", tr );
			assertNotNull ( "Rectangle can't retreive Bottom Left corner - test3 failed", bl );
			assertNotNull ( "Rectangle can't retreive Bottom right corner - test4 failed", br );
			
			assertTrue ( "Top Left corner isn't valid - test5 failed", tl.equals( ttl ) ) ;
			assertTrue ( "Top Right corner isn't valid - test6 failed", tr.equals( ttr ) ) ;
			assertTrue ( "Bottom Left corner isn't valid - test7 failed", bl.equals( tbl ) ) ;
			assertTrue ( "Bottom Right corner isn't valid - test8 failed", br.equals( tbr ) ) ;			
		}
		
		public function testSetCorners () : void
		{			
			var ttl : Point = new Point ( 30, 40 );
			var ttr : Point = new Point ( 60, 40 );
			var tbl : Point = new Point ( 30, 60 );
			var tbr : Point = new Point ( 60, 60 );
			var nC : Point  = new Point ( 45, 50 );
			var nW : Number = 30;
			var nH : Number = 20;
			
			_r.setTopLeft( ttl );
			_r.setTopRight( ttr );
			_r.setBottomLeft( tbl );
			_r.setBottomRight( tbr );
			
			var tl : Point = _r.getTopLeft();
			var tr : Point = _r.getTopRight();
			var bl : Point = _r.getBottomLeft();
			var br : Point = _r.getBottomRight();
			var c : Point = _r.getCenter();
			var w : Number = _r.width;
			var h : Number = _r.height;
			
			assertEquals ( "width isn't valid - test1 failed", nW, w );
			assertEquals ( "height isn't valid - test2 failed", nH, h );
			assertTrue ( "setCenter failed - test3 failed", c.equals( nC ) );
			assertTrue ( "setTopLeft failed - test4 failed", tl.equals( ttl ) );
			assertTrue ( "setTopRight failed - test5 failed", tr.equals( ttr ) );
			assertTrue ( "setBottomLeft failed - test6 failed", bl.equals( tbl ) );
			assertTrue ( "setBottomRight failed - test7 failed", br.equals( tbr ) );
		}
		
		public function testSetBorders () : void
		{
			var nT : Number = 0;
			var nB : Number = 100;
			var nL : Number = -20;
			var nR : Number = 30;
			var nW : Number = 50;
			var nH : Number = 100;
			
			_r.setTop ( nT );
			_r.setBottom ( nB );
			_r.setLeft ( nL );
			_r.setRight ( nR );
			
			var tl : Point = _r.getTopLeft();
			var tr : Point = _r.getTopRight();
			var bl : Point = _r.getBottomLeft();
			var br : Point = _r.getBottomRight();
			var c : Point = _r.getCenter();
			var w : Number = _r.width;
			var h : Number = _r.height;
			
			assertEquals ( "width isn't valid - test1 failed", nW, w );
			assertEquals ( "height isn't valid - test2 failed", nH, h );
			assertTrue ( "Center failed - test3 failed", c.compare( 5, 50 ) );
			assertTrue ( "TopLeft failed - test4 failed", tl.compare( nL, nT ) );
			assertTrue ( "TopRight failed - test5 failed", tr.compare( nR, nT ) );
			assertTrue ( "BottomLeft failed - test6 failed", bl.compare( nL, nB ) );
			assertTrue ( "BottomRight failed - test7 failed", br.compare( nR, nB ) );
		}
		
		public function testGetCenter () : void
		{
			var p : Point = new Point ( 25, 20 );
			
			var center : Point = _r.getCenter();
			
			assertNotNull ( _r + ".getCenter() return null - test1 failed", center );
			assertTrue ( _r+".getCenter() don't return the correct center - test2 failed", p.equals( center ) );
		}
		
		public function testGetArea () : void
		{
			var a : Number = 100;
			
			assertEquals ( "Area of the rectangle isn't the good one - test1 failed", a, _r.getArea() );
			
			_r.width = -50;
			_r.height = -100;
			a = 5000;
			
			assertEquals ( "Area of the rectangle isn't positive - test2 failed", a, _r.getArea() );
		}
		
		public function testGetSize () : void
		{
			var p : Point = new Point ( 10, 10 );
			
			assertTrue ( "Size of the rectangle isn't the good one - test2 failed", _r.getSize().equals( p ) );		
			
		}
		
	}
}