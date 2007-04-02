package com.bourre.ioc.bean
{
	import com.bourre.ioc.bean.BeanEvent ;
	
	public interface BeanFactoryListener
	{
		function onRegisterBean		(e:BeanEvent) : void ;
		function onUnregisterBean	(e:BeanEvent) : void ;
	}
}