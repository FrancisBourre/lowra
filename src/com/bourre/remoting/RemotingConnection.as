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
	
	import flash.net.NetConnection;		

	/**
	 * The RemotingConnection class.
	 * 
	 * <p>TODO Documentation.</p>
	 * 
	 * @author 	Romain Flacher
	 */
	public class RemotingConnection extends NetConnection 
	{
		
		private static var _M : HashMap = new HashMap();
		
		public function RemotingConnection( sURL : String = null ) 
		{
			super();
			
			if (sURL != null)  connect( sURL );
			
		}
		
		override public function connect( sURL : String , ... rest) : void
		{
			RemotingDebug.DEBUG( this + ".connect('" + sURL + "')" );
			
			super.connect( sURL );
			RemotingConnection._addRemotingConnection( sURL, this );
		}
		
		public function setCredentials( username : String, password : String ):void  
		{
			addHeader( "Credentials", false, {userid: username, password: password} );
		}
		
		//TODO: When active deserialization of recordSet didn't work properly
		public function runDebug() : void
		{
			addHeader	("amf_server_debug", true, 
							{	amf:false, 
								error:true,
								trace:true,
								coldfusion:false, 
								m_debug:true,
								httpheaders:false, 
								amfheaders:false, 
								recordset:true/*,
								http:true,
								rtmp:true*/	}

						);
		}
		
		public function stopDebug() : void
		{
			addHeader("amf_server_debug", true, undefined );
		}
		
		public static function getRemotingConnection( sURL : String ) : RemotingConnection
		{
			if ( !RemotingConnection._M.containsKey( sURL ) ) new RemotingConnection( sURL );
			return RemotingConnection._M.get( sURL );
		}
		
		private static function _addRemotingConnection( sURL : String, o : RemotingConnection ) : void
		{
			if ( !RemotingConnection._M.containsKey( sURL ) ) RemotingConnection._M.put( sURL, o );
		}
		
	}
}
