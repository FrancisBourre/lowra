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
 
package com.bourre.ioc.assembler.channel
{
	
	import com.bourre.events.BasicEvent;			
	
	/**
	 * The ChannelListenerEvent class represents the event object passed 
	 * to the event listener for <strong>ChannelListenerExpert</strong> events.
	 * 
	 * @see ChannelListenerExpert
	 * 
	 * @author Francis Bourre
	 */
	public class ChannelListenerEvent  extends BasicEvent
	{
		//--------------------------------------------------------------------
		// Events
		//--------------------------------------------------------------------
		
		/**
		 * Defines the value of the <code>type</code> property of the event 
		 * object for a <code>onRegisterChannelListener</code> event.
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
	     *     	</td><td>The Channel listener ID</td>
	     *     </tr>
	     *     <tr>
	     *     	<td><code>getChannelListener()</code>
	     *     	</td><td>The Channel listener object</td>
	     *     </tr>
	     * </table>
	     * 
		 * @eventType onRegisterChannelListener
		 */	
		public static const onRegisterChannelListenerEVENT : String = "onRegisterChannelListener";		
		/**
		 * Defines the value of the <code>type</code> property of the event 
		 * object for a <code>onUnregisterChannelListener</code> event.
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
	     *     	</td><td>The Channel listener ID</td>
	     *     </tr>
	     *     <tr>
	     *     	<td><code>getChannelListener()</code>
	     *     	</td><td>The Channel listener object</td>
	     *     </tr>
	     * </table>
	     *  
		 * @eventType onUnregisterChannelListener
		 */	
		public static const onUnregisterChannelListenerEVENT : String = "onUnregisterChannelListener";
		
		
		//--------------------------------------------------------------------
		// Protected properties
		//--------------------------------------------------------------------
		
		/** @private */
		protected var _sID : String;
		
		/** @private */
		protected var _oChannelListener : ChannelListener;
		
		
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
		
		/**
		 * Creates a new <code>ChannelListenerEvent</code> object.
		 * 
		 * @param	type			Name of the event type
		 * @param	id				Registration ID
		 * @param	channelListener	Channel listener object carried by this event
		 */	
		public function ChannelListenerEvent( type : String, id : String, channelListener : ChannelListener = null )
		{
			super ( type );
			
			_sID = id;
			_oChannelListener = channelListener ;
		}
		
		/**
		 * Returns channel listener ID.
		 */
		public function getExpertID() : String
		{
			return _sID;
		}
		
		/**
		 * Returns the channel listener object carried by this event.
		 * 
		 * @return	The channel listener value carried by this event.
		 */
		public function getChannelListener() : ChannelListener
		{
			return _oChannelListener ;
		}
	}
}