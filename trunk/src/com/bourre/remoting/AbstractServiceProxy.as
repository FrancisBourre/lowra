package com.bourre.remoting {
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
			_sServiceName = sServiceName ? sServiceName : getQualifiedClassName( this );
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
			connection.call.apply( connection, a );
		}
		
		public function callServiceWithResponderOnly( oServiceMethodName : ServiceMethod, o : ServiceResponder, ...args) : void
		{
			var a : Array = [ getFullyQualifiedMethodName( oServiceMethodName ) , o ].concat(args);
			
			var connection : RemotingConnection = getRemotingConnection();
			connection.call.apply( connection, a );
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
