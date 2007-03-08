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

package com.bourre.log 
{
	import com.bourre.events.EventChannel;
	import com.bourre.error.PrivateConstructorException;
	
	public class PixlibDebug 
		extends EventChannel
	{
		public static const CHANNEL : PixlibDebug = new PixlibDebug();
		public static var isOn : Boolean = true;
		
		public function PixlibDebug()
		{
			super();
		}
		
		public static function DEBUG( o : * ) : void
		{
			if (PixlibDebug.isOn) Logger.LOG( o, LogLevel.DEBUG, PixlibDebug.CHANNEL );
		}
		
		public static function INFO( o : * ) : void
		{
			if (PixlibDebug.isOn) Logger.LOG( o, LogLevel.INFO, PixlibDebug.CHANNEL );
		}
		
		public static function WARN( o : * ) : void
		{
			if (PixlibDebug.isOn) Logger.LOG( o, LogLevel.WARN, PixlibDebug.CHANNEL );
		}
		
		public static function ERROR( o : * ) : void
		{
			if (PixlibDebug.isOn) Logger.LOG( o, LogLevel.ERROR, PixlibDebug.CHANNEL );
		}
		
		public static function FATAL( o : * ) : void
		{
			if (PixlibDebug.isOn) Logger.LOG( o, LogLevel.FATAL, PixlibDebug.CHANNEL );
		}
	}
}