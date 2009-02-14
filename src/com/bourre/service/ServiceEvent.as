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
package com.bourre.service 
{
	import com.bourre.events.BasicEvent;	
	
	/**
	 * The ServiceEvent class represents the event object passed 
	 * to the event listener for <code>Service</code> events.
	 * 
	 * @author 	Francis Bourre
	 * 
	 * @see Service	 * @see AbstractService
	 */
	public class ServiceEvent extends BasicEvent
	{
		/**
		 * Defines the value of the <code>type</code> property of the event 
		 * object for a <code>onDataResult</code> event.
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
		 *     	<td><code>getService()</code>
		 *     	</td><td>The remoting service</td>
		 *     </tr>
		 * </table>
		 * 
		 * @eventType onDataResult
		 */	
		public static const onDataResultEVENT 	: String = "onDataResult";
		
		/**
		 * Defines the value of the <code>type</code> property of the event 
		 * object for a <code>onDataError</code> event.
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
		 *     	<td><code>getService()</code>
		 *     	</td><td>The remoting service</td>
		 *     </tr>
		 * </table>
		 * 
		 * @eventType onDataError
		 */	
		public static const onDataErrorEVENT 	: String = "onDataError";
		
		
		//--------------------------------------------------------------------
		// Private properties
		//--------------------------------------------------------------------
				
		private var _oService 	: Service;
		
		
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
		
		/**
		 * Creates new <code>ServiceEvent</code> instance.
		 * 
		 * @param	type	Event type
		 * @param	service	Service carried by this event.
		 */
		public function ServiceEvent( type : String , service : Service ) 
		{
			super( type, service );

			_oService = service;
		}
		
		/**
		 * Returns the Service object carried by this event.
		 * 
		 * @return The Service object carried by this event.
		 */
		public function getService() : Service
		{
			return _oService ;
		}
	}
}