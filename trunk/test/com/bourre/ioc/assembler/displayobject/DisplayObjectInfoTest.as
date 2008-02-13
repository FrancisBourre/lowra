package com.bourre.ioc.assembler.displayobject
{
	import flash.net.URLRequest;			import com.bourre.ioc.parser.ContextTypeList;	
	
	import flexunit.framework.TestCase;

	public class DisplayObjectInfoTest extends TestCase
	{
		
		public override function setUp():void
		{
			
		}
		
		public function testConstruct():void
		{
			var oDEI:DisplayObjectInfo = new DisplayObjectInfo("id", "parentid", true) ;
			
			assertNotNull("DisplayObjectInfo constructor returns null", oDEI) ;
			
			assertFalse("DisplayObjectInfo hasChild returns true when no child", oDEI.hasChild()) ;
			
			assertTrue ("DisplayObjectInfo isEmptyDisplayObject returns false when displayobject is empty",
						oDEI.isEmptyDisplayObject()) ;
			
			assertNull("DisplayObjectInfo getChild() doesn't return empty array when no child", 
						oDEI.getChild()[0]) ;
						
			var oChild:DisplayObjectInfo = new DisplayObjectInfo("idChild", "parentChild", false) ;
			oDEI.addChild(oChild) ;
			
			assertTrue("DisplayObjectInfo hasChild returns false when child", oDEI.hasChild()) ;
			
			assertNotNull("DisplayObjectInfo getChild() returns empty array when has child", 
						oDEI.getChild()[0]) ;
						
			assertTrue("DisplayObjectInfo getChild() doesn't contains DisplayObjectInfo objects", 
						oDEI.getChild()[0] is DisplayObjectInfo) ;
						
			assertEquals("DisplayObjectInfo _aChilds doesn't contain expected child", 
						"idChild", oDEI.getChild()[0].ID) ;
		}
		
		public function testEmptyDisplayObject () : void
		{
			var oDEI:DisplayObjectInfo = new DisplayObjectInfo("id", "parentid", true, new URLRequest("/swf/ici.swf")) ;
			
			assertFalse("DisplayObjectInfo isEmptyDisplayObject returns true when displayobject no empty",
						oDEI.isEmptyDisplayObject()) ;
						
			assertEquals("DisplayObjectInfo default type isn't movieclip", ContextTypeList.MOVIECLIP, oDEI.type) ;
			
			var oDEI2:DisplayObjectInfo = new DisplayObjectInfo("id2", "parentid", true, new URLRequest("/swf/ici.swf"), ContextTypeList.SPRITE ) ;
			assertEquals("DisplayObjectInfos type isn't memorize", ContextTypeList.SPRITE , oDEI2.type) ;
		}

	}
}