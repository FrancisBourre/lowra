package com.bourre.ioc.parser
{
	import flexunit.framework.TestCase;

	public class ContextNodeNameListTest extends TestCase
	{
		
		private var _oCN:ContextNodeNameList ;
		
		public override function setUp():void
		{
			_oCN = ContextNodeNameList.getInstance() ;
		}
		
		public function testConstruct():void
		{
			assertNotNull("ContextNodeNameList constructor returns null", _oCN) ;
			assertTrue	("ContextNodeNameList.init doesn't add default nodeName - test1", 
						_oCN.nodeNameIsReserved(ContextNodeNameList.BEANS)) ;
			assertTrue	("ContextNodeNameList.init doesn't add default nodeName - test3", 
						_oCN.nodeNameIsReserved(ContextNodeNameList.PROPERTY)) ;
			assertTrue	("ContextNodeNameList.init doesn't add default nodeName - test4", 
						_oCN.nodeNameIsReserved(ContextNodeNameList.ARGUMENT)) ;
			assertTrue	("ContextNodeNameList.init doesn't add default nodeName - test5", 
						_oCN.nodeNameIsReserved(ContextNodeNameList.ROOT)) ;
			assertTrue	("ContextNodeNameList.init doesn't add default nodeName - test6", 
						_oCN.nodeNameIsReserved(ContextNodeNameList.APPLICATION_LOADER)) ;
			assertTrue	("ContextNodeNameList.init doesn't add default nodeName - test7", 
						_oCN.nodeNameIsReserved(ContextNodeNameList.METHOD_CALL)) ;
			assertTrue	("ContextNodeNameList.init doesn't add default nodeName - test8", 
						_oCN.nodeNameIsReserved(ContextNodeNameList.LISTEN)) ;
			assertTrue	("ContextNodeNameList.init doesn't add default nodeName - test9", 
						_oCN.nodeNameIsReserved("attribute")) ;
		}
		
		public function testNodeNameIsReserved():void
		{
			assertFalse("ContextNodeNameList.nodeNameIsReserved find an inexisting node", _oCN.nodeNameIsReserved("pouet")) ;
		}
		
		public function testAddNodeName():void
		{
			_oCN.addNodeName("blabla", "123") ;
			assertTrue("ContextNodeNameList.addNodeName doesn't add the node", _oCN.nodeNameIsReserved("blabla")) ;
		}
		
	}
}