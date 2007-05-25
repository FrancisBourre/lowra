package com.bourre.ioc.context
{
	import com.bourre.load.LoaderEvent;
	
	public class ContextLoaderEvent
		extends LoaderEvent
	{
		public static const onLoadStartEVENT : String = LoaderEvent.onLoadStartEVENT;
		public static const onLoadInitEVENT : String = LoaderEvent.onLoadInitEVENT;
		public static const onLoadProgressEVENT : String = LoaderEvent.onLoadProgressEVENT;
		public static const onLoadTimeOutEVENT : String = LoaderEvent.onLoadTimeOutEVENT;
		public static const onLoadErrorEVENT : String = LoaderEvent.onLoadErrorEVENT;
		
		public function ContextLoaderEvent( type : String, cl : ContextLoader )
		{
			super( type, cl );
		}
		
		public function getContextLoader() : ContextLoader
		{
			return getLoader() as ContextLoader;
		}
		
		public function getContext() : XML
		{
			return getContextLoader().getContext();
		}
	}
}