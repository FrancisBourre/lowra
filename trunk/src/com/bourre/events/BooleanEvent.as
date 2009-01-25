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
package com.bourre.events
{
	import flash.events.Event;		

	/**
	 * An event object which carry a boolean value.
	 * 
	 * @author 	Francis Bourre
	 * @see		BasicEvent
	 */
	public class BooleanEvent extends BasicEvent
	{
		//--------------------------------------------------------------------
		// Private properties
		//--------------------------------------------------------------------
				
		private var _b : Boolean;
		
		
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
				
		/**
		 * Creates a new <code>BooleanEvent</code> object.
		 * 
		 * @param	type	Name of the event type
		 * @param	target	Target of this event
		 * @param	bool	Boolean value carried by this event
		 */
		public function BooleanEvent( type : String, target : Object = null, bool : Boolean = false )
		{
			super( type, target );
			_b = bool;
		}
		
		/**
		 * Returns the boolean value carried by this event.
		 * 
		 * @return	the boolean value carried by this event.
		 */
		public function getBoolean() : Boolean
		{
			return _b;
		}
		
		/**
		 * Clone the event
		 * 
		 * @return	a clone of the event
		 */
		override public function clone() : Event
		{
			return new BooleanEvent(type, target, _b);
		}
	}
}