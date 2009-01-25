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
	 * The FlashInspectorLayout class provides a convenient way
	 * to output messages through FlashInspector console.
	 * 
	 * @example Add FlashInspectorLayout as Log listener
	 * <pre class="prettyprint">
	 * 
	 * //Add console for all channels
	 * Logger.getInstance().addLogListener( FlashInspectorLayout.getInstance() );
	 * 
	 * //Add console for a dedicated channel
	 * Logger.getInstance().addLogListener( FlashInspectorLayout.getInstance(), PixlibDebug.CHANNEL );
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
	 * @see com.bourre.log.Logger
	 * @see com.bourre.log.LogListener
	 * @see com.bourre.log.LogLevel
	 * 
	 * @author	Francis Bourre
	 */
	public class FlashInspectorLayout implements LogListener
	{
		//--------------------------------------------------------------------
		// Constants
		//--------------------------------------------------------------------
				
		public const LOCALCONNECTION_ID 	: String = "_luminicbox_log_console";
		
		
		//--------------------------------------------------------------------
		// Private properties
		//--------------------------------------------------------------------
				
		private static var _oI 				: FlashInspectorLayout = null;
		
		
		//--------------------------------------------------------------------
		// Protected properties
		//--------------------------------------------------------------------
		
		/** @private */		
		protected var _lc 	: LocalConnection;
		
		/** @private */	
		protected var _sID 	: String;
		
		
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
		
		/**
		 * Returns unique instance.
		 */
		public static function getInstance() : FlashInspectorLayout
		{
			if ( !(FlashInspectorLayout._oI is FlashInspectorLayout) ) FlashInspectorLayout._oI = new FlashInspectorLayout( new ConstructorAccess() );
			return FlashInspectorLayout._oI;
		}
		
		/**
		 * Triggered when a log message is sent to the <code>Logger</code> and 
		 * the FlashInspector is registered as Log listener.
		 * 
		 * @param	e	<code>LogEvent</code> event containing information about 
		 * 				the message to log.
		 */
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
		
		
		//--------------------------------------------------------------------
		// Private implementation
		//--------------------------------------------------------------------
		
		/** @private */		
		function FlashInspectorLayout( access : ConstructorAccess )
		{
			if ( !(access is ConstructorAccess) ) throw new PrivateConstructorException();

			_lc = new LocalConnection();
			_lc.addEventListener( StatusEvent.STATUS, onStatus);
            _lc.addEventListener( SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			_sID = String( ( new Date()).getTime() );
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