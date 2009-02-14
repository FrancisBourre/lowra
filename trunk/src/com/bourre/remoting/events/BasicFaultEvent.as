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
 
package com.bourre.remoting.events 
{
	import com.bourre.events.BasicEvent;
	import com.bourre.remoting.ServiceMethod;		

	/**
	 * The BasicFaultEvent class represents the event object passed 
	 * to the event listener for <strong>ServiceResponder</strong> events.
	 * 
	 * @see com.bourre.remoting.ServiceResponder
	 * 
	 * @author Romain Flacher
	 * @author Axel Aigret
	 */
	public class BasicFaultEvent extends BasicEvent 
	{
		//--------------------------------------------------------------------
		// Events
		//--------------------------------------------------------------------
				
		/**
		 * Defines the value of the <code>type</code> property of the event 
		 * object for a <code>onFault</code> event.
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
		 *     	<td><code>getCode()</code>
		 *     	</td><td>The error code</td>
		 *     </tr>
		 *     <tr>
		 *     	<td><code>getDescription()</code>
		 *     	</td><td>The error description</td>
		 *     </tr>
		 *       <tr>
		 *     	<td><code>getServiceMethodName()</code>
		 *     	</td><td>The service method name which dispatch this event</td>
		 *     </tr>
		 * </table>
		 * 
		 * @eventType onFault
		 */	
		public static var onFaultEVENT : String = "onFault";

		
		//--------------------------------------------------------------------
		// Private properties
		//--------------------------------------------------------------------

		private var _sCode : String;
		private var _sCorrelationId : String;
		private var _sDetail : String;
		private var _sDescription : String;

		private var _sServiceMethodName : ServiceMethod;

		
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
				
		/**
		 * Creates new <code>BasicFaultEvent</code> instance.
		 * 
		 * @param	code
		 * @param	correlationId
		 * @param	details
		 * @param	description
		 * @param	sServiceMethodName
		 */
		public function BasicFaultEvent(code : String, 
										correlationId : String, 
										details : String, 
										description : String,
										sServiceMethodName : ServiceMethod ) 
		{
			super( BasicFaultEvent.onFaultEVENT );
			
			_sCode = code ;
			_sCorrelationId = correlationId ;
			_sDetail = details;
			_sDescription = description;
			_sServiceMethodName = sServiceMethodName;
		}
		
		/**
		 * Returns error code.
		 * 
		 * @return The error code carried by this event
		 */
		public function getCode() : String
		{
			return _sCode;
		}
		
		/**
		 * 
		 */
		public function getCorrelationId() : String
		{
			return _sCorrelationId;
		}
		
		/**
		 *
		 */
		public function getDetail() : String
		{
			return _sDetail;
		}
		
		/**
		 * Returns error description.
		 * 
		 * @return The error description carried by this event
		 */
		public function getDescription() : String
		{
			return _sDescription;
		}
		
		/**
		 * Returns service method name which dispatch this event.
		 * 
		 * @return The service method name which dispatch this event
		 */
		public function getServiceMethodName() : ServiceMethod
		{
			return _sServiceMethodName;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function toString() : String 
		{
			return "BasicFaultEvent code: " + getCode( ) + "id: " + getCorrelationId( ) + "detail" + getDetail( ) + "description" + getDescription( ) + "methodname" + getServiceMethodName( );
		}
	}
}
