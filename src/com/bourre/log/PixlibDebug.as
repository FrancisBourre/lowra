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
package com.bourre.log 
{
	import com.bourre.error.PrivateConstructorException;
	import com.bourre.events.EventChannel;	

	/**
	 * Dedicated Logging tunnel using own event channel.
	 * 
	 * <p>Heavily use in Lowra internal framework so don't connect to this 
	 * event channel if you want to kick Lowra logging messages.</p>
	 * 
	 * @example
	 * <pre class="prettyprint">
	 * 
	 * PixlibDebug.DEBUG( "my debug message" );
	 * </pre>
	 * 
	 * @author Francis Bourre
	 */
	public class PixlibDebug implements Log
	{
		//--------------------------------------------------------------------
		// Private properties
		//--------------------------------------------------------------------
				
		private static var _oI : PixlibDebug;
		
		
		//--------------------------------------------------------------------
		// Protected properties
		//--------------------------------------------------------------------
		
		/** @private */				
		protected var _channel : EventChannel;
		
		/** @private */	
		protected var _bIsOn : Boolean;
		
		
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
		
		/**
		 * Returns unique instance of PixlibDebug tunnel.
		 */	
		public static function getInstance() : Log
		{
			if ( !( PixlibDebug._oI is PixlibDebug ) ) 
				PixlibDebug._oI = new PixlibDebug( new ConstructorAccess( ) );

			return PixlibDebug._oI;
		}
		
		/**
		 * @see getChannel()
		 */
		public static function get CHANNEL() : EventChannel
		{
			return PixlibDebug.getInstance( ).getChannel( );
		}
		
		/**
		 * @see isOn()
		 */
		public static function get isOn() : Boolean
		{
			return PixlibDebug.getInstance( ).isOn( );
		}
		
		/**
		 * @see on()
		 * @see off()
		 */
		public static function set isOn( b : Boolean ) : void
		{
			if ( b ) PixlibDebug.getInstance( ).on( ); else PixlibDebug.getInstance( ).off( );
		}
		
		/**
		 * @see debug()
		 */
		public static function DEBUG( o : * ) : void
		{
			PixlibDebug.getInstance( ).debug( o );
		}
		
		/**
		 * @see info()
		 */
		public static function INFO( o : * ) : void
		{
			PixlibDebug.getInstance( ).info( o );
		}
		
		/**
		 * @see warn()
		 */
		public static function WARN( o : * ) : void
		{
			PixlibDebug.getInstance( ).warn( o );
		}
		
		/**
		 * @see error()
		 */
		public static function ERROR( o : * ) : void
		{
			PixlibDebug.getInstance( ).error( o );
		}
		
		/**
		 * @see fatal()
		 */
		public static function FATAL( o : * ) : void
		{
			PixlibDebug.getInstance( ).fatal( o );
		}

		/**
		 * @inheritDoc
		 */
		public function debug(o : *) : void
		{
			if ( isOn( ) ) Logger.DEBUG( o, _channel );
		}
		
		/**
		 * @inheritDoc
		 */
		public function info(o : *) : void
		{
			if ( isOn( ) ) Logger.INFO( o, _channel );
		}
		
		/**
		 * @inheritDoc
		 */
		public function warn(o : *) : void
		{
			if ( isOn( ) ) Logger.WARN( o, _channel );
		}
		
		/**
		 * @inheritDoc
		 */
		public function error(o : *) : void
		{
			if ( isOn( ) ) Logger.ERROR( o, _channel );
		}
		
		/**
		 * @inheritDoc
		 */
		public function fatal(o : *) : void
		{
			if ( isOn( ) ) Logger.FATAL( o, _channel );
		}
		
		/**
		 * @inheritDoc
		 */
		public function getChannel() : EventChannel
		{
			return _channel;
		}
		
		/**
		 * @inheritDoc
		 */
		public function isOn() : Boolean
		{
			return _bIsOn;
		}
		
		/**
		 * @inheritDoc
		 */
		public function on() : void
		{
			_bIsOn = true;
		}
		
		/**
		 * @inheritDoc
		 */
		public function off() : void
		{
			_bIsOn = false;
		}
		
		
		//--------------------------------------------------------------------
		// Private implementation
		//--------------------------------------------------------------------
		
		/** @private */
		function PixlibDebug( access : ConstructorAccess )
		{
			if ( !(access is ConstructorAccess) ) throw new PrivateConstructorException();
			
			_channel = new PixlibDebugChannel( );
			on( );
		}
	}
}

import com.bourre.events.EventChannel;

internal class PixlibDebugChannel extends EventChannel
{
}

internal class ConstructorAccess 
{
}