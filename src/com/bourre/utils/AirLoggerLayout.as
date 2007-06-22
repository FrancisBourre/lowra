package com.bourre.utils
{
	import com.bourre.log.LogEvent;
	import com.bourre.log.LogListener;
	import flash.net.LocalConnection;
	import flash.events.StatusEvent;
	import flash.events.SecurityErrorEvent;
	import com.bourre.log.PixlibStringifier;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.utils.setInterval;
	import flash.utils.clearInterval;
	import flash.utils.getQualifiedClassName;

	public class AirLoggerLayout implements LogListener
	{
		/*---------------------------------------------------------------
				STATIC MEMBERS
		----------------------------------------------------------------*/
		
		private static var _oI : AirLoggerLayout = null;
		
		protected static const LOCALCONNECTION_ID : String = "_AIRLOGGER_CONSOLE";
		protected static const OUT_SUFFIX : String = "_IN";
		protected static const IN_SUFFIX : String = "_OUT";
		
		public static function getInstance () : AirLoggerLayout
		{
			if( _oI == null )
				_oI = new AirLoggerLayout ( new PrivateConstructorAccess() );
				
			return _oI;
		}
		public static function release () : void
		{
			_oI.close();
			_oI = null;
		}
		
		/*---------------------------------------------------------------
				INSTANCE MEMBERS
		----------------------------------------------------------------*/
		
		protected var _lcOut : LocalConnection;
		protected var _lcIn : LocalConnection;
		protected var _sID : String;
		
		protected var _bIdentified : Boolean;
		protected var _bRequesting : Boolean;
		
		protected var _aLogStack : Array;
		protected var _nPingRequest : Number;
		
		public function AirLoggerLayout ( access : PrivateConstructorAccess )
		{
			_lcOut = new LocalConnection();
			_lcOut.addEventListener( StatusEvent.STATUS, onStatus, false, 0, true);
            _lcOut.addEventListener( SecurityErrorEvent.SECURITY_ERROR, onSecurityError, false, 0, true);
            
            _lcIn = new LocalConnection();
            _lcIn.client = this;
            _lcIn.allowDomain( "*" );
            _lcIn.connect( _getInConnectionName() );
            
            _aLogStack = new Array();
            
            _bIdentified = false;
			_bRequesting = false;
		}
		
		public function close() : void
		{
			_lcIn.close();
		}
		
		public function focus() : void
		{
			_send ( new AirLoggerEvent ( "focus" ) );
		}
		
		public function clear() : void
		{
			_send ( new AirLoggerEvent ( "clear" ) );
		}
		
		public function setID ( id : String ) : void
		{
			clearInterval( _nPingRequest );
			_sID = id;
			
			_lcIn.close();
			_lcIn.connect( _getInConnectionName( _sID ) );
			
			_bIdentified = true;
			_bRequesting = false;
			
			var l : Number = _aLogStack.length
			if( l != 0 )
			{
				for(var i : Number = 0; i < l; i++ )
				{
					_send( _aLogStack.shift() as AirLoggerEvent );
				}
			}
		}
		public function pingRequest () : void
		{
			_lcOut.send( _getOutConnectionName() , "requestID"  );
		}
		
		public function isRequesting () : Boolean
		{
			return _bRequesting;
		}
		
		public function isIdentified () : Boolean
		{
			return _bIdentified;
		}
		
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
		protected function _getInConnectionName ( id : String = "" ) : String
		{
			return LOCALCONNECTION_ID + id + IN_SUFFIX;
		}
		protected function _getOutConnectionName ( id : String = "" ) : String
		{
			return LOCALCONNECTION_ID + id + OUT_SUFFIX;
		}
		
		/*---------------------------------------------------------------
				EVENT HANDLING
		----------------------------------------------------------------*/
		
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

internal class AirLoggerEvent extends BasicEvent
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

internal class PrivateConstructorAccess {}