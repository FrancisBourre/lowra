package com.bourre.collection
{
	import flexunit.framework.TestCase;

	public class TypedArrayTest extends TestCase
	{
		private var _a : TypedArray;
		
		public override function setUp () : void
		{
			_a = new TypedArray ( Number );
		}
		
		public function testConstruct () : void
		{
			assertNotNull ( "TypedArray constructor returns a null object - test1 failed", _a );
			
			var a1 : TypedArray = new TypedArray ( Number, 8 );
			assertNotNull ( "TypedArray constructor returns a null object when specifing length - test2 failed", a1 );
			assertEquals ( a1 + ".length don't return the right length - test3 failed", a1.length, 8 );
			
			var a2 : TypedArray = new TypedArray ( Number, 22, 58, 67, 10 );
			assertNotNull ( "TypedArray constructor returns a null object when inserting value - test4 failed", a2 );
			assertEquals ( a2 + ".length don't return the right length - test5 failed", a2.length, 4 );
			
			var errorOccurs : Boolean = false;
			var a3 : TypedArray;
			try
			{
				a3 = new TypedArray ( Number, "120", 12, true );
			}
			catch( e : Error ) 
			{
				errorOccurs = true;
			}
			assertTrue ( "Creating an array with invalid values don't failed - test6 failed", errorOccurs );
			assertNull ( "Creating an array with invalid values don't return null - test7 failed", a3 );
		}
		
		public function testArrayAccessor () : void
		{
			var errorOccurs : Boolean = false;
			try
			{
				_a[ 0 ] = "20";
			}
			catch( e : Error )
			{
				errorOccurs = true;
			}
			assertTrue ( _a + "[ 0 ] with a string don't failed - test1 failed", errorOccurs );
			assertEquals ( _a + "[ 0 ] with a number failed - test2 failed", _a[ 0 ] = 22, 22);
		}
		
		public function testPush () : void
		{
			var errorOccurs : Boolean = false;
			assertEquals ( _a + ".push() failed to add a number - test1 failed", _a.push ( 22 ), 1 );
			assertEquals ( _a + "[ 0 ] don't return the expected value - test2 failed", _a[ 0 ], 22 );
			try
			{
				_a.push ( "20" );
			}
			catch( e : Error )
			{
				errorOccurs = true;
			}
			assertTrue ( _a + ".push() with a string don't failed - test3 failed", errorOccurs );
			assertEquals ( _a + ".push() have modify the array where arguments are invalid - test4 failed", _a.length, 1 );
		}
		
		public function testUnshift() : void
		{
			var errorOccurs : Boolean = false;
			assertEquals ( _a + ".unshift() failed to add a number - test1 failed", _a.unshift ( 22 ), 1 );
			assertEquals ( _a + "[ 0 ] don't return the expected value - test2 failed", _a[ 0 ], 22 );
			try
			{
				_a.unshift ( 20, "20", true );
			}
			catch( e : Error )
			{
				errorOccurs = true;
			}
			assertTrue ( _a + ".unshift() with a string don't failed - test3 failed", errorOccurs );
			assertEquals ( _a + ".unshift() have modify the array when arguments are invalid - test4 failed", _a.length, 1 );
		}
		
		public function testConcat () : void
		{
			var a : TypedArray;
			var errorOccurs : Boolean; 
			
			a = _a.concat ();
			assertNotNull ( _a + ".concat() returns null - test1 failed", a );
			assertTrue ( _a + ".concat() return isn't a TypedArray instance - test2 failed", a is TypedArray );
			
			a = _a.concat ( 22 );
			assertNotNull ( _a + ".concat() returns null - test3 failed", a );
			assertTrue ( _a + ".concat() return isn't a TypedArray instance - test4 failed", a is TypedArray );
			assertEquals ( _a + ".concat() don't return an array of the right length - test5 failed", a.length, 1 );
			
			a = _a.concat ( 45, 78, 80, [ 12, 16 ] );
			assertNotNull ( _a + ".concat() returns null - test6 failed", a );
			assertEquals ( _a + ".concat() don't return an array of the right length - test7 failed", a.length, 5 );
			
			errorOccurs = false;
			try
			{
				a = _a.concat( 48, "12" );
			}
			catch ( e : Error )
			{
				errorOccurs = true;
			}
			assertTrue ( _a + ".concat() don't failed with an invalid element in arguments - test8 failed", errorOccurs );
			
			errorOccurs = false;
			try
			{
				a = _a.concat ( 16, [ 15, "48"] );
			}
			catch ( e : Error )
			{
				errorOccurs = true;
			}
			assertTrue ( _a + ".concat() don't failed with an invalid element in arguments sub elements - test9 failed", errorOccurs );
		}
		
		public function testSplice () : void
		{
			var a : TypedArray;
			var errorOccurs : Boolean; 
			
			_a.splice ( 0, 0, 10, 22, 34, 48 );
			assertEquals ( _a + ".splice() don't change the length of the array - test1 failed", _a.length, 4 );
			
			a  = _a.splice ( 2, 2 );
			assertNotNull ( _a + ".splice() returns null - test2 failed", a );
			assertTrue ( _a + ".splice() return isn't a TypedArray instance - test3 failed", a is TypedArray );
			assertEquals ( _a + ".splice() don't change the length of the array - test4 failed", _a.length, 2 );
			
			errorOccurs = false;
			try
			{
				a = _a.splice ( 1, 1, "12" );
			}
			catch ( e : Error )
			{
				errorOccurs = true;
			}
			assertTrue ( _a + ".splice() don't failed to insert an invalid element - test5 failed", errorOccurs );
			assertEquals ( _a + ".splice() don't failed to insert an invalid element - test6 failed", _a.length, 2 );
			
			a = _a.splice ( 0, 1 );
			assertEquals ( _a + ".splice() failed to splice an element - test7 failed", _a.length, 1 );
			assertEquals ( _a + ".splice() returned value don't have a correct length - test8 failed", a.length, 1 );
			assertEquals ( a + " don't contains expected value - test9 failed", a[0], 10 );
			assertEquals ( _a + " don't contains expected value - test10 failed", _a[0], 22 );
		}
	}
}