package com.bourre.ioc.assembler.method
{
	import flexunit.framework.TestCase;

	public class MethodEventTest extends TestCase
	{
		private var _oM:Method ;
		private var _oME:MethodEvent ;
		
		public override function setUp():void
		{
			_oM = new Method("owner", "method", []) ;
			_oME = new MethodEvent(_oM) ;
		}
		
		public function testConstruct() :void
		{
			assertNotNull("Method constructor returns null", _oM) ;
			assertNotNull("MethodEvent constructor returns null", _oME) ;
		}
		
		public function testMethodGetter() : void
		{
			assertEquals("MethodEvent method getter not equal to original method", _oM, _oME.getMethod()) ;
		}
	}
}