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
 
package com.bourre.remoting 
{
	import com.bourre.load.AbstractLoader;
	import com.bourre.log.PixlibDebug;
	import com.bourre.remoting.events.BasicFaultEvent;
	import com.bourre.remoting.events.BasicResultEvent;
	import com.bourre.remoting.events.RemotingCallEvent;
	import com.bourre.remoting.interfaces.ServiceProxyListener;
	
	import flash.net.URLRequest;
	import flash.system.LoaderContext;	

	/**
	 * The RemotingCall class.
	 * 
	 * <p>TODO Documentation.</p>
	 * 
	 * @author 	Romain Flacher
	 * @author Axel Aigret
	 */
	public class RemotingCall extends AbstractLoader implements ServiceProxyListener
	{
		private var _sServiceName : String;
		private var _oMethod : ServiceMethod;
		private var _aArgs : Array;
		private var _oResponder : ServiceResponder;

		//public static var onLoadInitEVENT : String = AbstractLoader.onLoadInitEVENT;
		//public static var onLoadProgressEVENT : String = AbstractLoader.onLoadProgressEVENT;
		//public static var onTimeOutEVENT : String = AbstractLoader.onTimeOutEVENT;
		//public static var onErrorEVENT : String = AbstractLoader.onErrorEVENT;
	
		//public static var onResultEVENT : String = ServiceResponder.onResultEVENT;
		//	public static var onFaultEVENT : String = ServiceResponder.onFaultEVENT;

		public function RemotingCall( sGatewayURL : String, 
									  sFullyQualifiedMethodName : String,
									  responder : ServiceProxyListener ) 
		{
			super( );
			
			setURL( new URLRequest( sGatewayURL ) );
			setFullyQualifiedMethodName( sFullyQualifiedMethodName );
			setResponder( responder );
		}
		
		public function setCredentials( sUserID : String, sPassword : String ) : void
		{
			RemotingConnection.getRemotingConnection( getURL( ).url ).setCredentials( sUserID, sPassword );
		}

		public function setResponder( responder : ServiceProxyListener ) : void
		{
			_oResponder = new ServiceResponder( responder.onResult, responder.onFault );
		}
		
		public function setFullyQualifiedMethodName( sFullyQualifiedMethodName : String ) : void
		{
			if ( sFullyQualifiedMethodName )
			{
				var a : Array = sFullyQualifiedMethodName.split( "." );
				setMethodName( String( a.pop( ) ) );
				setServiceName( a.join( "." ) );
			}
		}

		public function setServiceName( serviceName : String ) : void
		{
			_sServiceName = serviceName;
		}

		public function setServiceMethod( serviceMethod : ServiceMethod ) : void
		{
			_oMethod = serviceMethod;
		}

		public function setMethodName( sServiceMethod : String ) : void
		{
			if ( sServiceMethod is ServiceMethod )
			{
				PixlibDebug.FATAL( "Argument failure on " + this + ".setMethodName(). Use String argument instead." );
			} 
			else
			{
				setServiceMethod( new ServiceMethod( sServiceMethod ) );
			}
		}

		public function setArguments(...arg) : void
		{
			if ( arg.length > 0 ) _aArgs = arg;
		}

		public function getServiceName() : String
		{
			return _sServiceName;
		}

		public function getMethod() : ServiceMethod
		{
			return _oMethod;
		}

		public function getArguments() : Array
		{
			return _aArgs;
		}	 

		override public function load(url : URLRequest = null, context : LoaderContext = null ) : void
		{
			if ( url != null) this.setURL( url ) ;
			var service : AbstractServiceProxy = new AbstractServiceProxy( this.getURL( ), getServiceName( ) );
			service.callServiceWithResponderOnly.apply( service, [ getMethod( ), new ServiceResponder( this.onResult, this.onFault ) ].concat( getArguments( ) ) );
			super.load();
		}
		
		public function onResult( e : BasicResultEvent ) : void 
		{
			fireEvent( e );
			
			if (_oResponder) _oResponder.getResultFunction( )( e );
			
			fireEvent( new RemotingCallEvent( RemotingCallEvent.onLoadInitEVENT, this, e.getResult( ) ) );
			
			super.release();	
		}
		
		public function onFault( e : BasicFaultEvent ) : void 
		{
			fireEvent( e );
			
			if (_oResponder) _oResponder.getFaultFunction( )( e );
			
			fireEvent( new RemotingCallEvent( RemotingCallEvent.onLoadErrorEVENT, this ) );
			
			super.release();
		}
	}
}
