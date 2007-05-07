package com.bourre.request
{
	import com.bourre.load.FileLoader;
	import flash.events.Event;
	
	
	public class FileRequest extends AbstractDataRequest
	{
		private var _fl : FileLoader
	
		public function FileRequest( url : String = null ) 
		{
			super()
			_fl= new FileLoader(url)
		}
		
		override public function setURL( url : String  ) : void
		{
			//_fl.setURL(url)
		}
		
		override public function setArguments( ...rest ) : void
		{
			//_fl.setParser( parser )
			// IFileParser )
		}
		
		override public function execute( e : Event = null ) : void
		{
			_oResult = null
			
			_fl//.execute()
		}
		
		public function loadError( e : Event ) : void
		{
			fireEvent( _eError )
		}
		
		public function loadComplet( e : Event ) : void 
		{
			//_oResult = FileLibEvent(e).getData()
			fireEvent( _eResult )
		}
	
		public function loadProgress( e : Event ) : void 
		{
			
		}
	
		/*public function onTimeOut( e : LibEvent ) : Void 
		{
			fireEvent( _eError )
		}*/
	}
}