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
package com.bourre.media.video
{	
	
	import flash.events.Event;	
	
	/**
	 * The VideoDisplayLocatorEvent class represents the event object passed 
	 * to the event listener for VideoDisplayLocator events.
	 * 
	 * @see VideoDisplayLocator
	 * 
	 * @author 	Aigret Axel
	 */
	public class VideoDisplayLocatorEvent extends Event 
	{
		/**
		 * Defines the value of the <code>type</code> property of the event 
		 * object for a <code>onRegisterVideoDisplay</code> event.
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
		 *     	<td><code>getName()</code>
		 *     	</td><td>The registration key</td>
		 *     </tr>
		 *     <tr>
		 *     	<td><code>getVideoDisplay()</code>
		 *     	</td><td>The VideoDisplay object</td>
		 *     </tr>
		 * </table>
		 * 
		 * @eventType onRegisterVideoDisplay
		 */	
		public static var onRegisterVideoDisplayEVENT : String = "onRegisterVideoDisplay";
		
		
		/**
		 * Defines the value of the <code>type</code> property of the event 
		 * object for a <code>onUnregisterVideoDisplay</code> event.
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
		 *     	<td><code>getName()</code>
		 *     	</td><td>The registration key</td>
		 *     </tr>
		 * </table>
		 * 
		 * @eventType onUnregisterVideoDisplay
		 */	
		public static var onUnregisterVideoDisplayEVENT : String = "onUnregisterVideoDisplay";
		
		
		/** @private */
		protected var _sName : String;
		
		/** @private */
		protected var _oVideo : VideoDisplay ;
		
		
		/**
		 * Creates new <code>VideoDisplayLocatorEvent</code> instance.
		 * 
		 * @param	type			Name of the event type
		 * @param	name			Registration key
		 * @param	videoDisplay	VideoDisplay object
		 */
		public function VideoDisplayLocatorEvent( type : String, name : String, videoDisplay : VideoDisplay )
		{
			super( type );
			
			_sName = name;
			_oVideo = videoDisplay ;
		}
		
		/**
		 * Returns the registration key carried by this event.
		 * 
		 * @return The registration key carried by this event.
		 */
		public function getName() : String
		{
			return _sName;
		}
		
		/**
		 * Returns the VideoDisplay object carried by this event.
		 * 
		 * @return The VideoDisplay object carried by this event.
		 */
		public function getVideoDisplay() : VideoDisplay
		{
			return _oVideo;
		}
	}
}