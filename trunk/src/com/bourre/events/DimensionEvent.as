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
	import com.bourre.events.BasicEvent;	import com.bourre.structures.Dimension;
	import flash.events.Event;	
	
	/**
	 * An event object which carry a <code>Dimension</code> value.
	 * 
	 * @author 	Aigret Axel
	 * 
	 * @see com.bourre.structures.Dimension
	 */
	public class DimensionEvent extends BasicEvent 
	{
		//--------------------------------------------------------------------
		// Protected properties
		//--------------------------------------------------------------------

		protected var _oDimension : Dimension ; 

		
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
		
		/**
		 * Creates a new <code>DimensionEvent</code> object.
		 * 
		 * @param	type		Name of the event type
		 * @param	target		Target of this event
		 * @param	dimension	Dimension object carried by this event
		 */
		public function DimensionEvent(type : String, target : Object = null , dimension : Dimension = null )
		{
			super( type, target );
			_oDimension = dimension ;
		}

		/**
		 * Returns the dimension object carried by this event.
		 * 
		 * @return	The dimension value carried by this event.
		 */
		public function getDimension( ) : Dimension 
		{
			return _oDimension ; 
		}

		/**
		 * Clone the event
		 * 
		 * @return	a clone of the event
		 */
		override public function clone() : Event
		{
			return new DimensionEvent( type, target, _oDimension );
		}
	}
}
