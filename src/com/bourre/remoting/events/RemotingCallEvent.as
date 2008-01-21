package com.bourre.remoting.events {
	import com.bourre.load.LoaderEvent;	
	import com.bourre.remoting.RemotingCall;	
	
	/**
	 * @author romain
	 */
	public class RemotingCallEvent extends LoaderEvent
	{
		private var _oResult : Object;
		public static var onLoadInitEVENT : String = LoaderEvent.onLoadInitEVENT;
		public static var onLoadErrorEVENT : String = LoaderEvent.onLoadErrorEVENT;
		
		public function RemotingCallEvent( e : String, oLib : RemotingCall, result : Object = null)
		{
			super( e, oLib );
			
			_oResult = result;
		}
		
		public function getLib() : RemotingCall
		{
			return _loader as RemotingCall;
		}
		
		public function getResult() : Object
		{
			return _oResult;
		}
	}
}
