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
	 
package com.bourre.ioc.bean
{
	import com.bourre.events.BasicEvent;	
	
	/**
	 * The BeanEvent class represents the event object passed 
	 * to the event listener for <strong>BeanFactory</strong> events.
	 * 
	 * @see BeanFactory
	 * 
	 * @author Francis Bourre
	 */
	public class BeanEvent extends BasicEvent
	{
		//--------------------------------------------------------------------
		// Events
		//--------------------------------------------------------------------
		
		/**
		 * Defines the value of the <code>type</code> property of the event 
		 * object for a <code>onRegisterBean</code> event.
		 * 
		 * @eventType onRegisterBean
		 */		
		public static const onRegisterBeanEVENT : String = "onRegisterBean" ;

		/**
		 * Defines the value of the <code>type</code> property of the event 
		 * object for a <code>onUnregisterBean</code> event.
		 * 
		 * @eventType onUnregisterBean
		 */		
		public static const onUnregisterBeanEVENT : String = "onUnregisterBean" ;
		
		
		//--------------------------------------------------------------------
		// Private properties
		//--------------------------------------------------------------------
				
		private var _sID : String;
		private var _oBean : Object;
		
		
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
		
		/**
		 * Creates instance.
		 */		
		public function BeanEvent( type : String, id : String, bean : Object )
		{
			super( type, bean );
			_sID = id;
			_oBean = bean;
		}
		
		/**
		 * Returns bean object ID.
		 */
		public function getID() : String
		{
			return _sID ;
		}
		
		/**
		 * Returns bean object value.
		 */
		public function getBean() : Object
		{
			return _oBean ;
		}
	}
}