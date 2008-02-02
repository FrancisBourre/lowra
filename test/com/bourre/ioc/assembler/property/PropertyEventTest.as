package com.bourre.ioc.assembler.property
{
	import flexunit.framework.TestCase;

	public class PropertyEventTest extends TestCase
	{
		
		private var _oPE:PropertyEvent ;
		private var _oProp:Property ;
		private var _sOwner:String ;
		private var _sRef:String ;
		
		public override function setUp ():void
		{
			_sOwner = "lala" ;
			_sRef = "pouet" ;
			_oProp = new Property(_sOwner, "name", "value", "string", _sRef, "method") ;
			_oPE = new PropertyEvent( PropertyEvent.onBuildPropertyEVENT, null, _oProp );
		}
		
		public function testConstruct() :void
		{
			assertNotNull("PropertyEvent constructor returns null", _oPE) ;
		}
		
		public function testGetter() : void
		{
			assertEquals("PropertyEvent.getProperty doesn't return expected value", 
						_oProp, _oPE.getProperty()) ;
			assertEquals("PropertyEvent.getOwnerID doesn't return expected value", 
						_sOwner, _oPE.getPropertyOwnerID()) ;						
			assertEquals("PropertyEvent.getRefID doesn't return expected value", 
						_sRef, _oPE.getPropertyRef()) ;
		}
	}
}