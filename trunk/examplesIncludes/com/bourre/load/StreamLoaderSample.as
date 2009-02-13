package com.bourre.load 
{
	import com.bourre.log.PixlibDebug;
	
	import flash.net.URLRequest;		

	public class StreamLoaderSample 
	{
		public function StreamLoaderSample()
		{
			var loader : StreamLoader = new StreamLoader( );
			loader.addEventListener( StreamLoaderEvent.onLoadStartEVENT, this );			loader.addEventListener( StreamLoaderEvent.onLoadProgressEVENT, this );			loader.addEventListener( StreamLoaderEvent.onLoadInitEVENT, this );
			loader.load( new URLRequest( "archive.zip" ) );
		}
		
		public function onLoadStart( event : StreamLoaderEvent ) : void
		{
			PixlibDebug.INFO( "Stream starts loading from " + event.getLoader().getURL().url );
		}

		public function onLoadProgress( event : StreamLoaderEvent ) : void
		{
			PixlibDebug.INFO( "Stream progression " + event.getLoader().getPerCent() );
		}
		
		public function onLoadInit( event : StreamLoaderEvent ) : void
		{
			PixlibDebug.INFO( "Stream loading complete " + event.getStream() );
		}
	}
}
