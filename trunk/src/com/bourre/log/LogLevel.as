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
	/**
	 * The LogLevel class allow to filter log messages with logging level.
	 * 
	 * @example
	 * <pre class="prettyprint">
	 * 
	 * //filter level
	 * Logger.getInstance().setLevel( LogLevel.INFO );
	 * 
	 * Logger.INFO( "this is a information message" ); //sent to all listeners
	 * Logger.DEBUG( "this is a debug message" ); //Not sent cause of level filter
	 * </pre>
	 * 
	 * @see	LogListener
	 * 
	 * @author Francis Bourre
	 */
	public class LogLevel
	{
		//--------------------------------------------------------------------
		// Constants
		//--------------------------------------------------------------------
				
		public static const ALL 	: LogLevel = new LogLevel ( uint.MIN_VALUE, "ALL" );
		public static const DEBUG 	: LogLevel = new LogLevel ( 10000, 			"DEBUG" );
		public static const INFO 	: LogLevel = new LogLevel ( 20000, 			"INFO" );
		public static const WARN	: LogLevel = new LogLevel ( 30000, 			"WARN" );
		public static const ERROR	: LogLevel = new LogLevel ( 40000, 			"ERROR" );
		public static const FATAL	: LogLevel = new LogLevel ( 50000, 			"FATAL" );
		public static const OFF		: LogLevel = new LogLevel ( uint.MAX_VALUE, "OFF" );
		
		
		//--------------------------------------------------------------------
		// Private properties
		//--------------------------------------------------------------------
				
		private var _sName : String;
		private var _nLevel : Number;
		
		
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
		
		/**
		 * Creates instance.
		 * 
		 * @param	nLevel	Minimum level the log message has to be, to 
		 * 			be compliant with this current LogLevel filter.
		 * 	@param	Name identifier for this level.
		 */		
		public function LogLevel( nLevel : uint = uint.MIN_VALUE, sName : String = "" )
		{
			_sName = sName;
			_nLevel = nLevel;
		}
		
		/**
		 * Returns the name of current level filter.
		 * 
		 * @return The name of current level filter.
		 */
		public function getName() : String
		{
			return _sName;
		}
		
		/**
		 * Returns the level filter value.
		 * 
		 * @return The level filter value.
		 */
		public function getLevel() : uint
		{
			return _nLevel;
		}
		
		/**
		 * Returns the string representation of this instance.
		 * 
		 * @return The string representation of this instance
		 */
		public function toString() : String 
		{
			return PixlibStringifier.stringify( this );
		}
	}
}
