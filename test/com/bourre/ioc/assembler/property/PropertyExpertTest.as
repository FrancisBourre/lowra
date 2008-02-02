package com.bourre.ioc.assembler.property
{
	import flexunit.framework.TestCase;
	import com.bourre.ioc.bean.BeanFactory;

	public class PropertyExpertTest extends TestCase
	{
		private var _oPE : PropertyExpert;
		private var _oBF : BeanFactory ;

		public var prop : Object;

		public override function setUp():void
		{
			prop = null;
			BeanFactory.release();
			PropertyExpert.release();
			
			_oBF = BeanFactory.getInstance();
			_oPE = PropertyExpert.getInstance();
		}

		public function testConstruct() : void
		{
			assertNotNull( "PropertyExpert.getInstance() returns null", _oPE ) ;
		}

		public function testRelease() : void
		{
			PropertyExpert.release();
			assertFalse( "PropertyExpert.release() fails", _oPE == PropertyExpert.getInstance() ) ;
		}

		public function testGetValueMethod() : void
		{
			_oBF.register( "myRef", this );
			
			var f : Function = _oPE.getValue( new Property( "test", null, null, null, null, "myRef.testGetValueMethod" ) ) as Function;
			
			assertStrictlyEquals( "PropertyExpert.getInstance().getValue() value mismatches.", f, this.testGetValueMethod );
			assertTrue( "PropertyExpert.getInstance().getValue() type mismatches.", f is Function );
		}

		public function testGetValueRef() : void
		{
			_oBF.register( "myRef", this );
			
			var o : PropertyExpertTest = _oPE.getValue( new Property( "test", null, null, null, "myRef" ) ) as PropertyExpertTest;
			
			assertStrictlyEquals( "PropertyExpert.getInstance().getValue() value mismatches.", o, this );
			assertTrue( "PropertyExpert.getInstance().getValue() type mismatches.", o is PropertyExpertTest );
		}

		public function testGetValueRefWithEval() : void
		{
			_oBF.register( "myRef", this );
			
			prop = {};
			prop.x = 13;
			
			var n : Number = _oPE.getValue( new Property( "test", null, null, null, "myRef.prop.x" ) ) as Number;
			
			assertEquals( "PropertyExpert.getInstance().getValue() value mismatches.", n, prop.x );
			assertTrue( "PropertyExpert.getInstance().getValue() type mismatches.", n is Number );
		}

		public function testGetValueDefault() : void
		{
			var i : Number = _oPE.getValue( new Property( "test", "x", "12", "Number" ) ) as Number;
			assertEquals( "PropertyExpert.getInstance().getValue() value mismatches.", i, 12 );
			assertTrue( "PropertyExpert.getInstance().getValue() type mismatches.", i is Number );
		}
		
		public function testSetPropertyValue() : void
		{
			prop = {};
			_oPE.setPropertyValue( new Property( "test", "x", "12", "Number" ), prop );

			assertEquals( "PropertyExpert.getInstance().setPropertyValue() value mismatches.", prop.x, 12 );
			assertTrue( "PropertyExpert.getInstance().setPropertyValue() type mismatches.", prop.x is Number );
		}
		
		public function testOnRegisterBeanCallback() : void
		{
			this.prop = {};
			_oPE.addProperty( "test", "x", "27", "Number" );
			_oPE.addProperty( "test", "s", "hello", "String" );

			_oBF.register( "test", this.prop );

			assertEquals( "PropertyExpert.getInstance().getValue() value mismatches.", 27, prop.x );
			assertTrue( "PropertyExpert.getInstance().getValue() type mismatches.", prop.x is Number );
			
			assertEquals( "PropertyExpert.getInstance().getValue() value mismatches.", "hello", prop.s );
			assertTrue( "PropertyExpert.getInstance().getValue() type mismatches.", prop.s is String );
		}
		
		public function testDeserializeArguments() : void
		{
			
		}
	}
}