package com.bourre.ioc.assembler.method
{
	import flexunit.framework.TestCase;
	import com.test.TestClass;
	import com.bourre.log.PixlibDebug 
	import com.bourre.ioc.bean.BeanFactory;
	import com.bourre.ioc.assembler.property.Property;
	import com.bourre.log.PixlibDebug ;

	public class MethodExpertTest extends TestCase implements MethodExpertListener
	{
		private var _oME		:MethodExpert ;
		private var _test		:TestClass ;
		private var _method		:* ;
		private var _method2	:* ;
		private var _method3	:* ;
		private var _e 			: MethodEvent ;
		
		public override function setUp():void
		{
			BeanFactory.release() ;
			MethodExpert.release() ;
			
			_test = new TestClass() ;
			BeanFactory.getInstance().register("_test", this._test) ;
			
			_oME = MethodExpert.getInstance() ;
			_oME.addListener(this) ;
			
			_e = null ;		
		}
		
		public function testConstruct():void
		{
			assertNotNull(	"MethodExpert singleton returns null", 
							_oME) ;
		}
		
		public function testMethodConstruct():void
		{
			var p:Property 	= new Property("_test", null, "123", "int", null, null) ;
			var m:Method 	= new Method("_test", "lalala", [p]) ;
			
			assertNotNull(	"Method constructor returns null", 
							m) ;
							
			assertTrue(	"Method constructor doesn't have expected property", 
						m.ownerID=="_test" && 
						m.name == "lalala" && 
						m.args[0] == p) ;
		}
		
		public function testAddMethod():void
		{
			var i:Property = new Property("_test", null, "12", "int", null, null) ;
			var j:Property = new Property("_test", null, "21", "uint", null, null) ;
			
			_method 	= _oME.addMethod ("_test", 	"setPosition",	[i,j]) ;
			
			assertNotNull(	"MethodExpert addMethod returns null", 
							_method) ;
							
			assertTrue	 (	"MethodExpert addMethod doesn't return a Method Object", 
							_method is Method) ;
							
			assertTrue	 (	"MethodExpert addMethod method returned doesn't have expected properties", 
							_method.ownerID == "_test" && 
							_method.name == "setPosition" && 
							_method.args[0] == i && 
							_method.args[1] == j) ;
		}
		
		
		public function testCallMethod():void
		{
			var i:Property = new Property("_test", null, "12", "int", null, null) ;
			var j:Property = new Property("_test", null, "21", "uint", null, null) ;
			
			_method 	= _oME.addMethod ("_test", 	"setPosition",	[i,j]) ;
			_oME.callMethod(_method) ;
			assertTrue(	"MethodExpert callMethod doesn't call the method", _test.x != 0) ;
		}
		
		
		public function testCallAllMethods():void
		{
			var i:Property = new Property("_test", null, "12", "int", null, null) ;
			var j:Property = new Property("_test", null, "21", "uint", null, null) ;
			var k:Property = new Property("_test", null, "blabla", "String", null, null) ;
			
			_method 	= _oME.addMethod ("_test", 	"setPosition",	[i,j]) ;
			_method2 	= _oME.addMethod ("_test", 	"setName",		[k]) ; 
			_method3 	= _oME.addMethod ("_test", 	"getArgs", 		[]) ;
			
			_oME.callAllMethods() ;
			
			assertEquals(	"MethodExpert callAllMethods didn't call all methods -1-",
							12, _test.x) ;
			assertEquals(	"MethodExpert callAllMethods didn't call all methods -2-",
							"blabla", _test.name) ;
			assertEquals(	"MethodExpert callAllMethods didn't call all methods -3-", 
							12, _test.tab[0]) ;
		}
		
		public function onBuildMethod(e:MethodEvent) : void
		{
			_e = e ;
		}
		
		public function testAddRemoveListener():void
		{
			var i:Property = new Property("_test", null, "12", "int", null, null) ;
			var j:Property = new Property("_test", null, "21", "uint", null, null) ;
			var k:Property = new Property("_test", null, "blabla", "String", null, null) ;
			
			_method = _oME.addMethod ("_test", "setPosition", [i,j]) ;
			
			assertNotNull(	"MethodExpert addListener event not called", 
							_e) ;
							
			_e = null ;
			_oME.removeListener(this) ;
			
			_method2 = _oME.addMethod ("_test", "setName", [k]) ;
			assertNull(	"MethodExpert removeListener event still called", 
						_e) ;
		}
	}
}