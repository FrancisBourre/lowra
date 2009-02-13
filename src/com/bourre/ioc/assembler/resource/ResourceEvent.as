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
 
package com.bourre.ioc.assembler.resource
{
	import com.bourre.events.BasicEvent;				
	
	/**
	 * The ResourceEvent class represents the event object passed 
	 * to the event listener for <strong>ResourceExpert</strong> events.
	 * 
	 * @see ResourceExpert
	 * 
	 * @author Romain Ecarnot
	 */
	public class ResourceEvent extends BasicEvent
	{
		//--------------------------------------------------------------------
		// Events
		//--------------------------------------------------------------------
		
		/**
		 * Defines the value of the <code>type</code> property of the event 
		 * object for a <code>onRegisterResource</code> event.
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
	     *     	<td><code>getResource()</code>
	     *     	</td><td>The property object</td>
	     *     </tr>
	     * </table>
	     * 
		 * @eventType onRegisterResource
		 */			
		public static const onRegisterResourceEVENT : String = "onRegisterResource";		
		/**
		 * Defines the value of the <code>type</code> property of the event 
		 * object for a <code>onUnregisterResource</code> event.
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
	     *     	<td><code>getResource()</code>
	     *     	</td><td>The property object</td>
	     *     </tr>
	     * </table>
	     * 
		 * @eventType onUnregisterResource
		 */	
		public static const onUnregisterResourceEVENT : String = "onUnregisterResource";
		
		
		//--------------------------------------------------------------------
		// Protected properties
		//--------------------------------------------------------------------
		
		/** @private */		
		protected var _sID : String;
		
		/** @private */		
		protected var _oResource : Resource;
		
		
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
		
		/**
		 * Creates a new <code>ResourceEvent</code> object.
		 * 
		 * @param	type		Name of the event type
		 * @param	id			Registration ID
		 * @param	resource	Resource object carried by this event
		 */	
		public function ResourceEvent( type : String, id : String, resource : Resource = null ) 
		{
			super( type );

			_sID = id;
			_oResource = resource;
		}
		
		/**
		 * Returns resource ID.
		 */
		public function getExpertID() : String
		{
			return _sID;
		}
		
		/**
		 * Returns the resource object carried by this event.
		 * 
		 * @return	The resource value carried by this event.
		 */
		public function getResource() : Resource
		{
			return _oResource;
		}
	}
}