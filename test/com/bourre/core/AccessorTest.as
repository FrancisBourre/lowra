package com.bourre.core
{
	import com.bourre.core.AccessorFactory;
	
	import flexunit.framework.TestCase;	

	public class AccessorTest extends TestCase
	{
		private var _o : MockAccessor;
		private var _pa : Accessor;
		private var _ma : Accessor;
		private var _ac : AccessorComposer;
		
		private var errorOccurs:Boolean;
		
		public override function setUp () : void
		{
			_o = new MockAccessor();
			_pa = AccessorFactory.getAccessor( _o, "prop" );
			_ma = AccessorFactory.getAccessor( _o, "setProp", "getProp" );
			_ac = AccessorFactory.getMultiAccessor ( _o, [ "setProp", "prop" ],[ "getProp" ] );
		}

		public function testConstruct () : void
		{
			assertNotNull( "AccessorFactory failed to create the corresponding accessor - test1 failed", _pa );
			assertNotNull( "AccessorFactory failed to create the corresponding accessor - test2 failed", _ma );
			assertNotNull( "AccessorFactory failed to create the corresponding accessor composer - test3 failed", _ac );
			// null target	
			errorOccurs = false;
			try
			{
				var ua1 : Accessor = AccessorFactory.getAccessor( null, null );
			}
			catch ( e : Error )
			{
				errorOccurs = true;
			}
			assertTrue ( "AccessorFactory don't failed when building an accessor on a null object - test4 failed", errorOccurs );
			
			// non-owned setter proprety
			errorOccurs = false;
			try
			{
				var ua2 : Accessor = AccessorFactory.getAccessor( _o, "pouet" );
			}
			catch ( e : Error )
			{
				errorOccurs = true;
			}
			assertTrue ( "AccessorFactory don't failed when building an accessor on an undefined property - test5 failed", errorOccurs );
			
			// non-owned getter proprety
			errorOccurs = false;
			try
			{
				var ua3 : Accessor = AccessorFactory.getAccessor( _o, "setProp", "pouet" );
			}
			catch ( e : Error )
			{
				errorOccurs = true;
			}
			assertTrue ( "AccessorFactory don't failed when building an accessor with an invalid getter parameter - test6 failed", errorOccurs );
			
			// non-owned getter proprety
			errorOccurs = false;
			try
			{
				var ua4 : AccessorComposer = AccessorFactory.getMultiAccessor( _o, ["setProp", "pouett"] );
			}
			catch ( e : Error )
			{
				errorOccurs = true;
			}
			assertTrue ( "AccessorFactory don't failed when building a multi accessor with invalids setters - test7 failed", errorOccurs );
		}
				
		public function testAccessValue () : void
		{
			assertEquals ( _pa + ".getValue() don't return the original value - test1 failed", _pa.getValue(), 25 );
			assertEquals ( _ma + ".getValue() don't return the original value - test2 failed", _ma.getValue(), 250 ); 
			
			_pa.setValue( 80 );
			_ma.setValue( 800 );
			
			assertEquals ( _pa + ".getValue() don't return the modified value - test3 failed", _pa.getValue(), 80 );
			assertEquals ( _ma + ".getValue() don't return the modified value - test4 failed", _ma.getValue(), 800 ); 
		}
		
		public function testHelpers () : void
		{
			assertEquals ( _pa + ".getSetterHelper() don't the correct property name - test1 failed", _pa.getSetterHelper(), "prop" );
			assertEquals ( _pa + ".getGetterHelper() don't the correct property name - test2 failed", _pa.getGetterHelper(), "prop" ); 
			
			assertEquals ( _ma + ".getSetterHelper() don't the correct setter name - test3 failed", _ma.getSetterHelper(), "setProp" );
			assertEquals ( _ma + ".getGetterHelper() don't the correct getter name - test4 failed", _ma.getGetterHelper(), "getProp" ); 
		}
	}
}