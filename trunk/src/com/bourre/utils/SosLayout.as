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
	 * The <code>SosLayout</code> class provides a convenient way
	 * to output messages through SOS Max console.
	 * <p>
	 * To get more details, visit: 
	 * http://solutions.powerflasher.com/products/sosmax/ 
	 * </p> 
	 * @author 	Francis Bourre
	 */
	public class SosLayout 
		implements LogListener
	{
		protected var _oXMLSocket 	: XMLSocket;
		protected var _aBuffer 		: Array;
		
		public static var IP 		: String = "localhost";
		public static var PORT 		: Number = 4444;

		private static var _oI : SosLayout = null;
		
		public function SosLayout( access : ConstructorAccess )
		{
			if ( !(access is ConstructorAccess) ) throw new PrivateConstructorException();

			_aBuffer = new Array();
			_oXMLSocket = new XMLSocket();
			_oXMLSocket.addEventListener( Event.CONNECT, _emptyBuffer );
			_oXMLSocket.addEventListener( Event.CLOSE, _tryToReconnect );
            _oXMLSocket.connect ( SosLayout.IP, SosLayout.PORT );
		}
		
		public static function getInstance() : SosLayout
		{
			if ( !(SosLayout._oI is SosLayout) ) SosLayout._oI = new SosLayout( new ConstructorAccess() );
			return SosLayout._oI;
		}

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
		
		public function clearOutput() : void
		{
			_oXMLSocket.send( "!SOS<clear/>\n" );
		}
		
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
		
		//
		protected function _emptyBuffer( event : Event ) : void
		{
			var l : Number = _aBuffer.length;
			for (var i : Number = 0; i<l; i++) _oXMLSocket.send( _aBuffer[i] );
		}
		
		//
		protected function _tryToReconnect( event : Event ) : void 
		{
            // TODO try to reconnect every n seconds
        }
	}
}

internal class ConstructorAccess {}