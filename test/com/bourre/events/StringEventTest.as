package com.bourre.events
{
	import flexunit.framework.TestCase;
	import com.bourre.events.StringEvent;

	public class StringEventTest extends TestCase
	{
		private var _oSE:StringEvent ;
		private var _oObj:Object ;
		
		public override function setUp() : void
		{
			_oObj = new Object() ;
			_oSE = new StringEvent("blabla", _oObj, "lalala") ;
		}
		
		public function testConstruct():void
		{
			assertNotNull("StringEvent constructor returns null", _oSE) ;
		}
		
		public function testGetString():void
		{
			assertEquals(	"StringEvent getter doesn't return the value given to constructor", 
							_oSE.getString(), "lalala") ;
		}
	}
}