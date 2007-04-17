package com.bourre.ioc.constructor
{
	import flexunit.framework.TestCase;
	import com.bourre.ioc.assembler.constructor.Constructor;

	public class ConstructorTest extends TestCase
	{
		public function testCreate()
		{
			var arg : Array = [1,2,3]
			var cst : Constructor = new Constructor("id","type", arg, "factory","singleton","channel")
			
			assertNotNull("failed to create a Constructor", cst)
			
			assertEquals(cst+".ID failed to retrived the good value", "id", cst.ID)
			assertEquals(cst+".Type failed to retrived the good value", "type", cst.Type)
			assertEquals(cst+".Arguments failed to retrived the good value", arg, cst.Arguments)
			assertEquals(cst+".Factory failed to retrived the good value", "factory", cst.Factory)
			assertEquals(cst+".Singleton failed to retrived the good value", "singleton", cst.Singleton)
			assertEquals(cst+".Channel failed to retrived the good value", "channel", cst.Channel)
		}
	}
}