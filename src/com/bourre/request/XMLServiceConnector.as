package com.bourre.request
{
	import flash.net.XMLSocket;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.DataEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.ProgressEvent;
	import flash.utils.getQualifiedClassName;
	import com.bourre.log.PixlibDebug;
	
	public class XMLServiceConnector extends AbstractDataServiceConnector
	{
		
		private var _oXMLSocket : XMLSocket ;
		public var isDebug : Boolean
		
		
		public function XMLServiceConnector(url : String)
		{
			super(url) ;
			
			var a:Array = url.split(":");
			Security.loadPolicyFile ("http://" + a[0] + "/crossdomain.xml");
			
			_oXMLSocket = new XMLSocket () ;
			isDebug = false
			
			_oXMLSocket.addEventListener( Event.CLOSE, onClose ) ;
            _oXMLSocket.addEventListener( Event.CONNECT, onConnect ) ;
            _oXMLSocket.addEventListener( DataEvent.DATA, onDataReceived ) ;
            _oXMLSocket.addEventListener( IOErrorEvent.IO_ERROR, onIOError ) ;
            _oXMLSocket.addEventListener( ProgressEvent.PROGRESS, onProgress ) ;
            _oXMLSocket.addEventListener( SecurityErrorEvent.SECURITY_ERROR, onSecurityError ) ;
		}
		
		override protected function doRequest(e : DataService):void
		{
			setDataService( e );
			if (!_oXMLSocket.connected)
			{
				_oXMLSocket.connect(_url, _port) ;
				
			}
			else
			{
				_oXMLSocket.send(getDataService().getArguments()) ;
			}
		}
		
		public override function release():void
		{
			_oXMLSocket.close() ;
		}
		
		public function onConnect(event:Event):void
		{
			if(isDebug) PixlibDebug.DEBUG("[XMLServiceConnector]::onConnect()")
			_oXMLSocket.send(getDataService().getArguments()) ;
		}
		
		public function onClose(event:Event):void
		{
			if(isDebug) PixlibDebug.DEBUG("[XMLServiceConnector]::onClose()")
			doNextRequest() ;
		}
		
		public function onProgress(event:Event):void
		{
			//fireEvent(event)
		}
		
		public function onDataReceived(event : DataEvent):void
		{
			if(isDebug) PixlibDebug.DEBUG("[XMLServiceConnector]::onDataReceived() " + event.data)
			 this.fireResult( event.data, DataServiceEvent.onDataResultEVENT)
		}
		
		public function onIOError(event:IOErrorEvent):void
		{
			if(isDebug) PixlibDebug.DEBUG("[XMLServiceConnector]::onIOError() " + event.text)
			 this.fireResult( event.text, DataServiceEvent.onDataErrorEVENT)
		}
		
		public function onSecurityError(event:SecurityErrorEvent) : void
		{
			if(isDebug) PixlibDebug.DEBUG("[XMLServiceConnector]::onSecurityError() " + event.text)
			 this.fireResult( event.text, DataServiceEvent.onDataErrorEVENT)

		}
	}
}