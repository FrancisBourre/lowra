package com.bourre.remoting 
{
	import com.bourre.collection.RecordSet;	

	import flash.net.Responder;	
	
	import com.bourre.remoting.events.BasicFaultEvent;		
	import com.bourre.remoting.events.BasicResultEvent;	
	
	/**
	 * @author romain
	 * @author Axel Aigret
	 */
	public class ServiceResponder 
		 extends Responder
	{
		private var _fResult : Function;
		private var _fFault : Function;
		private var _oServiceMethod : ServiceMethod;
		
		public function ServiceResponder( 	fResult:Function = null, 
											fFault:Function	= null ) 
		{
			super(this.result, this.status);
			_fResult = fResult ;
			_fFault = fFault ;
		}
		
		public function getResultFunction( ) : Function
		{
			return _fResult ;	
		}
		
		public function getFaultFunction(): Function
		{
			return _fFault ;
		}
		
		public function setServiceMethodName( o : ServiceMethod ) : void
		{
			_oServiceMethod = o ;
		}
		
		public function getServiceMethodName() : ServiceMethod
		{
			return _oServiceMethod ;
		}

		public function result( rawResult : * ) : void 
		{
			RemotingDebug.DEBUG( rawResult ? rawResult : "null" ) ;
			rawResult =  rawResult && rawResult.hasOwnProperty('serverInfo') ? new RecordSet(rawResult) : rawResult;
			
			_fResult( buildResultEvent( rawResult ) ) ;
		}
		
		public function buildResultEvent( rawResult : * ) : BasicResultEvent
		{
			return new BasicResultEvent( rawResult, _oServiceMethod ) ; 
		}
		
		public function status( rawFault : Object ) : void 
		{
			RemotingDebug.ERROR( rawFault );
		
			var  basicFaultEvent : BasicFaultEvent ;
			/*
			code
			line
			level
			details
			description
			exceptionStack
			  
			replace by
			 
			faultString
			faultCode  
			correlationId
			faultDetails
			*/
			if( rawFault.hasOwnProperty('code'))
				basicFaultEvent = new BasicFaultEvent(	rawFault.code,
														rawFault.line,
														rawFault.details, 
														rawFault.description,
														_oServiceMethod )  ;
			else
				basicFaultEvent = new BasicFaultEvent(	rawFault.faultCode,
														rawFault.correlationId,
														rawFault.faultDetails, 
														rawFault.faultString,
														_oServiceMethod ) ;
			_fFault( basicFaultEvent );
		}
		
		public function onDebugEvents( debugEvents : Array ) : void 
		{
			RemotingDebug.DEBUG( "ServiceResponder.onDebugEvents call" );
			var l:Number = debugEvents.length;
				for (var i:Number = 0; i<l; i++) RemotingDebug.DEBUG( debugEvents[ i ] );
		}
		
	}
}
