package com.bourre.ioc.context
{
	import com.bourre.load.*;
	import com.bourre.load.strategy.*;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;

	public class ContextLoader
		extends AbstractLoader 
	{
		public static const DEFAULT_URL : String = "applicationContext.xml";

		public function ContextLoader( url : URLRequest = null )
		{
			super( new URLLoaderStrategy() );

			setURL( url? url : new URLRequest( ContextLoader.DEFAULT_URL ) );
		}

		public function getContext() : XML
		{
			return XML( getContent() );
		}

		protected override function getLoaderEvent( type : String ) : LoaderEvent
		{
			return new ContextLoaderEvent( type, this );
		}

		public override function load( url : URLRequest = null, context : LoaderContext = null ) : void
		{
			release();

			super.load( url, context );
		}

		public override function release() : void
		{
			//

			super.release();
		}
	}
}