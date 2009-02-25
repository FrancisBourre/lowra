package com.bourre.ioc.bean
{
	import flexunit.framework.TestCase;
	
	import com.bourre.ioc.bean.BeanFactory;	

	public class BeanFactoryTest 
		extends TestCase
	{
		private var _oBF:BeanFactory;
		private var _o : Object;
		private var _oL : MockBeanFactory;

		public override function setUp():void
		{
			BeanFactory.release();

			_oBF = BeanFactory.getInstance();
			_oL = new MockBeanFactory();
		}
		
		public function testConstruct() :void
		{
			assertNotNull( "BeanFactory constructor returns null", BeanFactory.getInstance() );
		}

		public function testAddAndRemoveListener():void
		{
			_o = new Object();
			var key : String = "key";

			assertTrue("Listener not added", _oBF.addListener(_oL) );

			assertTrue( "Bean registration failed", _oBF.register( key, _o ) );

			assertTrue( "Event [bean registered] not called", _oL.registerCalled );

			assertTrue ( "Key not registered", _oBF.isRegistered( key ) ); 
			assertTrue ( "Bean not registered", _oBF.isBeanRegistered( _o ) );
			assertNotNull( "Key not located", _oBF.locate( key ) );
			
			assertTrue( "Bean unregistration failed", _oBF.unregister( key ) );
			assertTrue ( "Bean not unregistered", _oL.unregisterCalled );

			assertTrue( "Listener not removed", _oBF.removeListener( _oL ) );
		}
	}
}