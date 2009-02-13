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
	import flash.events.Event;

	/**
	 * The LogEvent class represents the event object passed 
	 * to the event listener for Logger events.
	 * 
	 * @see Logger
	 * 
	 * @author Francis Bourre
	 */
	public class LogEvent extends Event
	{
		//--------------------------------------------------------------------
		// Events
		//--------------------------------------------------------------------
		
		/**
		 * Defines the value of the <code>type</code> property of the event 
		 * object for a <code>onLog</code> event.
		 * 
		 * @eventType onLog
		 */	
		public static const onLogEVENT : String = "onLog";
		
		
		//--------------------------------------------------------------------
		// Public properties
		//--------------------------------------------------------------------
		
		/**
		 * Log level for current logging message.
		 * @default null
		 */		
		public var level : LogLevel;
		
		/**
		 * Message
		 * @default *
		 */	
		public var message : *;
		
		/**
		 * Name of the used channel by this 
		 * logging event.
		 * 
		 * @default null
		 */
		public var channel : String;
		
		
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
		
		/**
		 * Creates instance.
		 * 
		 * @param	level	LogLevel status
		 * @param	message	Message to send
		 */		
		public function LogEvent( level : LogLevel, message : * = undefined )
		{
			super( LogEvent.onLogEVENT, false, false );

			this.level = level;
			this.message = message;
		}
		
		/**
		 * Duplicates an instance of an Event subclass. 
		 * 
		 * <p>The new Event object includes all the properties of the 
		 * original.</p>
		 * 
		 * @return	A new Event object that is identical to the original.
		 */
		public override function clone() : Event 
		{
            return new LogEvent( level, message );
        }
        
        /**
		 * Returns the string representation of this instance.
		 * 
		 * @return The string representation of this instance
		 */
		public override function toString() : String 
		{
			return PixlibStringifier.stringify( this );
		}
	}
}