package com.bourre.ioc.assembler
{
	import flexunit.framework.TestCase;

	public class DepthManagerTest extends TestCase
	{
		private var _oDM:DepthManager ;
		
		public override function setUp():void
		{
			_oDM = DepthManager.getInstance() ;
			_oDM.clear() ;
		}
		
		public function testConstruct():void
		{
			assertNotNull("DepthManager constructor returns null", DepthManager.getInstance()) ;
		}
		
		public function testIsReservedDepth ():void
		{
			assertFalse("DepthManager.isReservedDepth find wrong depth", _oDM.isReservedDepth("lalala",1)) ;
			_oDM.reserveDepth("lala","pouet",2) ;
			assertTrue("DepthManager.isReservedDepth doesn't find reserved depth", _oDM.isReservedDepth("pouet",2)) ;
		}
		
		public function testReserveDepth() :void
		{
			var result:Object ;
			result = _oDM.reserveDepth("lalala", "pouet", 1) ;
			assertEquals("DepthManager.reserveDepth doesn't return expected depth - test1", 1, result) ;
			
			assertEquals("DepthManager.reserveDepth doesn't return expected depth - test2", 4, _oDM.reserveDepth("lala","pouet",4)) ;
		}
		
		public function testGetNextHighestDepth () :void
		{
			assertEquals("DepthManager.getNextHighestDepth doesn't return expected depth", 0, _oDM.getNextHighestDepth("lalala")) ;
			_oDM.reserveDepth("lalala", "pouet", 1) ;
			assertEquals("DepthManager.getNextHighestDepth doesn't return expected depth", 1, _oDM.getNextHighestDepth("lalala")) ;
		}
		
		public function testSubscribeDepth() :void
		{
			assertFalse("DepthManager.subscribeDepth doesn't reserved depth", _oDM.isReservedDepth("pouet",1)) ;
			_oDM.suscribeDepth("lala","pouet",1) ;
			assertTrue("DepthManager.subscribeDepth doesn't reserved depth", _oDM.isReservedDepth("pouet",1)) ;
		}
	}
}