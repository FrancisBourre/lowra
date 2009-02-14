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
	import com.bourre.load.LoaderEvent;
	import com.bourre.remoting.RemotingCall;	

	/**
	 * The RemotingCallEvent class represents the event object passed 
	 * to the event listener for <strong>RemotingCall</strong> events.
	 * 
	 * @see com.bourre.remoting.RemotingCall
	 * 
	 * @author Romain Flacher
	 */
	public class RemotingCallEvent extends LoaderEvent
	{
		//--------------------------------------------------------------------
		// Events
		//--------------------------------------------------------------------
		
		/**
		 * Defines the value of the <code>type</code> property of the event 
		 * object for a <code>onLoadInit</code> event.
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
	     *     	<td><code>getLib()</code>
	     *     	</td><td>The RemotingCall object</td>
	     *     </tr>
	     *     <tr>
	     *     	<td><code>getResult()</code>
	     *     	</td><td>The remoting call result</td>
	     *     </tr>
	     * </table>
	     * 
		 * @eventType onLoadInit
		 */
		public static var onLoadInitEVENT : String = LoaderEvent.onLoadInitEVENT;
		
		/**
		 * Defines the value of the <code>type</code> property of the event 
		 * object for a <code>onLoadError</code> event.
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
	     *     	<td><code>getLib()</code>
	     *     	</td><td>The RemotingCall object</td>
	     *     </tr>
	     * </table>
	     * 
		 * @eventType onLoadError
		 */
		public static var onLoadErrorEVENT : String = LoaderEvent.onLoadErrorEVENT;
		
		
		//--------------------------------------------------------------------
		// Private properties
		//--------------------------------------------------------------------
				
		private var _oResult : Object;
		
		
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
		
		/**
		 * Creates new <code>RemotingCallEvent</code> instance.
		 * 
		 * @param	e		Event type
		 * @param	oLib	RemotingCall instance
		 * @param	result	Remoting call result
		 */
		public function RemotingCallEvent( e : String, oLib : RemotingCall, result : Object = null)
		{
			super( e, oLib );
			
			_oResult = result;
		}
		
		/**
		 * Returns the RemotingCall object carried by this event.
		 * 
		 * @return	The RemotingCall object carried by this event.
		 */
		public function getLib() : RemotingCall
		{
			return _loader as RemotingCall;
		}
		
		/**
		 * Returns the Remoting call result carried by this event.
		 * 
		 * @return	The Remoting call result carried by this event.
		 */
		public function getResult() : Object
		{
			return _oResult;
		}
	}
}
