package com.bourre.ioc.load {
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	
	import com.bourre.ioc.context.ContextLoader;
	import com.bourre.load.*;
	import com.bourre.log.PixlibDebug;	

	public class ApplicationLoader
		extends AbstractLoader
		implements LoaderListener
	{
		public static const DEFAULT_URL : String = "applicationContext.xml";

		private var _oContextLoader : ContextLoader;

		public function ApplicationLoader( url : URLRequest = null )
		{
			setListenerType( ApplicationLoaderListener );

			setURL( url? url : new URLRequest( ApplicationLoader.DEFAULT_URL ) );
			
			_oContextLoader = new ContextLoader( url );
			_oContextLoader.addListener( this );
		}
		
		public function addApplicationLoaderListener( listener : ApplicationLoaderListener ) : Boolean
		{
			return addListener( listener );
		}
		
		public function removeApplicationLoaderListener( listener : ApplicationLoaderListener ) : Boolean
		{
			return removeListener( listener );
		}

		override protected function getLoaderEvent( type : String ) : LoaderEvent
		{
			return new ApplicationLoaderEvent( type, this );
		}

		override public function load( url : URLRequest = null, context : LoaderContext = null ) : void
		{
			release();

			if ( url ) setURL( url );
			
			if ( getURL() )
			{
				_oContextLoader.load( getURL() );

			} else
			{
				PixlibDebug.ERROR( this + ".load() can't retrieve file url." );
			}
		}

		override public function release() : void
		{
			//

			super.release();
		}
		
		override public function getBytesLoaded() : uint
		{
			return _oContextLoader.getBytesLoaded();
		}
		
		override public function getBytesTotal() : uint
		{
			return _oContextLoader.getBytesTotal();
		}
		
		/**
		 * Loader callbacks
		 */
		public function onLoadStart( e : LoaderEvent ) : void
		{
			fireOnLoadStartEvent();
		}

		public function onLoadInit( e : LoaderEvent ) : void
		{
			fireOnLoadInitEvent();
		}

		public function onLoadProgress( e : LoaderEvent ) : void
		{
			fireOnLoadProgressEvent();
		}

		public function onLoadTimeOut( e : LoaderEvent ) : void
		{
			fireOnLoadTimeOut();
		}

		public function onLoadError( e : LoaderEvent ) : void
		{
			fireOnLoadErrorEvent( e.getMessage() );
		}
	}
}