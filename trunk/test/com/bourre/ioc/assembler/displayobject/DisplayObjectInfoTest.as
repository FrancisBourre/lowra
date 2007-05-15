package com.bourre.ioc.assembler.displayobject
{
	import flexunit.framework.TestCase;

	public class DisplayObjectInfoTest extends TestCase
	{
		
		public override function setUp():void
		{
			
		}
		
		public function testConstruct():void
		{
			var oDEI:DisplayObjectInfo = new DisplayObjectInfo("id", "parentid", 1, true) ;
			
			assertNotNull("DisplayObjectInfo constructor returns null", oDEI) ;
			
			assertFalse("DisplayObjectInfo hasChild returns true when no child", oDEI.hasChild()) ;
			
			assertTrue ("DisplayObjectInfo isEmptyDisplayObject returns false when displayobject is empty",
						oDEI.isEmptyDisplayObject()) ;
			
			assertNull("DisplayObjectInfo getChild() doesn't return empty array when no child", 
						oDEI.getChild()[0]) ;
						
			var oChild:DisplayObjectInfo = new DisplayObjectInfo("idChild", "parentChild", 1, false) ;
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
			var oDEI:DisplayObjectInfo = new DisplayObjectInfo("id", "parentid", 1, true, "/swf/ici.swf") ;
			
			assertFalse("DisplayObjectInfo isEmptyDisplayObject returns true when displayobject no empty",
						oDEI.isEmptyDisplayObject()) ;
						
			assertEquals("DisplayObjectInfo default type isn't movieclip", "Movieclip", oDEI.type) ;
			
			var oDEI2:DisplayObjectInfo = new DisplayObjectInfo("id2", "parentid", 2, true, "/swf/ici.swf", "Sprite") ;
			assertEquals("DisplayObjectInfos type isn't memorize", "Sprite", oDEI2.type) ;
		}

	}
}