package com.bourre.events
{
	import flexunit.framework.TestCase;
	import com.bourre.events.BooleanEvent;

	public class BooleanEventTest extends TestCase
	{
		private var _oObj:Object ;
		private var _oBE:BooleanEvent ;
		
		public override function setUp():void
		{
			_oObj = new Object() ;
			_oBE = new BooleanEvent("blabla", _oObj, true) ;			
		}
		
		public function testConstruct():void
		{
			assertNotNull("BooleanEvent constructor returns null", _oBE) ;
		}
		
		public function testGetBoolean():void
		{
			assertEquals(	"BooleanEvent getter doesn't return the same value given to constructor", 
							_oBE.getBoolean(), true) ;
		}
		
	}
}