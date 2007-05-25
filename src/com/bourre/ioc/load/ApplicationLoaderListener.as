package com.bourre.ioc.load
{
	import com.bourre.load.LoaderListener;
	import com.bourre.load.LoaderEvent;

	public interface ApplicationLoaderListener 
		extends LoaderListener
	{
		function onApplicationBuilt( e : LoaderEvent ) : void;
		function onApplicationInit( e : LoaderEvent ) : void;
	}
}