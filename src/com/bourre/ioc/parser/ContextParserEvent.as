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
 
package com.bourre.ioc.parser 
{
	import com.bourre.events.BasicEvent;					
	
	/**
	 * The DisplayObjectBuilderEvent class represents the event object passed 
	 * to the event listener for <strong>ContextParser</strong> events.
	 *  
	 * @see ContextParser
	 * 
	 * @author Francis Bourre
	 */
	public class ContextParserEvent extends BasicEvent
	{
		//--------------------------------------------------------------------
		// Events
		//--------------------------------------------------------------------
		
		/**
		 * Defines the value of the <code>type</code> property of the event 
		 * object for a <code>onContextParsingStart</code> event.
		 * 
		 * @eventType onContextParsingStart
		 */			
		public static const onContextParsingStartEVENT : String = "onContextParsingStart";
		
		/**
		 * Defines the value of the <code>type</code> property of the event 
		 * object for a <code>onContextParsingEnd</code> event.
		 * 
		 * @eventType onContextParsingEnd
		 */	
		public static const onContextParsingEndEVENT : String = "onContextParsingEnd";
		
		
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
		
		/**
		 * Creates instance.
		 */		
		public function ContextParserEvent( sType : String, cp : ContextParser )
		{
			super( sType, cp );
		}
		
		/**
		 * Returns targeted context parser.
		 */
		public function getContextParser() : ContextParser
		{
			return getTarget( ) as ContextParser;
		}
	}}