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
 
package com.bourre.ioc.assembler.constructor
{
	
	import com.bourre.events.BasicEvent;				
	
	/**
	 * The ConstructorEvent class represents the event object passed 
	 * to the event listener for <strong>ConstructorExpert</strong> events.
	 * 
	 * @author Francis Bourre
	 * 
	 * @see ConstructorExpert
	 */
	public class ConstructorEvent extends BasicEvent
	{
		//--------------------------------------------------------------------
		// Events
		//--------------------------------------------------------------------
		
		/**
		 * Defines the value of the <code>type</code> property of the event 
		 * object for a <code>onRegisterConstructor</code> event.
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
	     *     	</td><td>The constructor ID</td>
	     *     </tr>
	     *     <tr>
	     *     	<td><code>getConstructor()</code>
	     *     	</td><td>The constructor object</td>
	     *     </tr>
	     * </table>
	     *  
		 * @eventType onRegisterConstructor
		 */			
		public static const onRegisterConstructorEVENT : String = "onRegisterConstructor";		
		/**
		 * Defines the value of the <code>type</code> property of the event 
		 * object for a <code>onUnregisterConstructor</code> event.
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
	     *     	</td><td>The constructor ID</td>
	     *     </tr>
	     *     <tr>
	     *     	<td><code>getConstructor()</code>
	     *     	</td><td>The constructor object</td>
	     *     </tr>
	     * </table>
	     * 
		 * @eventType onUnregisterConstructor
		 */	
		public static const onUnregisterConstructorEVENT : String = "onUnregisterConstructor";
		
		
		//--------------------------------------------------------------------
		// Protected properties
		//--------------------------------------------------------------------
		
		/** @private */		
		protected var _sID : String;
		
		/** @private */		
		protected var _oConstructor : Constructor;
		
		
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
		
		/**
		 * Creates a new <code>ConstructorEvent</code> object.
		 * 
		 * @param	type		Name of the event type
		 * @param	id			Registration ID
		 * @param	constructor	Constructor object carried by this event
		 */	
		public function ConstructorEvent( type : String, id : String, constructor : Constructor = null ) 
		{
			super( type );

			_sID = id;
			_oConstructor = constructor;
		}
		
		/**
		 * Returns constructor ID.
		 */
		public function getExpertID() : String
		{
			return _sID;
		}
		
		/**
		 * Returns the constructor object carried by this event.
		 * 
		 * @return	The constructor value carried by this event.
		 */
		public function getConstructor() : Constructor
		{
			return _oConstructor;
		}
	}
}