/*
 * Copyright the original author or authors.
 * 
 * Licensed under the MOZILLA PUBLIC LICENSE, Version 1.1 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *      http://www.mozilla.org/MPL/MPL-1.1.html
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
 
package com.bourre.remoting {
	import com.bourre.commands.Delegate;
	import com.bourre.events.EventBroadcaster;
	import com.bourre.log.PixlibDebug;
	import com.bourre.remoting.events.BasicFaultEvent;
	import com.bourre.remoting.events.BasicResultEvent;
	import com.bourre.remoting.interfaces.ServiceProxyListener;

	import flash.events.NetStatusEvent;
	import flash.net.URLRequest;
	import flash.utils.getQualifiedClassName;

	/**
	 * The AbstractServiceProxy class.
	 * 
	 * <p>TODO Documentation.</p>
	 * 
	 * @author 	Francis Bourre
	 */
	public class AbstractServiceProxy 
	{
		
		private var _oEB : EventBroadcaster;
		private var _sURL : URLRequest;
		private var _sServiceName : String;

		
		public function AbstractServiceProxy( sURL : URLRequest, sServiceName : String = null) 
		{
			_oEB = new EventBroadcaster( this );
			setURL( sURL );
			_sServiceName = sServiceName ? sServiceName : getQualifiedClassName( this ).replace( '::', '.' ) ;
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
			getRemotingConnection( ).setCredentials( sUserID, sPassword );
		}

		/*
		 * Event system
		 */
		public function addListener( listener : ServiceProxyListener ) : Boolean
		{
			return _oEB.addListener( listener );
		}

		public function removeListener( listener : ServiceProxyListener ) : Boolean
		{
			return _oEB.removeListener( listener );
		}

		public function addEventListener( e : ServiceMethod, listener : Object, ... rest) : Boolean
		{
			return _oEB.addEventListener.apply( _oEB, rest.length > 0 ? [ e.toString(), listener ].concat( rest ) : [ e.toString(), listener ] );
		}

		public function removeEventListener( e : ServiceMethod, listener : Object ) : Boolean
		{
			return _oEB.removeEventListener(e.toString( ), listener);
		}

		/*
		 * ServiceResponder callbacks
		 */
		public function onResult( e : BasicResultEvent ) : void
		{
			e.redirectType( );
			_oEB.broadcastEvent( e );
		}

		public function onFault( e : BasicFaultEvent ) : void
		{
			
		}

		/**
		 * Call service and attach his own service responder
		 * Service will catch and fire custom type and onFault events
		 */
		public function callServiceMethod( oServiceMethodName : ServiceMethod, ...args ) : void
		{
			var o : ServiceResponder = getServiceResponder();
			
			var patchResponder : ServiceProxyResponder = new ServiceProxyResponder(o.getResultFunction(), o.getFaultFunction()) ;
			var fDelegate : Function = Delegate.create(_onNetStatus, patchResponder) ;
			
			patchResponder.oService = this ;
			patchResponder.setServiceMethodName( oServiceMethodName );
			patchResponder.fStatusDelegate = fDelegate ;
			
			var connection : RemotingConnection = getRemotingConnection( );
			connection.addEventListener( NetStatusEvent.NET_STATUS, fDelegate) ;
			
			var a : Array = [ getFullyQualifiedMethodName( oServiceMethodName ), patchResponder ].concat( args );
			connection.call.apply( connection, a );
		}
		
		/**
		 * Call service and attach responder in argument
		 * Responder will catch onResult and onFault callbacks
		 */
		public function callServiceWithResponderOnly( oServiceMethodName : ServiceMethod, responder : ServiceResponder, ...args) : void
		{
			var patchResponder : ServiceProxyResponder = new ServiceProxyResponder(responder.getResultFunction(), responder.getFaultFunction()) ;
			var fDelegate : Function = Delegate.create(_onNetStatus, patchResponder) ;
			
			patchResponder.oService = this ;
			patchResponder.fStatusDelegate = fDelegate ;
			
			var connection : RemotingConnection = getRemotingConnection( );
			connection.addEventListener( NetStatusEvent.NET_STATUS, fDelegate) ;
			
			var a : Array = [ getFullyQualifiedMethodName( oServiceMethodName ), patchResponder ].concat( args );
			connection.call.apply( connection, a );
		}

		protected function _onNetStatus(e : NetStatusEvent, oResponder : ServiceProxyResponder) : void
		{
			RemotingDebug.DEBUG( this + " _onNetStatus" + e.info.code );
			var msg : String  ;
			const code : String = e.info.code ;
			const target : ServiceMethod = e.target as ServiceMethod ;
			switch ( code ) 
			{	
				case 'NetConnection.Call.Failed' :	
					msg = " The NetConnection.call method was not able to invoke the server-side method or command. "; 	
					RemotingDebug.ERROR( this + msg );
					fireErrorEvent( target, code, msg, oResponder.status) ;
					break;
					
				case 'NetConnection.Call.BadVersion' :	
					msg = " Packet encoded in an unidentified format. "; 	
					RemotingDebug.ERROR( this + msg );
					fireErrorEvent( target, code, msg, oResponder.status) ;
					break;	
					
				case 'NetConnection.Connect.Failed' :
					msg = " The connection attempt failed. "; 	
					RemotingDebug.ERROR( this + msg );
					fireErrorEvent( target, code, msg, oResponder.status) ;
					break;
					
				case 'NetConnection.Connect.Rejected' :
					msg = " The client does not have permission to connect to the application, the application expected different parameters from those that were passed, or the application name specified during the connection attempt was not found on the server. "; 	
					RemotingDebug.ERROR( this + msg );
					fireErrorEvent( target, code, msg, oResponder.status) ;
					break;
			}
		}

		protected function fireErrorEvent( sServiceMethodName : ServiceMethod, errorCode : String = null, errorMessage : String = null , fFault : Function = null) : void
		{
			var e : BasicFaultEvent = new BasicFaultEvent( errorCode, "", "", errorMessage, sServiceMethodName );
			PixlibDebug.FATAL( this + '.fireErrorEvent ' ) ;
			if(  fFault != null ) fFault( e ) ;
			_oEB.broadcastEvent( e );
		}

		/*
		 * Getter & ToString
		 */
		public function getServiceResponder() : ServiceResponder
		{
			return new ServiceResponder(onResult, onFault);
		}

		public function getServiceName() : String
		{
			return _sServiceName ;
		}

		public function getFullyQualifiedMethodName( oServiceMethodName : ServiceMethod  ) : String 
		{
			return getServiceName( ) + "." + oServiceMethodName.toString( ) ; 
		}

		public function toString() : String
		{
			return getQualifiedClassName( this ) + getServiceName( );
		}
	}
}

import com.bourre.remoting.AbstractServiceProxy;
import com.bourre.remoting.RemotingConnection;
import com.bourre.remoting.ServiceResponder;
import com.bourre.remoting.events.BasicFaultEvent;

import flash.events.NetStatusEvent;

internal class ServiceProxyResponder extends ServiceResponder
{
	public var fStatusDelegate : Function ;
	public var oService : AbstractServiceProxy ;
	
	public function ServiceProxyResponder(fResult:Function = null, fFault:Function = null)
    {
		super(fResult, fFault) ;
    }
    
    override public function result( rawResult : * ) : void 
	{
		var connection : RemotingConnection = oService.getRemotingConnection( );
		connection.removeEventListener( NetStatusEvent.NET_STATUS, fStatusDelegate) ;
			
		super.result(rawResult) ;
	}
	
	override public function status( rawFault : Object ) : void 
	{
		var connection : RemotingConnection = oService.getRemotingConnection( );
		connection.removeEventListener( NetStatusEvent.NET_STATUS, fStatusDelegate) ;
		
		if(rawFault is BasicFaultEvent)
		{
			getFaultFunction()(rawFault as BasicFaultEvent) ;
		}else
			super.status(rawFault) ;
	}
}