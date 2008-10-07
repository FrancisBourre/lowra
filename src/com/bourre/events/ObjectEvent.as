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
	 * An event object which carry any object.
	 * 
	 * @author	Axel Aigret
	 * @see	com.bourre.events.BasicEvent
	 */
	 public class ObjectEvent extends BasicEvent
	{
		/** Object stored */
		private var _o : Object;
		
		/**
		 * Creates a new <code>ObjectEvent</code> object.
		 * 
		 * @param	type	name of the event type
		 * @param	target	target of this event
		 * @param	o		object carried by this event
		 */
		 public function ObjectEvent( sType : String, oTarget : Object = null, o : Object = null )
		{
			super( sType, oTarget );
			_o = o;
		}
		
		/**
		 * Returns the object carried by this event.
		 * 
		 * @return	the object carried by this event.
		 */
		public function getObject() : Object
		{
			return _o;
		}
		
		/**
		 * Clone the event
		 * 
		 * @return	a clone of the event
		 */
		override public function clone() : Event
		{
			return new ObjectEvent(type, target, _o);
		}
	}
}