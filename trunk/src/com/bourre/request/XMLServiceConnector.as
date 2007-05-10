package com.bourre.request
{
	import flash.net.XMLSocket;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	
	public class XMLServiceConnector extends AbstractDataServiceConnector
	{
		
		private var _oXMLSocket : XMLSocket ;
		
		public function XMLServiceConnector()
		{
			_oXMLSocket = new XMLSocket () ;
			
			super() ;
			
			_oXMLSocket.addEventListener( Event.CLOSE, onClose );
            _oXMLSocket.addEventListener( Event.CONNECT, onConnect );
            _oXMLSocket.addEventListener( DataEvent.DATA, onDataReceived );
            _oXMLSocket.addEventListener( IOErrorEvent.IO_ERROR, onIOError );
            _oXMLSocket.addEventListener( ProgressEvent.PROGRESS, onProgress );
            _oXMLSocket.addEventListener( SecurityErrorEvent.SECURITY_ERROR, onSecurityError );
		}
		
		public function request(e : DataService):void
		{
			_oService = e ;
			if (!_oXMLSocket.connected)
			{
				var url:String ;
				var port:Number ;
				
				var tab:Array = getURL().split(":") ;
				
				url = tab[0] ;
				port = tab[1]as Number ;
				
				_oXMLSocket.connect(url, port) ;
			}
		}
		
		public override function release():void
		{
			_oXMLSocket.close() ;
		}
		
		public function onConnect(event:Event):void
		{
			_oXMLSocket.send(_oService.getArguments()) ;
		}
		
		public function onDataReceived(event : DataEvent):void
		{
			_oService.setResult(event.data) ;
			(event as DataServiceEvent).setDataConnector(this) ;
			fireOnDataResult() ;
		}
		
		public function onIOError(event:IOErrorEvent):void
		{
			_oService.setResult(event) ;
			(event as DataServiceEvent).setDataConnector(this) ;
			fireOnDataError() ;
		}
		
		public function onSecurityError(event:SecurityErrorEvent)
		{
			_oService.setResult(event);
			(event as DataServiceEvent).setDataConnector(this) ;
			fireOnDataError() ;
		}
	}
}