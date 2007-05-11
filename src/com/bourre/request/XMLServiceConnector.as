package com.bourre.request
{
	import flash.net.XMLSocket;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.DataEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.ProgressEvent;
	
	public class XMLServiceConnector extends AbstractDataServiceConnector
	{
		
		private var _oXMLSocket : XMLSocket ;
		private var _oDS : DataService;
		
		public function XMLServiceConnector(url : String)
		{
			_oXMLSocket = new XMLSocket () ;
			
			super(url);
			
			_oXMLSocket.addEventListener( Event.CLOSE, onClose );
            _oXMLSocket.addEventListener( Event.CONNECT, onConnect );
            _oXMLSocket.addEventListener( DataEvent.DATA, onDataReceived );
            _oXMLSocket.addEventListener( IOErrorEvent.IO_ERROR, onIOError );
            _oXMLSocket.addEventListener( ProgressEvent.PROGRESS, onProgress );
            _oXMLSocket.addEventListener( SecurityErrorEvent.SECURITY_ERROR, onSecurityError );
		}
		
		override public function request(e : DataService):void
		{
			_oDS = e ;
			
			//_oDSEvent.setDataConnector(this) ;
			
			if (!_oXMLSocket.connected)
			{
				_oXMLSocket.connect(_url, _port) ;
			}else
			{
				_oXMLSocket.send(_oDS.getArguments()) ;
			}
			
		}
		
		public override function release():void
		{
			_oXMLSocket.close() ;
		}
		
		public function onConnect(event:Event):void
		{
			_oXMLSocket.send(_oDS.getArguments()) ;
		}
		
		public function onClose(event:Event):void
		{
			trace(this,event)
		}
		
		public function onProgress(event:Event):void
		{
			//fireEvent(event)
		}
		
		public function onDataReceived(event : DataEvent):void
		{
			_oDS.setResult(event.data);
			_oDS.fireResult()
			fireEvent(new DataServiceEvent(DataServiceEvent.onDataResultEVENT,_oDS)) ;
			fireCommandEndEvent()
			
		}
		
		public function onIOError(event:IOErrorEvent):void
		{
			_oDS.setResult(event.text) ;
			_oDS.fireError()
			fireEvent(new DataServiceEvent(DataServiceEvent.onDataErrorEVENT,_oDS));
			fireCommandEndEvent()
		}
		
		public function onSecurityError(event:SecurityErrorEvent) : void
		{
			_oDS.setResult(event.text);
			
			_oDS.fireError()
			fireEvent(new DataServiceEvent(DataServiceEvent.onDataErrorEVENT,_oDS)) ;
			fireCommandEndEvent()
		}
	}
}