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
	 * The BasicResultEvent class represents the event object passed 
	 * to the event listener for <strong>ServiceResponder</strong> events.
	 * 
	 * @see com.bourre.remoting.ServiceResponder
	 * 
	 * @author Romain Flacher
	 * @author Axel Aigret
	 */
	public class BasicResultEvent extends BasicEvent 
	{
		/**
		 * Defines the value of the <code>type</code> property of the event 
		 * object for a <code>onResult</code> event.
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
		 *     	<td><code>getResult()</code>
		 *     	</td><td>The service call result</td>
		 *     </tr>
		 * </table>
		 * 
		 * @eventType onResult
		 */	
		public static const onResultEVENT : String = "onResult";

		private var _oResult : *;
		private var _oServiceMethod : ServiceMethod;
		
		/**
		 * Creates new <code>BasicResultEvent</code> instance.
		 * 
		 * @param	result	Service call result
		 * @param	methodName	Service method which has been called
		 */
		public function BasicResultEvent(  result : *, methodName : ServiceMethod ) 
		{
			super( BasicResultEvent.onResultEVENT );
			
			_oResult = result;
			_oServiceMethod = methodName;
		}
		
		/**
		 * Returns service call result.
		 * 
		 * @return The service call result
		 */
		public function getResult() : *
		{
			return _oResult;
		}
		
		// TODO: know which type of function name we want for callback of methodcallby service
		// we can use onResult + functionname onResultlogin onResultgetListName / or on + functionname
		public function redirectType() : void
		{
			if (_oServiceMethod is ServiceMethod) setType( _oServiceMethod.toString( ) );
		}
		
		/**
		 * Returns service methosd name carried by this event.
		 * 
		 * @return The service methosd name carried by this event.
		 */
		public function getServiceMethode() : ServiceMethod
		{
			return _oServiceMethod;
		}
	}
}
