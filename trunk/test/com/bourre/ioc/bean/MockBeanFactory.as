package com.bourre.ioc.bean
{
	import com.bourre.ioc.bean.BeanEvent;
	
	public class MockBeanFactory implements BeanFactoryListener
	{
		public var registerCalled:Boolean ;
		public var unregisterCalled:Boolean ;
		
		public function onRegisterBean(e:BeanEvent):void
		{
			registerCalled = true ;
		}
		
		public function onUnregisterBean(e:BeanEvent):void
		{
			unregisterCalled = true ;
		}
	}
}