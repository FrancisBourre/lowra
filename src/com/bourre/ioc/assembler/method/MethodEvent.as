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
package com.bourre.ioc.assembler.method
{
	import com.bourre.events.BasicEvent;
	import com.bourre.ioc.assembler.method.Method;	
	
	/**
	 * The MethodEvent class represents the event object passed 
	 * to the event listener for <strong>MethodExpert</strong> events.
	 * 
	 * @author Francis Bourre
	 * 
	 * @see MethodExpert
	 */
	public class MethodEvent extends BasicEvent
	{
		//--------------------------------------------------------------------
		// Events
		//--------------------------------------------------------------------
		
		/**
		 * Defines the value of the <code>type</code> property of the event 
		 * object for a <code>onRegisterMethod</code> event.
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
	     *     	</td><td>The method ID</td>
	     *     </tr>
	     *     <tr>
	     *     	<td><code>getMethod()</code>
	     *     	</td><td>The method object</td>
	     *     </tr>
	     * </table>
	     * 
		 * @eventType onRegisterMethod
		 */		
		public static const onRegisterMethodEVENT : String = "onRegisterMethod";
		
		/**
		 * Defines the value of the <code>type</code> property of the event 
		 * object for a <code>onUnregisterMethod</code> event.
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
	     *     	</td><td>The method ID</td>
	     *     </tr>
	     *     <tr>
	     *     	<td><code>getMethod()</code>
	     *     	</td><td>The method object</td>
	     *     </tr>
	     * </table>
	     * 
		 * @eventType onUnregisterMethod
		 */			public static const onUnregisterMethodEVENT : String = "onUnregisterMethod";
		

		//--------------------------------------------------------------------
		// Protected properties
		//--------------------------------------------------------------------
		
		/** @private */		
		protected var _sID : String;
		
		/** @private */
		protected var _oMethod : Method;
		
		
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
		
		/**
		 * Creates a new <code>MethodEvent</code> object.
		 * 
		 * @param	type	Name of the event type
		 * @param	id		Registration ID
		 * @param	method	Method object carried by this event
		 */	
		public function MethodEvent( type : String, id : String, method : Method = null )
		{
			super( type );

			_sID = id;
			_oMethod = method;
		}
		
		/**
		 * Returns method ID.
		 */
		public function getExpertID() : String
		{
			return _sID;
		}
		
		/**
		 * Returns the method object carried by this event.
		 * 
		 * @return	The method value carried by this event.
		 */
		public function getMethod() : Method
		{
			return _oMethod;
		}
	}
}