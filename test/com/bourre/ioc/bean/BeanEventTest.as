package com.bourre.ioc.bean
{
	import flexunit.framework.TestCase;

	public class BeanEventTest extends TestCase
	{
		private var _oBE:BeanEvent ;
		private var obj:Object ;
		
		public override function setUp():void
		{
			obj = new Object() ;
			_oBE = new BeanEvent("lalala", "on", obj) ;
		}
		
		public function testConstruct():void
		{
			assertNotNull("BeanEvent constructor returns null", _oBE) ;
		}
		
		public function testGetters():void
		{
			assertEquals(	"BeanEvent.getID doesn't return expected value", 
							"on", _oBE.getID()) ;
							
			assertEquals(	"BeanEvent.getBean doesn't return expected value", 
							obj, _oBE.getBean()) ;
		}
		
	}
}