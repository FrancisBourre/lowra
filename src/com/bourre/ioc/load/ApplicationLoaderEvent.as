package com.bourre.ioc.load
{
	import com.bourre.load.LoaderEvent;
	
	public class ApplicationLoaderEvent
		extends LoaderEvent
	{
		public static const onLoadStartEVENT : String = LoaderEvent.onLoadStartEVENT;
		public static const onLoadInitEVENT : String = LoaderEvent.onLoadInitEVENT;
		public static const onLoadProgressEVENT : String = LoaderEvent.onLoadProgressEVENT;
		public static const onLoadTimeOutEVENT : String = LoaderEvent.onLoadTimeOutEVENT;
		public static const onLoadErrorEVENT : String = LoaderEvent.onLoadErrorEVENT;
		
		public static const onApplicationBuiltEVENT : String = "onApplicationBuilt";
		public static const onApplicationInitEVENT : String = "onApplicationInit";
		
		public function ApplicationLoaderEvent( type : String, al : ApplicationLoader )
		{
			super( type, al );
		}
		
		public function getApplicationLoader() : ApplicationLoader
		{
			return getLoader() as ApplicationLoader;
		}
	}
}