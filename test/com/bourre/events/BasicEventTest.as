package com.bourre.events
{
	import flexunit.framework.TestCase;

	public class BasicEventTest extends TestCase
	{
		private var _oObj:Object ;
		private var _oObj2:Object ;
		private var _oBE:BasicEvent ;
		
		public override function setUp():void
		{
			_oObj = new Object() ;
			_oObj2 = new Object() ;
			_oBE = new BasicEvent("blabla", _oObj) ;
		}
		
		public function testConstruct():void
		{
			assertNotNull(	"BasicEvent constructor returns null", 
							_oBE) ;
		}
		
		public function testGetSetType():void
		{
			assertEquals(	"BasicEvent.type doesn't return the same value as given to constructor",
							_oBE.type, "blabla") ;
			assertTrue(		"BasicEvent.type doesn't return the String type",
							_oBE.type is String) ;
			
			_oBE.type = "lalala" ;
			assertEquals(	"BasicEvent.type doesn't set the right value", 
							_oBE.type, "lalala") ;
			
			assertEquals(	"BasicEvent.getType doesn't return the right value",
							_oBE.getType(), "lalala") ;
			assertTrue(		"BasicEvent type getter doesn't return the String type",
							_oBE.getType() is String) ;
			
			_oBE.setType("blablabla") ;
			assertEquals(	"BasicEvent.setType doesn't set the right value", 
							_oBE.type, "blablabla") ;
		}
		
		public function testGetSetTarget():void
		{
			assertStrictlyEquals(	"BasicEvent.target doesn't return the same value as given to constructor",
									_oBE.target, _oObj) ;
			assertTrue(	"BasicEvent.target doesn't return the Object type",
							_oBE.target is Object) ;
			
			_oBE.target = _oObj2 ;
			assertStrictlyEquals(	"BasicEvent.target doesn't set the right value", 
									_oBE.target, _oObj2) ;
									
			assertStrictlyEquals(	"BasicEvent.getTarget doesn't return the right value", 
									_oBE.getTarget(), _oObj2) ;
			assertTrue(	"BasicEvent.getTarget doesn't return the Object type",
						_oBE.getTarget() is Object) ;
			
			_oBE.setTarget(_oObj) ;
			assertStrictlyEquals(	"BasicEvent.setTarget doesn't set the right value", 
									_oBE.target, _oObj) ;
		}

	}
}