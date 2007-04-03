package com.bourre.ioc.bean
{
	import flexunit.framework.TestCase;
	import com.bourre.ioc.bean.BeanFactory;
	

	public class BeanFactoryTest extends TestCase
	{
		
		private var _oBF:BeanFactory ;
		private var _oL:MockBeanFactory ;
		
		public override function setUp():void
		{
			_oBF = BeanFactory.getInstance();
			_oL = new MockBeanFactory () ;
		}
		
		public function testConstruct() :void
		{
			assertNotNull("BeanFactory constructor returns null", BeanFactory.getInstance()) ;
		}
		
		public function testAddAndRemoveListener():void
		{
			var obj:Object = new Object() ;

			var str:String = "lalala" ;

			assertTrue("Listener not added", _oBF.addListener(_oL));


			assertTrue("Bean registration failed", _oBF.register(str, obj));

			assertTrue("Event [bean registered] not called", _oL.registerCalled) ;

			assertTrue ("Key not registered", _oBF.isRegistered(str)) ; 
			assertTrue ("Bean not registered", _oBF.isBeanRegistered(obj)) ;
			assertNotNull("Key not located", _oBF.locate(str)) ;

			assertTrue("Bean unregistration failed", _oBF.unregister(str));
			assertTrue ("Bean not unregistered", _oL.unregisterCalled) ;
			
			assertTrue("Listener not removed", _oBF.removeListener(_oL)) ;
		}
	}
}