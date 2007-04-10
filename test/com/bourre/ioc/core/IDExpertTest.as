package com.bourre.ioc.core
{
	import flexunit.framework.TestCase;

	public class IDExpertTest 
		extends TestCase
	{
		private var _oIE : IDExpert;

		public override function setUp():void
		{
			IDExpert.release();
			_oIE = IDExpert.getInstance();
		}
		
		public function testGetInstance() : void
		{
			assertNotNull( "IDExpert.getInstance() returns null", _oIE );
		}
	}
}