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
		
		public function testRelease() : void
		{
			IDExpert.release();
			var ie : IDExpert = IDExpert.getInstance();
			assertFalse( "IDExpert.release() fails", _oIE == ie );
		}

		public function testRegister() : void
		{
			assertTrue( "", _oIE.register( "id" ) );

			var err : Error;

			try
			{
				_oIE.register( "id" );

			} catch ( e : Error )
			{
				err = e;
			}

			assertNotNull( "", err );
		}
	}
}