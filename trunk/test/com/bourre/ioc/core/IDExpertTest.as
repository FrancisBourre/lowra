package com.bourre.ioc.core
{
	import flexunit.framework.TestCase;
	import com.bourre.ioc.assembler.property.*;

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
			assertFalse( "", _oIE.register( "id" ) );
		}

		public function testBasicRefSorting() : void
		{
			_oIE.register( "owner" );

			var p0 : Property = new Property( "owner", null, null, null, "refID0", null );
			var p1 : Property = new Property( "refID0", null, null, null, "refID1", null );

			_oIE.onBuildProperty( new PropertyEvent( p0, "owner", "refID0" ) );
			_oIE.onBuildProperty( new PropertyEvent( p1, "refID0", "refID1" ) );

			var a : Array = _oIE.getReferenceList().toArray();

			assertEquals( "", a.length, 3 );
			assertStrictlyEquals( "", a[ 0 ], "refID1" );
			assertStrictlyEquals( "", a[ 1 ], "refID0" );
			assertStrictlyEquals( "", a[ 2 ], "owner" );
		}

		public function testRefSorting() : void
		{
			_oIE.register( "refID2" );
			var p2 : Property = new Property( "refID2", null, null, null, "refID1", null );
			var p3 : Property = new Property( "refID2", null, null, null, "owner", null );
			
			_oIE.onBuildProperty( new PropertyEvent( p2, "refID2", "refID1" ) );
			_oIE.onBuildProperty( new PropertyEvent( p3, "refID2", "owner" ) );
			
			_oIE.register( "refID0" );
			var p0 : Property = new Property( "refID0", null, null, null, "refID1", null );

			_oIE.register( "owner" );
			var p1 : Property = new Property( "owner", null, null, null, "refID0", null );

			_oIE.onBuildProperty( new PropertyEvent( p0, "refID0", "refID1" ) );
			_oIE.onBuildProperty( new PropertyEvent( p1, "owner", "refID0" ) );

			var a : Array = _oIE.getReferenceList().toArray();

			assertEquals( "", a.length, 4 );
			assertStrictlyEquals( "", a[ 0 ], "refID1" );
			assertStrictlyEquals( "", a[ 1 ], "refID0" );
			assertStrictlyEquals( "", a[ 2 ], "owner" );
			assertStrictlyEquals( "", a[ 3 ], "refID2" );
		}
	}
}