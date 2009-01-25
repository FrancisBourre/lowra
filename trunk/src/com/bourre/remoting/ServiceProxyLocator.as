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
	import com.bourre.collection.HashMap;
	import com.bourre.core.Locator;
	import com.bourre.log.PixlibDebug;
	
	import flash.net.URLRequest;
	import flash.utils.Dictionary;		

	/**
	 * The ServiceProxyLocator class.
	 * 
	 * <p>TODO Documentation.</p>
	 * 
	 * @author 	Romain Flacher
	 */
	public class ServiceProxyLocator implements Locator
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

		/**
	     * Returns an <code>Array</code> view of the keys contained in this locator.
	     *
	     * @return an array view of the keys contained in this locator
	     */
		public function getKeys() : Array
		{
			return _m.getKeys();
		}

		/**
	     * Returns an <code>Array</code> view of the values contained in this locator.
	     *
	     * @return an array view of the values contained in this locator
	     */
		public function getValues() : Array
		{
			return _m.getValues();
		}
	}
}
internal class PrivateConstructorAccess {}