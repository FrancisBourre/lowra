package com.bourre.request
{
	import com.bourre.load.FileLoader;
	
	
	public class FileRequest extends AbstractDataRequest
	{
		private var _fl : FileLoader
	
		public function FileRequest(access:AbstractDataRequestConstructorAccess)
		{
			super(this.abstractDataRequestConstructorAccess);
		}

		public function FileRequest( url : String = null ) 
		{
			super()
			_fl= new FileLoader(url)
		}
		
		public function setURL( url : String = null ) : Void
		{
			_fl.setURL(url)
		}
		
		public function setArguments( parser : IFileParser ) : Void
		{
			//_fl.setParser( parser )
		}
		
		public function execute( e : IEvent ) : Void
		{
			_oResult = null
			
			_fl//.execute()
		}
		
		public function loadError( e : ErrorEvent ) : Void
		{
			fireEvent( _eError )
		}
		
		public function loadComplet( e : Event ) : Void 
		{
			_oResult = FileLibEvent(e).getData()
			fireEvent( _eResult )
		}
	
		public function loadProgress( e : ProgressEvent ) : Void 
		{
			
		}
	
		/*public function onTimeOut( e : LibEvent ) : Void 
		{
			fireEvent( _eError )
		}*/
	}
}