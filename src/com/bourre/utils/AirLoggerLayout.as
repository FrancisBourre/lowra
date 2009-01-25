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
package com.bourre.utils 
{
	import com.bourre.error.PrivateConstructorException;
	import com.bourre.log.LogEvent;
	import com.bourre.log.LogListener;
	import com.bourre.log.PixlibStringifier;
	
	import flash.events.SecurityErrorEvent;
	import flash.events.StatusEvent;
	import flash.net.LocalConnection;
	import flash.utils.clearInterval;
	import flash.utils.getQualifiedClassName;
	import flash.utils.setInterval;		

	/**
	 * The AirLoggerLayout class provides a convenient way
	 * to output messages through AirLogger console.
	 * 
	 * @example Add AirLoggerLayout as Log listener
	 * <pre class="prettyprint">
	 * 
	 * //Add AirLogger for all channels
	 * Logger.getInstance().addLogListener( AirLoggerLayout.getInstance() );
	 * 
	 * //Add AirLogger for a dedicated channel
	 * Logger.getInstance().addLogListener( AirLoggerLayout.getInstance(), PixlibDebug.CHANNEL );
	 * </pre>
	 * 
	 * @example Output message
	 * <pre class="prettyprint">
	 * 
	 * //Simple ouput
	 * Logger.DEBUG( "My message" );
	 * 
	 * //Channel target
	 * Logger.WARN( "My messsage", PixlibDebug.CHANNEL );
	 * 
	 * //Channel use
	 * PixlibDebug.ERROR( "My error" );
	 * </pre>
	 * 
	 * @see http://code.google.com/p/airlogger AirLogger application on GoogleCode
	 * 
	 * @see com.bourre.log.Logger
	 * @see com.bourre.log.LogListener
	 * @see com.bourre.log.LogLevel
	 * 
	 * @author	Cédric Néhémie
	 */
	public class AirLoggerLayout implements LogListener
	{
		/*---------------------------------------------------------------
				STATIC MEMBERS
		----------------------------------------------------------------*/
		
		private static var _oI : AirLoggerLayout = null;
		
		
		/** @private */		
		protected static const LOCALCONNECTION_ID 	: String = "_AIRLOGGER_CONSOLE";
		/** @private */		
		protected static const OUT_SUFFIX 			: String = "_IN";
		/** @private */		
		protected static const IN_SUFFIX 			: String = "_OUT";
		
		/** @private */		
		static protected var ALTERNATE_ID_IN : String = "";
		
		public static function getInstance () : AirLoggerLayout
		{
			if( _oI == null )
				_oI = new AirLoggerLayout ( new ConstructorAccess() );
				
			return _oI;
		}

		/**
		 * Releases AirLogger connection and current instance.
		 */
		public static function release () : void
		{
			_oI.close();
			_oI = null;
		}

		/*---------------------------------------------------------------
				INSTANCE MEMBERS
		----------------------------------------------------------------*/
		
		/** @private */		
		protected var _lcOut : LocalConnection;
		/** @private */		
		protected var _lcIn : LocalConnection;
		/** @private */		
		protected var _sID : String;
		
		/** @private */		
		protected var _bIdentified : Boolean;
		/** @private */		
		protected var _bRequesting : Boolean;
		
		/** @private */		
		protected var _aLogStack : Array;
		/** @private */		
		protected var _nPingRequest : Number;
		
		/** @private */		
		protected var _sName : String;
		
		/** @private */
		public function AirLoggerLayout ( access : ConstructorAccess )
		{
            if ( !(access is ConstructorAccess) ) throw new PrivateConstructorException();
            
            try
            {
            	_lcOut = new LocalConnection();
				_lcOut.addEventListener( StatusEvent.STATUS, onStatus, false, 0, true);
	            _lcOut.addEventListener( SecurityErrorEvent.SECURITY_ERROR, onSecurityError, false, 0, true);
	            
	            _lcIn = new LocalConnection();
	            _lcIn.client = this;
	            _lcIn.allowDomain( "*" );
	            
				connect();
	            
	            _aLogStack = new Array();
	            
	            _bIdentified = false;
				_bRequesting = false;

            } catch ( e : Error )
            {
            	// TODO Notifier le AirLogger que le channel de requete est déja occupé
            	// se reconnecter sur un autre
            }
		}
		
		/**
		 * Connects to the AirLogger console.
		 */
		protected function connect () : void
		{
			var b : Boolean = true;
			
			while( b )
			{
				try
				{
		           _lcIn.connect( _getInConnectionName( ALTERNATE_ID_IN ) );
		           
		           b = false;
		           break;
				}
				catch ( e : Error )
				{
					_lcOut.send( _getOutConnectionName(), "mainConnectionAlreadyUsed", ALTERNATE_ID_IN );
					
					ALTERNATE_ID_IN += "_";
				}
			}
		}
		
		/**
		 * Closes connection.
		 */
		public function close() : void
		{
			_lcIn.close();
		}
		
		/**
		 * Gives focus to AirLogger console.
		 */
		public function focus() : void
		{
			_send ( new AirLoggerEvent ( "focus" ) );
		}
		
		/**
		 * Clears AirLogger console messages.
		 */
		public function clear() : void
		{
			_send ( new AirLoggerEvent ( "clear" ) );
		}
		
		/**
		 * Sets tab name for current connection in use.
		 */
		public function setName ( s : String ) : void
		{
			_sName = s;
			
			if( _bIdentified )
			{
				_lcOut.send( _getOutConnectionName( _sID ), "setTabName", _sName  );
			}
		}
		
		public function setID ( id : String ) : void
		{
			try
			{
				clearInterval( _nPingRequest );
				_sID = id;
				
				_lcIn.close();
				_lcIn.connect( _getInConnectionName( _sID ) );
				
				_lcOut.send( _getOutConnectionName() , "confirmID", id, _sName  );
				
				_bIdentified = true;
				_bRequesting = false;
				
				var l : Number = _aLogStack.length;
				if( l != 0 )
				{
					for(var i : Number = 0; i < l; i++ )
					{
						_send( _aLogStack.shift() as AirLoggerEvent );
					}
				}
			}
			catch ( e : Error )
			{
				_lcIn.connect( _getInConnectionName( ALTERNATE_ID_IN ) );
				
				_lcOut.send( _getOutConnectionName() , "idAlreadyUsed", id );
			} 
		}
		
		public function pingRequest () : void
		{
			_lcOut.send( _getOutConnectionName() , "requestID", ALTERNATE_ID_IN  );
		}
		
		public function isRequesting () : Boolean
		{
			return _bRequesting;
		}
		
		public function isIdentified () : Boolean
		{
			return _bIdentified;
		}
		
		/** @private */		
		protected function _send ( evt : AirLoggerEvent ) : void
		{
			if( _bIdentified )
			{
				_lcOut.send( _getOutConnectionName( _sID ), evt.type, evt );
			}
			else
			{
				_aLogStack.push( evt );
				
				if( !_bRequesting )
				{					
					pingRequest();
					_nPingRequest = setInterval( pingRequest, 1000 );
					_bRequesting = true;
				}
			}
		}		
		/** @private */		
		protected function _getInConnectionName ( id : String = "" ) : String
		{
			return LOCALCONNECTION_ID + id + IN_SUFFIX;
		}
		/** @private */		
		protected function _getOutConnectionName ( id : String = "" ) : String
		{
			return LOCALCONNECTION_ID + id + OUT_SUFFIX;
		}
		
		/*---------------------------------------------------------------
				EVENT HANDLING
		----------------------------------------------------------------*/
		
		/**
		 * Triggered when a log message is sent to the <code>Logger</code> and 
		 * the AriLogger is registered as Log listener.
		 * 
		 * @param	e	<code>LogEvent</code> event containing information about 
		 * 				the message to log.
		 */
		public function onLog( e : LogEvent ) : void
		{
			if( !e ) return;
			
			var evt : AirLoggerEvent = new AirLoggerEvent ( "log", 
															e.message,
															e.level.getLevel(),
															new Date(),
															getQualifiedClassName( e.message ) ); 
			
			_send( evt );
		}
		
		private function onStatus( event : StatusEvent ) : void 
		{
         	// trace( "onStatus( " + event + ")" );
        }

        private function onSecurityError( event : SecurityErrorEvent ) : void 
        {
            // trace( "onSecurityError(" + event + ")" );
        }
        
        public function toString () : String
        {
        	return PixlibStringifier.stringify( this );
        }
	}
}

import com.bourre.events.BasicEvent;

internal class AirLoggerEvent 
	extends BasicEvent
{
	public var message : *;
	public var level : uint;
	public var date : Date;
	public var messageType : String;
	
	public function AirLoggerEvent( sType : String, message : * = null, level : uint = 0, date : Date = null, messageType : String = null ) 
	{
		super( sType, null );
		
		this.message = message;
		this.level = level;
		this.date = date;
		this.messageType = messageType;
	}
}

internal class ConstructorAccess {}