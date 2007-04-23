package com.bourre.ioc.assembler.constructor
{
	import flexunit.framework.TestCase;


	public class ConstructorTest extends TestCase
	{
		public function testCreate() : void
		{
			var arg : Array = [1,2,3]
			var cst : Constructor = new Constructor("id","type", arg, "factory","singleton","channel")
			
			assertNotNull("failed to create a Constructor", cst)
			
			assertEquals(cst+".ID failed to retrived the good value", "id", cst.id)
			assertEquals(cst+".Type failed to retrived the good value", "type", cst.type)
			assertEquals(cst+".Arguments failed to retrived the good value", arg, cst.arguments)
			assertEquals(cst+".Factory failed to retrived the good value", "factory", cst.factory)
			assertEquals(cst+".Singleton failed to retrived the good value", "singleton", cst.singleton)
			assertEquals(cst+".Channel failed to retrived the good value", "channel", cst.channel)
		}
	}
}