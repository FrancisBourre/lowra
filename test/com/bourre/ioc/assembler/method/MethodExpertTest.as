package com.bourre.ioc.assembler.method
{
	import com.bourre.core.HashCodeFactory;	
	import com.bourre.ioc.assembler.property.Property;	import com.bourre.ioc.bean.BeanFactory;		import flexunit.framework.TestCase;	
	public class MethodExpertTest 
		extends TestCase 
		implements MethodExpertListener
	{
		private var _oME		:MethodExpert ;
		private var _test		:TestClass ;
		private var _method 	: Method;
		private var _method2	: Method;
		private var _method3	: Method;
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
						m.arguments[0] == p) ;
		}
		
		public function testAddMethod():void
		{
			var i:Property = new Property("_test", null, "12", "int", null, null) ;
			var j:Property = new Property("_test", null, "21", "uint", null, null) ;
			
			_method = new Method("_test", 	"setPosition",	[i,j]);
			_oME.register( HashCodeFactory.getKey( _method ), _method );
			
			assertNotNull(	"MethodExpert addMethod returns null", 
							_method) ;
							
			assertTrue	 (	"MethodExpert addMethod doesn't return a Method Object", 
							_method is Method) ;
							
			assertTrue	 (	"MethodExpert addMethod method returned doesn't have expected properties", 
							_method.ownerID == "_test" && 
							_method.name == "setPosition" && 
							_method.arguments[0] == i && 
							_method.arguments[1] == j) ;
		}
		
		
		public function testCallMethod():void
		{
			var i:Property = new Property("_test", null, "12", "int", null, null) ;
			var j:Property = new Property("_test", null, "21", "uint", null, null) ;
			
			_method = new Method ("_test", 	"setPosition",	[i,j]) ;
			_oME.register( HashCodeFactory.getKey( _method ), _method );
			_oME.callMethod(HashCodeFactory.getKey( _method )) ;
			assertTrue(	"MethodExpert callMethod doesn't call the method", _test.x != 0) ;
		}
		
		
		public function testCallAllMethods():void
		{
			var i:Property = new Property("_test", null, "12", "int", null, null) ;
			var j:Property = new Property("_test", null, "21", "uint", null, null) ;
			var k:Property = new Property("_test", null, "blabla", "String", null, null) ;
			
			_method 	= new Method ("_test", 	"setPosition",	[i,j]) ;
			_method2 	= new Method ("_test", 	"setName",		[k]) ; 
			_method3 	= new Method ("_test", 	"getArgs", 		[]) ;
			
			_oME.register( HashCodeFactory.getKey( _method ), _method );
			_oME.register( HashCodeFactory.getKey( _method2 ), _method2 );
			_oME.register( HashCodeFactory.getKey( _method3 ), _method3 );
			
			_oME.callAllMethods() ;
			
			assertEquals(	"MethodExpert callAllMethods didn't call all methods -1-",
							12, _test.x) ;
			assertEquals(	"MethodExpert callAllMethods didn't call all methods -2-",
							"blabla", _test.name) ;
			assertEquals(	"MethodExpert callAllMethods didn't call all methods -3-", 
							12, _test.tab[0]) ;
		}
		
		public function testAddRemoveListener():void
		{
			var i:Property = new Property("_test", null, "12", "int", null, null) ;
			var j:Property = new Property("_test", null, "21", "uint", null, null) ;
			var k:Property = new Property("_test", null, "blabla", "String", null, null) ;
			
			_method = new Method ("_test", "setPosition", [i,j]) ;
			_oME.register( HashCodeFactory.getKey( _method ), _method );
			
			assertNotNull(	"MethodExpert addListener event not called", 
							_e) ;
							
			_e = null ;
			_oME.removeListener(this) ;
			
			_method2 = new Method ("_test", "setName", [k]) ;
			_oME.register( HashCodeFactory.getKey( _method2 ), _method2 );
			
			assertNull(	"MethodExpert removeListener event still called", 
						_e) ;
		}
		
		public function onRegisterMethod(e : MethodEvent) : void
		{
			_e = e;
		}
		
		public function onUnregisterMethod(e : MethodEvent) : void
		{
		}
	}
}

internal class TestClass
{
	public var x:int ; 
	public var y:uint ; 
	public var name:String ;
	public var tab:Array ;
	
	public function TestClass()
	{
		x = 0 ;
		y = 0 ; 
		name = "" ;
		
	}
	
	public function setPosition(x:int, y:uint):void
	{
		this.x = x ;
		this.y = y ;
	}
	
	public function setName(str:String) : void
	{
		name = str ;
	}
	
	public function getArgs():void
	{
		tab = new Array () ;
		tab.push(x) ; 
		tab.push(y) ; 
		tab.push(name) ; 
	}
	
}