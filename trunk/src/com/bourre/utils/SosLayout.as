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
	import com.bourre.log.LogLevel;
	import com.bourre.log.LogListener;
	import com.bourre.log.PixlibStringifier;
	
	import flash.events.Event;
	import flash.net.XMLSocket;		
	
	/**
	 * The SosLayout class provides a convenient way
	 * to output messages through SOS Max console.
	 * 
	 * @example Add SosLayout as Log listener
	 * <pre class="prettyprint">
	 * 
	 * //Add console for all channels
	 * Logger.getInstance().addLogListener( SosLayout.getInstance() );
	 * 
	 * //Add console for a dedicated channel
	 * Logger.getInstance().addLogListener( SosLayout.getInstance(), PixlibDebug.CHANNEL );
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
	 * @author	Francis Bourre
	 * 
	 * @see http://solutions.powerflasher.com/products/sosmax/ SOS Max Console
	 * 
	 * @see com.bourre.log.Logger
	 * @see com.bourre.log.LogListener
	 * @see com.bourre.log.LogLevel
	 */
	public class SosLayout implements LogListener
	{
		//--------------------------------------------------------------------
		// Private implementation
		//--------------------------------------------------------------------
				
		private static var _oI : SosLayout = null;
		
		
		//--------------------------------------------------------------------
		// Protected properties
		//--------------------------------------------------------------------
		
		/** @private */		
		protected var _oXMLSocket 	: XMLSocket;
		
		/** @private */
		protected var _aBuffer 		: Array;
		
		
		//--------------------------------------------------------------------
		// Public properties
		//--------------------------------------------------------------------
		
		/**		
		 * SOS Console IP Address.
		 * @default localhost
		 */
		public static var IP 		: String = "localhost";
		
		/**		
		 * SOS Console connection port.
		 * @default 4444
		 */
		public static var PORT 		: Number = 4444;

		
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
				
		/**
		 * Returns unique instance.
		 */
		public static function getInstance() : SosLayout
		{
			if ( !(SosLayout._oI is SosLayout) ) SosLayout._oI = new SosLayout( new ConstructorAccess() );
			return SosLayout._oI;
		}
		
		/**
		 * Sends messages to console.
		 * 
		 * <p>It is a direct access to log message into console without 
		 * use the <code>Logging API</code>.</p>
		 */
		public function output(  o : Object, level : LogLevel ) : void
		{						
			if ( _oXMLSocket.connected )
			{
				_oXMLSocket.send( "!SOS<showMessage key='" + level.getName() + "'>" + String(o) + "</showMessage>\n" );
				
			} else
			{	
				_aBuffer.push( "!SOS<showMessage key='" + level.getName() + "'>" + String(o) + "</showMessage>\n" );
			}
		}
		
		/**
		 * Clears console.
		 */
		public function clearOutput() : void
		{
			_oXMLSocket.send( "!SOS<clear/>\n" );
		}
		
		/**
		 * Triggered when a log message is sent to the <code>Logger</code> and 
		 * the SOS Console is registered as Log listener.
		 * 
		 * @param	e	<code>LogEvent</code> event containing information about 
		 * 				the message to log.
		 */
		public function onLog( e : LogEvent ) : void
		{
			output( e.message, e.level );
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
		// Protected methods
		//--------------------------------------------------------------------
		
		/** @private */			
		protected function _emptyBuffer( event : Event ) : void
		{
			var l : Number = _aBuffer.length;
			for (var i : Number = 0; i<l; i++) _oXMLSocket.send( _aBuffer[i] );
		}
		
		/** @private */	
		protected function _tryToReconnect( event : Event ) : void 
		{
            // TODO try to reconnect every n seconds
        }
        
        
        //--------------------------------------------------------------------
        // Private implementation
        //--------------------------------------------------------------------
        
        /** @private */
        function SosLayout( access : ConstructorAccess )
		{
			if ( !(access is ConstructorAccess) ) throw new PrivateConstructorException();

			_aBuffer = new Array();
			_oXMLSocket = new XMLSocket();
			_oXMLSocket.addEventListener( Event.CONNECT, _emptyBuffer );
			_oXMLSocket.addEventListener( Event.CLOSE, _tryToReconnect );
            _oXMLSocket.connect ( SosLayout.IP, SosLayout.PORT );
		}        
	}
}

internal class ConstructorAccess {}