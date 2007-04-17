package com.bourre.ioc.assembler.constructor
{
	import flexunit.framework.TestCase;
	import com.bourre.ioc.assembler.property.Property;
	import com.bourre.ioc.control.MockInstance;
	import com.bourre.ioc.assembler.property.PropertyEvent;
	import com.bourre.ioc.bean.BeanFactory;

	public class ConstructorExpertTest extends TestCase
	{
		
		_cstExpert : ConstructorExpert
		
		override public function () : void
		{
			_cstExpert = new ConstructorExpert.getInstance()
		}
		
		public function testCreate() : void
		{
			assertNotNull('failed to create an instance of '+ConstructorExpert, _cstExpert)
		}
		
		public function testBuildObjects() : void
		{
			var arg1 = new Property("ownerID", "x", "10", "int", "ref1", "do" )
			var arg2 = new Property("ownerID", "y", "21", "uint", "ref1", "act" )
			
			var cst : Constructor = _cstExpert.addConstructor("ownerID","com.bourre.ioc.control.MockInstance", [arg1, arg2], "factory","singleton","channel")
			
			var obj : * = _cstExpert.buildObject(cst)
			
			assertNotNull("failed to create a Constructor", cst)
			assertTrue(_cstExpert + ".buildObject()failed to creat the object of good type ",obj is MockInstance )
			assertEquals(_cstExpert + ".buildObject() failed to create object with good value", int(10), obj.arg1)
			assertEquals(_cstExpert + ".buildObject() failed to create object with good value", uint(21), obj.arg2)
			
		}
		
		public function testBuildAllObjects() : void
		{
			IDExpert.release()
		
			var arg1 = new Property("ownerID", "x", "10", "int")
			//, "ref1", "do" )
			var arg2 = new Property("ownerID", "y", "21", "uint")
			//, "ref1", "act" )
			
			var cst : Constructor = _cstExpert.addConstructor("ownerID","com.bourre.ioc.control.MockInstance", [arg1, arg2])//, "factory","singleton","channel")
			
			var propEvt : PropertyEvent = new PropertyEvent (arg1, "ownerID")//, refID : String )
			var propEvt2 : PropertyEvent = new PropertyEvent (arg2, "ownerID")//, refID : String )
			
			IDExpert.getInstance().onBuildProperty(propEvt)
			IDExpert.getInstance().onBuildProperty(propEvt2)
			
			_cstExpert.buildAllObjects()
			
			var obj = BeanFactory.getInstance().locate("ownerID")
			
			assertNotNull(_cstExpert+"::buildAllObjects() dont create Object ",obj)
			assertTrue(_cstExpert+"::buildAllObjects() dont create Object of the good type",obj is  com.bourre.ioc.control.MockInstance)
			assertEquals(_cstExpert+"::buildAllObjects() dont create Object with the good argument",arg1 , obj.arg1)
			assertEquals(_cstExpert+"::buildAllObjects() dont create Object with the good argument",arg2 , obj.arg2)
		}
		
		public function testBuildConstructor() : void
		{
			var arg : Array = [1,2,3]
			var cst : Constructor = _cstExpert.addConstructor("id","type", arg, "factory","singleton","channel")
			
			assertNotNull("failed to create a Constructor", cst)
			assertEquals(cst+".ID failed to retrived the good value", "id", cst.ID)
			assertEquals(cst+".Type failed to retrived the good value", "type", cst.Type)
			assertEquals(cst+".Arguments failed to retrived the good value", arg, cst.Arguments)
			assertEquals(cst+".Factory failed to retrived the good value", "factory", cst.Factory)
			assertEquals(cst+".Singleton failed to retrived the good value", "singleton", cst.Singleton)
			assertEquals(cst+".Channel failed to retrived the good value", "channel", cst.Channel)
		}
		
		override function
		
	}
}