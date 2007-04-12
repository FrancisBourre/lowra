
package com.bourre.ioc.control
{
	import flexunit.framework.TestCase;
	import com.bourre.ioc.parser.ContextTypeList;
	
	public class BuildFactoryTest extends TestCase
	{
		public static var linkMockSingleton : Class = MockSingleton
		public static var linkMockInstance : Class = MockInstance
		public function testCreate():void
		{
			trace()
			assertNotNull("can't create instance of BuildFactory",BuildFactory.getInstance())			
		}
		
		public 	function testARRAY() :void
		{
			var tab : Array = BuildFactory.getInstance().getBuilder(ContextTypeList.ARRAY).build(ContextTypeList.ARRAY,[1,2,3])
			assertNotNull("can't create instance", tab)
			assertTrue("Can't create an Array", tab is Array)
			assertEquals("the array created don't contained the good number of elements", tab.length, 3)
			assertEquals("the array created don't contained the good value", 1, tab[0])
			assertEquals("the array created don't contained the good value", 2, tab[1])
			assertEquals("the array created don't contained the good value", 3, tab[2])
			
		}
		
		public 	function testBOOLEAN() :void
		{
			var bool : Boolean = BuildFactory.getInstance().getBuilder(ContextTypeList.BOOLEAN).build(ContextTypeList.BOOLEAN,[1])
			assertNotNull("can't create instance", bool)
			assertTrue("Can't create a Boolean" ,bool is Boolean)
			assertTrue("boolean dont contained the good value", bool)
			
			bool = true
			bool = BuildFactory.getInstance().getBuilder(ContextTypeList.BOOLEAN).build(ContextTypeList.BOOLEAN,[0])
			assertNotUndefined("can't create instance", bool)
			assertTrue("Can't create a Boolean" ,bool is Boolean)
			assertFalse("boolean dont contained the good value", bool)
			
			bool = true
			bool = BuildFactory.getInstance().getBuilder(ContextTypeList.BOOLEAN).build(ContextTypeList.BOOLEAN)
			assertNotUndefined("can't create instance", bool)
			assertTrue("Can't create a Boolean" ,bool is Boolean)
			assertFalse("boolean dont contained the good value", bool)
			
			bool = true
			bool = BuildFactory.getInstance().getBuilder(ContextTypeList.BOOLEAN).build(ContextTypeList.BOOLEAN,["nothing"])
			assertNotUndefined("can't create instance", bool)
			assertTrue("Can't create a Boolean" ,bool is Boolean)
			assertFalse("boolean dont contained the good value", bool)
		}
		
		public 	function testINSTANCE() :void
		{
			var arg1 : * = "arg1"
			var arg2 : * = 2
			var myInstance : MockInstance = BuildFactory.getInstance().getBuilder(ContextTypeList.INSTANCE).build("com.bourre.ioc.control.MockInstance",[arg1,arg2])
			assertNotNull("can't create MockInstance", myInstance)
			assertTrue("Can't create an Instance" ,myInstance is MockInstance)
			assertEquals("myInstance dont contained the good value", arg1, myInstance.arg1)
			assertEquals("myInstance dont contained the good value", arg2, myInstance.arg2)
			
			var mySingleton : MockSingleton = BuildFactory.getInstance().getBuilder(ContextTypeList.INSTANCE).build("com.bourre.ioc.control.MockSingleton",null,"getInstance")
			assertNotNull("can't create MockSingleton", mySingleton)
			assertTrue("Can't create a Boolean" ,mySingleton is MockSingleton)
			assertTrue("integer dont contained the good value", mySingleton.isCreate)
		}
		
		public 	function testINT() :void
		{
			var integer : int = BuildFactory.getInstance().getBuilder(ContextTypeList.INT).build(ContextTypeList.BOOLEAN,[-1])
			assertFalse("can't create instance", isNaN(integer))
			assertTrue("Can't create an integer" ,integer is int)
			assertEquals("integer dont contained the good value", int(-1), integer)
		}
		
		public 	function testNULL() :void
		{
			var nullvalue : Object = BuildFactory.getInstance().getBuilder(ContextTypeList.NULL).build(ContextTypeList.NULL)
			assertNull("Can't create an null value",nullvalue)
		}
		
		public 	function testNUMBER() :void
		{
			var num : Number = BuildFactory.getInstance().getBuilder(ContextTypeList.NUMBER).build(ContextTypeList.NUMBER,[1.2])
			assertFalse("can't create instance", isNaN(num))
			assertTrue("Can't create an Number", num is Number)
			assertEquals("the array created don't contained the good value", 1.2, num)
			
			num = NaN
			num = BuildFactory.getInstance().getBuilder(ContextTypeList.NUMBER).build(ContextTypeList.NUMBER,['-1.2'])
			assertFalse("can't create instance", isNaN(num))
			assertTrue("Can't create an Number", num is Number)
			assertEquals("the array created don't contained the good value", -1.2, num)
		}
		
		public 	function testOBJECT() :void
		{
			var obj : Object = BuildFactory.getInstance().getBuilder(ContextTypeList.OBJECT).build(ContextTypeList.OBJECT,[])
			assertNotNull("can't create instance", obj)
			assertTrue("Can't create an Object", obj is Object)
		}
		
		public 	function testUINT() :void
		{
			var uInterger : uint = BuildFactory.getInstance().getBuilder(ContextTypeList.UINT).build(ContextTypeList.UINT,[0])
			assertNotNull("can't create instance", uInterger)
			assertTrue("Can't create an uint", uInterger is uint)
			assertEquals("the array created don't contained the good value", 0, uInterger)
			
			uInterger = NaN 
			uInterger = BuildFactory.getInstance().getBuilder(ContextTypeList.UINT).build(ContextTypeList.UINT,["1"])
			assertFalse("can't create instance", isNaN(uInterger))
			assertTrue("Can't create an uint", uInterger is uint)
			assertEquals("the array created don't contained the good value", 1, uInterger)
		}
		public 	function testSTRING() :void
		{
			var str : String = BuildFactory.getInstance().getBuilder(ContextTypeList.STRING).build(ContextTypeList.STRING,["hello world"])
			assertNotNull("can't create instance", str)
			assertTrue("Can't create a string", str is String)
			assertEquals("the array created don't contained the good value", String("hello world"), str)
		}
		

	}
}
