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
	 * The ServiceLocatorEvent class represents the event object passed 
	 * to the event listener for <strong>ServiceLocator</strong> events.
	 * 
	 * @author Francis Bourre
	 * 
	 * @see ServiceLocator
	 */
	public class ServiceLocatorEvent extends BasicEvent
	{
		//--------------------------------------------------------------------
		// Events
		//--------------------------------------------------------------------
		
		/**
		 * Defines the value of the <code>type</code> property of the event 
		 * object for a <code>onRegisterService</code> event.
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
		 *     	<td><code>getServiceLocator()</code>
		 *     	</td><td>The locator</td>
		 *     </tr>
		 *     <tr>
		 *     	<td><code>getService()</code>
		 *     	</td><td>The the service</td>
		 *     </tr>
		 * </table>
		 *  
		 * @eventType onRegisterService
		 */		
		public static const onRegisterServiceEVENT : String = "onRegisterService";

		/**
		 * Defines the value of the <code>type</code> property of the event 
		 * object for a <code>onUnregisterService</code> event.
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
		 *     	<td><code>getServiceLocator()</code>
		 *     	</td><td>The locator</td>
		 *     </tr>
		 *     <tr>
		 *     	<td><code>getService()</code>
		 *     	</td><td>The the service</td>
		 *     </tr>
		 * </table>
		 *  
		 * @eventType onUnregisterService
		 */				public static const onUnregisterServiceEVENT : String = "onUnregisterService";

		
		//--------------------------------------------------------------------
		// Protected properties
		//--------------------------------------------------------------------
		
		/** @private */		
		protected var _key : String;

		/** @private */		
		protected var _service : Service;

		/** @private */				protected var _serviceClass : Class;

		/** @private */		
		protected var _serviceLocator : ServiceLocator;

		
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
		
		/**
		 * Creates a new <code>ServiceLocatorEvent</code> object.
		 * 
		 * @param	type			Name of the event type
		 * @param	key				Registration ID
		 * @param	serviceLocator	ServiceLocator object carried by this event
		 */			
		public function ServiceLocatorEvent( type : String, key : String, serviceLocator : ServiceLocator ) 
		{
			super( type );
			
			_key = key;
			_serviceLocator = serviceLocator;
		}

		public function getKey() : String
		{
			return _key;
		}

		public function getService() : Service
		{
			return _service is Class ? null : _service as Service;
		}

		public function setService( service : Service ) : void
		{
			_service = service;
		}

		public function getServiceClass() : Class
		{
			return _service is Class ? _service as Class : null;
		}

		public function setServiceClass( serviceClass : Class ) : void
		{
			_serviceClass = serviceClass;
		}

		public function getServiceLocator() : ServiceLocator
		{
			return _serviceLocator as ServiceLocator;
		}	}}