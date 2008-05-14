package com.bourre.remoting {
	import com.bourre.log.PixlibDebug;	
	import com.bourre.commands.Delegate;	
	
	import flash.events.Event;	
	import flash.events.NetStatusEvent;	
	
	import com.bourre.events.EventBroadcaster;
	import com.bourre.remoting.events.BasicFaultEvent;
	import com.bourre.remoting.events.BasicResultEvent;
	import com.bourre.remoting.interfaces.ServiceProxyListener;
	
	import flash.net.URLRequest;
	import flash.utils.getQualifiedClassName;	
	
	/**
	 * @author romain
	 */
	public class AbstractServiceProxy {
		
		private var _oEB : EventBroadcaster;
		private var _sURL : URLRequest;
		private var _sServiceName : String;
	
	
		public function AbstractServiceProxy( sURL : URLRequest, sServiceName : String =  null) 
		{
			_oEB = new EventBroadcaster( this );
			setURL( sURL );
			_sServiceName = sServiceName ? sServiceName : getQualifiedClassName( this ).replace('::', '.') ;
		}
		
		public function setURL( url : URLRequest ) : void
		{
			_sURL = url;
		}
		
		public function getURL() : URLRequest
		{
			return _sURL;
		}
		
		public function getRemotingConnection() : RemotingConnection
		{
			return RemotingConnection.getRemotingConnection( _sURL.url );
		}
		
		public function setCredentials( sUserID : String, sPassword : String ) : void
		{
			getRemotingConnection().setCredentials( sUserID, sPassword );
		}
		
		/*
		 * Event system
		 */
		public function addListener( oL : ServiceProxyListener ) : void
		{
			_oEB.addListener(oL);
		}
		
		public function removeListener( oL : ServiceProxyListener ) : void
		{
			_oEB.removeListener(oL);
		}
		
		public function addEventListener( e:ServiceMethod, oL : *, f:Function,  ... rest) : void
		{
			var a : Array = [ e.toString(), oL , f ] ; 
			_oEB.addEventListener.apply( _oEB, rest.length > 0 ? a.concat( rest ) : a );
		}
		
		public function removeEventListener( e:ServiceMethod, oL : * ) : void
		{
			_oEB.removeEventListener(e.toString(), oL);
		}
		/*
		 * ServiceResponder callbacks
		 */
		public function onResult( e : BasicResultEvent ) : void
		{
			e.redirectType();
			_oEB.broadcastEvent( e );
		}
		
		public function onFault( e : BasicFaultEvent ) : void
		{
			_oEB.broadcastEvent( e );
		}
	
		/*
		 * abstract calls
		 */
		public function callServiceMethod( oServiceMethodName : ServiceMethod, responder : ServiceResponder, ...args ) : void
		{
			var o : ServiceResponder = responder? responder : getServiceResponder();
			o.setServiceMethodName( oServiceMethodName );
			
			var a : Array = [ getFullyQualifiedMethodName( oServiceMethodName ) , o ].concat(args);
			
			var connection : RemotingConnection = getRemotingConnection();
			connection.addEventListener(NetStatusEvent.NET_STATUS, Delegate.create( _onNetStatus,  responder.getFaultFunction()  )) ;
			connection.call.apply( connection, a );
		}
		
		public function callServiceWithResponderOnly( oServiceMethodName : ServiceMethod, responder : ServiceResponder, ...args) : void
		{
			var a : Array = [ getFullyQualifiedMethodName( oServiceMethodName ), responder ].concat(args);
			
			var connection : RemotingConnection = getRemotingConnection();
			connection.addEventListener(NetStatusEvent.NET_STATUS, Delegate.create( _onNetStatus, responder.getFaultFunction() )) ;
			connection.call.apply( connection, a );
		}
		
		protected function _onNetStatus ( fFault : Function , e : NetStatusEvent ) : void
		{
			RemotingDebug.DEBUG( this + " _onNetStatus" + e.info.code);
			var msg : String  ;
			const code : String  = e.info.code ;
			const target : ServiceMethod = e.target as ServiceMethod ;
			switch ( code ) 
			{	
				case 'NetConnection.Call.Failed' :	
					msg = " The NetConnection.call method was not able to invoke the server-side method or command. "; 	
					RemotingDebug.ERROR( this + msg  );
					fireErrorEvent( target, code, msg, fFault ) ;
					break;
					
				case 'NetConnection.Call.BadVersion' :	
					msg = " Packet encoded in an unidentified format. "; 	
					RemotingDebug.ERROR( this + msg  );
					fireErrorEvent( target, code, msg, fFault ) ;
					break;	
					
				case 'NetConnection.Connect.Failed' :
					msg = " The connection attempt failed. "; 	
					RemotingDebug.ERROR( this + msg  );
					fireErrorEvent( target, code, msg, fFault) ;
					break;
					
				case 'NetConnection.Connect.Rejected' :
					msg = " The client does not have permission to connect to the application, the application expected different parameters from those that were passed, or the application name specified during the connection attempt was not found on the server. "; 	
					RemotingDebug.ERROR( this + msg  );
					fireErrorEvent( target, code, msg,fFault ) ;
					break;
			}
		}
		
		protected function fireErrorEvent( sServiceMethodName : ServiceMethod, errorCode : String = null, errorMessage : String = null , fFault : Function = null) : void
		{
			var e : BasicFaultEvent = new BasicFaultEvent( errorCode, "", "", errorMessage, sServiceMethodName);
			PixlibDebug.FATAL( this + '.fireErrorEvent ' ) ;
			PixlibDebug.FATAL( e ) ;
			if(  fFault != null ) fFault( e ) ;
			_oEB.broadcastEvent( e );
		}

		/*
		 * Getter & ToString
		 */
		public function getServiceResponder( fResult : Function = null, fFault : Function = null) : ServiceResponder
		{
			return new ServiceResponder( fResult, fFault );
		}
		
		public function getServiceName(): String
		{
			return _sServiceName ;
		}
		
		public function getFullyQualifiedMethodName( oServiceMethodName : ServiceMethod  ) : String 
		{
			return getServiceName() + "." + oServiceMethodName.toString() ; 
		}
		
		public function toString() : String
		{
			return getQualifiedClassName( this ) + getServiceName();
		}
	}
	
}
