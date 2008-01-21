package com.bourre.remoting
{
	import flash.utils.Dictionary;	
	
	import com.bourre.log.PixlibDebug;	
	
	import flash.net.URLRequest;	
	
	import com.bourre.collection.HashMap;	
	import com.bourre.core.Locator;	
	
	/**
	 * @author romain
	 */
	public class ServiceProxyLocator
	  implements Locator
	{
		public var gatewayURL : URLRequest;
		private var _m : HashMap;
		
		public function ServiceProxyLocator( )
		{
			_m = new HashMap();
		}
		
		public function setCredentials( sUserID : String, sPassword : String ) : void
		{
			if ( !hasGateway() ) 
			{
				RemotingDebug.ERROR("**Error** GatewayURL is undefined in " + this );
				return;
			}
			RemotingConnection.getRemotingConnection( gatewayURL.url ).setCredentials( sUserID, sPassword );
		}
		
		public function registerService( sServiceName : String, service : AbstractServiceProxy ) : void
		{
			if ( !hasGateway() ) 
			{
				RemotingDebug.ERROR("**Error** GatewayURL is undefined in " + this );
				return;
				
			} else if ( isRegistered( sServiceName ) )
			{
				RemotingDebug.ERROR( "A service instance is already registered with '" + sServiceName + "' name." );
				return;
				
			} else
			{
				if (service)
				{
					if (service.getURL() == null ) service.setURL( gatewayURL );
					_m.put( sServiceName, service );
					
				} else
				{
					_m.put( sServiceName, new ServiceProxy( gatewayURL, sServiceName) );
				}
			}
		}
		
		// Locator implementation 
		public function isRegistered( key : String ) : Boolean
		{
			return _m.containsKey( key ) ;
		}
		
		public function locate( key : String ) : Object
		{
			if (!_m.containsKey( key ) ) 
			{
				RemotingDebug.ERROR( "Can't find Service instance with '" + key + "' name." );
			}
			return _m.get( key );
		}
		
		public function add( d : Dictionary ) : void
		{
			for ( var key : * in d ) 
			{
				try
				{
					registerService( key, d[ key ] as AbstractServiceProxy );

				} catch( e : Error )
				{
					e.message = this + ".add() fails. " + e.message;
					PixlibDebug.ERROR(e.message );
					throw( e );
				}
			}
		}
		
		
		// Util function
		public function hasGateway() : Boolean
		{
			return gatewayURL !=  null ;
		}
	}
}
internal class PrivateConstructorAccess {}