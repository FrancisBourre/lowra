package com.bourre.ioc.assembler.displayobject
{
	import com.bourre.load.LoaderListener;

	public interface DisplayObjectExpertListener extends LoaderListener
	{
		function onBuildDisplayObject (e:DisplayObjectEvent) :void ;
	}
}