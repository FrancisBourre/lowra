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
	import com.bourre.collection.HashMap;
	import com.bourre.error.PrivateConstructorException;
	import com.bourre.log.LogEvent;
	import com.bourre.log.LogLevel;
	import com.bourre.log.LogListener;
	
	import flash.external.ExternalInterface;	

	/**
	 * The FirebugLayout class provides a convenient way
	 * to output messages through Firebug console.
	 * 
	 * @example Add FirebugLayout as Log listener
	 * <pre class="prettyprint">
	 * 
	 * //Add Firebug for all channels
	 * Logger.getInstance().addLogListener( FirebugLayout.getInstance() );
	 * 
	 * //Add Firebug for a dedicated channel
	 * Logger.getInstance().addLogListener( FirebugLayout.getInstance(), PixlibDebug.CHANNEL );
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
	 * @see https://addons.mozilla.org/fr/firefox/addon/1843 Firebug extension for Firefox
	 * 
	 * @see com.bourre.log.Logger
	 * @see com.bourre.log.LogListener
	 * @see com.bourre.log.LogLevel
	 * 
	 * @author	Romain Ecarnot
	 */
	public class FirebugLayout implements LogListener
	{
		//--------------------------------------------------------------------
		// Constants
		//--------------------------------------------------------------------

		private const CONSOLE_DEBUG_METHOD : String = "console.debug";
		private const CONSOLE_INFO_METHOD : String = "console.info";
		private const CONSOLE_WARN_METHOD : String = "console.warn";
		private const CONSOLE_ERROR_METHOD : String = "console.error";
		private const CONSOLE_FATAL_METHOD : String = "console.error";
		
		
		//--------------------------------------------------------------------
		// Private properties
		//--------------------------------------------------------------------

		private static var _oI : FirebugLayout = null;

		private var _mFormat : HashMap;

		
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
		
		/**
		 * Retreives <code>FirebugLayout</code> unique instance.
		 */
		public static function getInstance() : FirebugLayout
		{
			if( _oI == null )
				_oI = new FirebugLayout( new ConstructorAccess( ) );
				
			return _oI;
		}
		
		/**
		 * Triggered when a log message is sent to the <code>Logger</code> and 
		 * the Firebug is registered as Log listener.
		 * 
		 * @param	e	<code>LogEvent</code> event containing information about 
		 * 				the message to log.
		 */
		public function onLog( event : LogEvent ) : void
		{
			var methodName : String = _mFormat.get( event.level );
				
			try
			{
				if( ExternalInterface.available )
				{
					ExternalInterface.call( methodName, event.message );
				}
			}
			catch( e : Error ) {}
		}
		
		/**
		 * Writes the passed-in <code>caption</code> message to the console and opens 
		 * a nested block to indent all future messages sent to the console.
		 */
		public function openGroup( caption : String ) : void
		{
			var title : String = ( caption ) ? caption : 'new group';
			
			try
			{
				if( ExternalInterface.available )
				{
					ExternalInterface.call( 'console.group', title );
				}
			}
			catch( e : Error ) { }
		}
		
		/**
		 * Closes the most recently opened block created by a call to 
		 * <code>openGroup()</code> method.
		 */
		public function closeGroup( ) : void
		{
			try
			{
				if( ExternalInterface.available )
				{
					ExternalInterface.call( 'console.groupEnd' );
				}
			}
			catch( e : Error ) {}
		}
		
		
		//--------------------------------------------------------------------
		// Private implementations
		//--------------------------------------------------------------------		
		
		/** @private */
		function FirebugLayout( access : ConstructorAccess )
		{
			if ( !(access is ConstructorAccess) ) throw new PrivateConstructorException();
			
			_initMethodMap( );
		}
		
		private function _initMethodMap( ) : void
		{
			_mFormat = new HashMap( );
			_mFormat.put( LogLevel.DEBUG, CONSOLE_DEBUG_METHOD );
			_mFormat.put( LogLevel.INFO, CONSOLE_INFO_METHOD );
			_mFormat.put( LogLevel.WARN, CONSOLE_WARN_METHOD );
			_mFormat.put( LogLevel.ERROR, CONSOLE_ERROR_METHOD );
			_mFormat.put( LogLevel.FATAL, CONSOLE_FATAL_METHOD );
		}
	}
}

internal class ConstructorAccess 
{
}