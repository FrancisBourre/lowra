package com.bourre.ioc.assembler.constructor
{
	import flexunit.framework.TestCase;
	
	import com.bourre.ioc.assembler.property.Property;
	import com.bourre.ioc.bean.BeanFactory;
	import com.bourre.ioc.control.MockInstance;	

	public class ConstructorExpertTest extends TestCase
	{
		
		private var _cstExpert : ConstructorExpert;
		

		override public function setUp () : void
		{
			ConstructorExpert.release();
			_cstExpert = ConstructorExpert.getInstance();
		}
		
		public function testCreate() : void
		{
			assertNotNull('failed to create an instance of ConstructorExpert', _cstExpert)
		}
		
		public function testBuildObjects() : void
		{
			var arg1 : Property = new Property("ownerID", null, "10", "int" );
			var arg2 : Property = new Property("ownerID", null, "21", "uint" );
			
			var cst : Constructor = new Constructor( "ownerID","com.bourre.ioc.control.MockInstance", [arg1, arg2]);
			_cstExpert.register( "ownerID",  cst );
			
			var obj : MockInstance = _cstExpert.buildObject("ownerID") as MockInstance;

			assertNotNull("failed to create a Constructor", cst);
			assertTrue(_cstExpert + ".buildObject()failed to create the object of good type ",obj is MockInstance );
			assertEquals(_cstExpert + ".buildObject() failed to create object with good value", int(10), obj.arg1);
			assertEquals(_cstExpert + ".buildObject() failed to create object with good value", uint(21), obj.arg2);
			
		}
		
		public function testBuildAllObjects() : void
		{
			var arg1 : Property = new Property("ownerID", null, "10", "int");
			var arg2 : Property = new Property("ownerID", null, "21", "uint");

			var cst : Constructor = new Constructor( "ownerID","com.bourre.ioc.control.MockInstance", [arg1, arg2]);
			_cstExpert.register( "ownerID",  cst );
			_cstExpert.buildAllObjects();

			try
			{
				var obj : * = BeanFactory.getInstance().locate("ownerID");
			}
			catch(e:Error){
				
			}
			
			
			assertNotNull(_cstExpert+"::buildAllObjects() dont create Object ",obj);
			assertTrue(_cstExpert+"::buildAllObjects() dont create Object of the good type",obj is  com.bourre.ioc.control.MockInstance);
			assertEquals(_cstExpert+"::buildAllObjects() dont create Object with the good argument",int(10) , obj.arg1);
			assertEquals(_cstExpert+"::buildAllObjects() dont create Object with the good argument",uint(21) , obj.arg2);
		}
		
		public function testBuildConstructor() : void
		{
			var arg : Array = [1,2,3];
			var cst : Constructor = new Constructor("id","type", arg, "factory","singleton");
			_cstExpert.register("id",cst );
			
			assertNotNull("failed to create a Constructor", cst);
			assertEquals(cst+".ID failed to retrived the good value", "id", cst.id);
			assertEquals(cst+".Type failed to retrived the good value", "type", cst.type);
			assertEquals(cst+".Arguments failed to retrived the good value", arg, cst.arguments);
			assertEquals(cst+".Factory failed to retrived the good value", "factory", cst.factory);
			assertEquals(cst+".Singleton failed to retrived the good value", "singleton", cst.singleton);
		}
	}
}