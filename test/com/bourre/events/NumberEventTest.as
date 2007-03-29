package com.bourre.events
{
	import flexunit.framework.TestCase;
	import com.bourre.events.NumberEvent;

	public class NumberEventTest extends TestCase
	{
		private var _oObj:Object ;
		private var _oNE:NumberEvent ;
		
		public override function setUp() : void
		{
			_oObj = new Object() ;
			_oNE = new NumberEvent("blabla", _oObj, 5) ;
		}
		
		public function testConstruct () : void
		{
			assertNotNull("NumberEvent constructor returns null", _oObj) ;
		}
		public function testGetNumber():void
		{
			assertEquals(	"NumberEvent getter doesn't return the same value given to constructor",
							_oNE.getNumber(), 5) ; 
		}
	}
}