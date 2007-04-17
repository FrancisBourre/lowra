package com.bourre.ioc.constructor
{
	import flexunit.framework.TestCase;

	public class ConstructorEventTest extends TestCase
	{
		
		public function testCreate()
		{
			var cst : Constructor = new Constructor("id","type", arg, "factory","singleton","channel")
			var cstEvt : ConstructorEvent : new ConstructorEvent(cst)
			assertNotNull("failde to create ConstructorEvent", cstEvt)
			assertEquals(cstEvt+".getContructor() dont return good value", cst,cstEvt.getConstructor())
			assertEquals(cstEvt+".type dont return good value", ConstructorEvent.onBuildConstructorEVENT,cstEvt.type)
			
		}
		
	}
}