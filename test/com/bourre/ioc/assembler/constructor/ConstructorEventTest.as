package com.bourre.ioc.assembler.constructor
{
	import flexunit.framework.TestCase;

	public class ConstructorEventTest extends TestCase
	{
		
		public function testCreate() :void
		{
			var cst : Constructor = new Constructor("id","type", [1,2,3], "factory","singleton");
			var cstEvt : ConstructorEvent = new ConstructorEvent(ConstructorEvent.onRegisterConstructorEVENT, "id", cst );
			assertNotNull("failed to create ConstructorEvent", cstEvt);
			assertEquals(cstEvt+".getContructor() dont return good value", cst,cstEvt.getConstructor());
			assertEquals(cstEvt+".type dont return good value", ConstructorEvent.onRegisterConstructorEVENT,cstEvt.type);
		}
		
	}
}