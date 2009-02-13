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
 
package com.bourre.ioc.assembler.property 
{
	import com.bourre.events.BasicEvent;
	import com.bourre.ioc.assembler.property.Property;	
	
	/**
	 * The PropertyEvent class represents the event object passed 
	 * to the event listener for <strong>PropertyExpert</strong> events.
	 * 
	 * @see PropertyExpert
	 * 
	 * @author Francis Bourre
	 */
	public class PropertyEvent extends BasicEvent
	{
		//--------------------------------------------------------------------
		// Events
		//--------------------------------------------------------------------
		
		/**
		 * Defines the value of the <code>type</code> property of the event 
		 * object for a <code>onBuildProperty</code> event.
		 * 
		 * <p>The properties of the event object have the following values:</p>
	     * <table class="innertable">
	     *     <tr><th>Property</th><th>Value</th></tr>
	     *     <tr>
	     *     	<td><code>type</code></td>
	     *     	<td>Dispatched event type</td>
	     *     </tr>
	     *     
	     *     <tr><th>Method</th><th>Value</th></tr>
	     *     <tr>
	     *     	<td><code>getExpertID()</code>
	     *     	</td><td>The property ID</td>
	     *     </tr>
	     *     <tr>
	     *     	<td><code>getProperty()</code>
	     *     	</td><td>The property object</td>
	     *     </tr>
	     * </table>
	     * 
		 * @eventType onBuildProperty
		 */			
		public static const onBuildPropertyEVENT : String = "onBuildProperty";
		
		/**
		 * Defines the value of the <code>type</code> property of the event 
		 * object for a <code>onRegisterPropertyOwner</code> event.
		 * 
		 * <table class="innertable">
	     *     <tr><th>Property</th><th>Value</th></tr>
	     *     <tr>
	     *     	<td><code>type</code></td>
	     *     	<td>Dispatched event type</td>
	     *     </tr>
	     *     
	     *     <tr><th>Method</th><th>Value</th></tr>
	     *     <tr>
	     *     	<td><code>getExpertID()</code>
	     *     	</td><td>The property ID</td>
	     *     </tr>
	     *     <tr>
	     *     	<td><code>getProperty()</code>
	     *     	</td><td>The property object</td>
	     *     </tr>
	     * </table>
	     * 
		 * @eventType onRegisterPropertyOwner
		 */	
		public static const onRegisterPropertyOwnerEVENT : String = "onRegisterPropertyOwner";
		
		/**
		 * Defines the value of the <code>type</code> property of the event 
		 * object for a <code>onUnregisterPropertyOwner</code> event.
		 * 
		 * @eventType onUnregisterPropertyOwner
		 */			public static const onUnregisterPropertyOwnerEVENT : String = "onUnregisterPropertyOwner";
		
		
		//--------------------------------------------------------------------
		// Protected properties
		//--------------------------------------------------------------------
		
		/** @private */		
		protected var _sID : String;
		
		/** @private */		protected var _oProperty : Property;
		
		
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
		
		/**
		 * Creates a new <code>PropertyEvent</code> object.
		 * 
		 * @param	type		Name of the event type
		 * @param	id			Registration ID
		 * @param	property	Property object carried by this event
		 */	
		public function PropertyEvent( type : String, id : String, property : Property = null )
		{
			super( type );

			_sID = id;
			_oProperty = property;
		}
		
		/**
		 * Returns property ID.
		 */
		public function getExpertID() : String
		{
			return _sID;
		}
		
		/**
		 * Returns the property object carried by this event.
		 * 
		 * @return	The property value carried by this event.
		 */
		public function getProperty() : Property
		{
			return _oProperty;
		}

		public function getPropertyOwnerID() : String
		{
			return _oProperty.ownerID;
		}

		public function getPropertyName() : String
		{
			return _oProperty.name;
		}

		public function getPropertyValue() : String
		{
			return _oProperty.value;
		}

		public function getPropertyType() : String
		{
			return _oProperty.type;
		}

		public function getPropertyRef() : String
		{
			return _oProperty.ref;
		}

		public function getPropertyMethod() : String
		{
			return _oProperty.method;
		}
	}
}