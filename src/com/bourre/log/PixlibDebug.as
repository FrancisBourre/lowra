package com.bourre.log 
{
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

	/**
	 * @author Francis Bourre
	 * @version 1.0
	 */

	import com.bourre.events.EventChannel;

	public class PixlibDebug 
		implements Log
	{
		private static var _oI : PixlibDebug;

		protected var _channel : EventChannel;
		protected var _bIsOn : Boolean;

		public function PixlibDebug( constructorAccess : PrivateConstructorAccess )
		{
			_channel = new PixlibDebugChannel();
			on();
		}

		public static function getInstance() : Log
		{
			if ( !( PixlibDebug._oI is PixlibDebug ) ) 
				PixlibDebug._oI = new PixlibDebug( new PrivateConstructorAccess() );

			return PixlibDebug._oI;
		}

		public static function get CHANNEL() : EventChannel
		{
			return PixlibDebug.getInstance().getChannel();
		}

		public static function get isOn() : Boolean
		{
			return PixlibDebug.getInstance().isOn();
		}

		public static function set isOn( b : Boolean ) : void
		{
			if ( b ) PixlibDebug.getInstance().on() else PixlibDebug.getInstance().off();
		}

		public static function DEBUG( o : * ) : void
		{
			PixlibDebug.getInstance().debug( o );
		}

		public static function INFO( o : * ) : void
		{
			PixlibDebug.getInstance().info( o );
		}

		public static function WARN( o : * ) : void
		{
			PixlibDebug.getInstance().warn( o );
		}

		public static function ERROR( o : * ) : void
		{
			PixlibDebug.getInstance().error( o );
		}

		public static function FATAL( o : * ) : void
		{
			PixlibDebug.getInstance().fatal( o );
		}
		
		//
		public function debug(o : *) : void
		{
			if ( isOn() ) Logger.DEBUG ( o, _channel );
		}
		
		public function info(o : *) : void
		{
			if ( isOn() ) Logger.INFO ( o, _channel );
		}
		
		public function warn(o : *) : void
		{
			if ( isOn() ) Logger.WARN ( o, _channel );
		}
		
		public function error(o : *) : void
		{
			if ( isOn() ) Logger.ERROR ( o, _channel );
		}
		
		public function fatal(o : *) : void
		{
			if ( isOn() ) Logger.FATAL ( o, _channel );
		}
		
		public function getChannel() : EventChannel
		{
			return _channel;
		}

		public function isOn() : Boolean
		{
			return _bIsOn;
		}

		public function on() : void
		{
			_bIsOn = true;
		}

		public function off() : void
		{
			_bIsOn = false;
		}
	}
}

import com.bourre.events.EventChannel;

internal class PixlibDebugChannel 
	extends EventChannel
{}

internal class PrivateConstructorAccess {}