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
	import com.bourre.log.*;
	
	import flash.events.SecurityErrorEvent;
	import flash.events.StatusEvent;
	import flash.net.LocalConnection;	
	/**
	 * @author Francis Bourre
	 * @version 1.0
	 */
	public class FlashInspectorLayout 
		implements LogListener
	{
		private static var _oI 				: FlashInspectorLayout = null;
		public const LOCALCONNECTION_ID 	: String = "_luminicbox_log_console";
		
		protected var _lc 	: LocalConnection;
		protected var _sID 	: String;

		public function FlashInspectorLayout( access : ConstructorAccess )
		{
			if ( !(access is ConstructorAccess) ) throw new PrivateConstructorException();

			_lc = new LocalConnection();
			_lc.addEventListener( StatusEvent.STATUS, onStatus);
            _lc.addEventListener( SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			_sID = String( ( new Date()).getTime() );
		}
		
		public static function getInstance() : FlashInspectorLayout
		{
			if ( !(FlashInspectorLayout._oI is FlashInspectorLayout) ) FlashInspectorLayout._oI = new FlashInspectorLayout( new ConstructorAccess() );
			return FlashInspectorLayout._oI;
		}
		
		public function onLog( e : LogEvent ) : void
		{
			var o:Object = new Object();
			o.loggerId = _sID;
			o.levelName = e.level.getName();
			o.time = new Date();
			o.version = .15;

			var data : Object = new Object();
			data.type = "string";
			data.value = e.message.toString();
			o.argument = data;

			_lc.send( LOCALCONNECTION_ID, "log", o );
		}
		
		/**
		 * Returns the string representation of this instance.
		 * @return the string representation of this instance
		 */
		public function toString() : String 
		{
			return PixlibStringifier.stringify( this );
		}

		private function onStatus( event : StatusEvent ) : void 
		{
        	//
        }

        private function onSecurityError( event : SecurityErrorEvent ) : void 
        {
            trace( "onSecurityError(" + event + ")" );
        }
	}
}

internal class ConstructorAccess {}