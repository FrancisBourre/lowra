package com.bourre.request
{
	import com.bourre.events.EventBroadcaster;
	
	public class XMLSocketDataService implements DataService
	{
		private var _oResult:Object ;
		private var _oDataServiceArgument:Object ;
		private var _oEB:EventBroadcaster ; 
		
		public function XMLSocketDataService ()
		{
			_oEB = new EventBroadcaster(this) ;
		}
		
		public function setArguments(...rest):void
		{
			_oDataServiceArgument = rest as Object ;
		}
		
		public function getArguments():Object
		{
			return _oDataServiceArgument ;
		}
		
		public function addDataServiceListener(listener:Object):Boolean
		{
			return _oEB.addListener( listener );
		}
		
		public function removeDataServiceListener(listener:Object):Boolean
		{
			return _oEB.removeListener( listener );
		}
		
		public function getResult():Object
		{
			return _oResult ;
		}
		
		public function setResult(result:Object):void
		{
			_oResult = result ;
		}
		
		public function getDataServiceListener():Collection
		{
			return _oEB.getListenerCollection() ;
		}
		
	}
}