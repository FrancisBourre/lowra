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
package com.bourre.transitions 
{
	import com.bourre.events.BasicEvent;
	import com.bourre.log.PixlibStringifier; 

	/**
	 * <code>TweenEvent</code> defines event model for Tween API.
	 * 
	 * <p>
	 * <code>TweenEvent</code> events are broadcasted by <code>Tween</code>
	 * instances. 
	 * </p>
	 * 
	 * @author Francis Bourre
	 */
	public class TweenEvent extends BasicEvent
	{
		//--------------------------------------------------------------------
		// Events
		//--------------------------------------------------------------------
				
		/**
		 * Defines the value of the <code>type</code> property of the event 
		 * object for a <code>onStart</code> event.
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
	     *     	<td><code>getTween()</code>
	     *     	</td><td>The current Tween carried by event</td>
	     *     </tr>
	     * </table>
	     *  
		 * @eventType onStart
		 */		
		public static const onStartEVENT : String = "onStart";

		/**
		 * Defines the value of the <code>type</code> property of the event 
		 * object for a <code>onStop</code> event.
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
	     *     	<td><code>getTween()</code>
	     *     	</td><td>The current Tween carried by event</td>
	     *     </tr>
	     * </table>
	     *  
		 * @eventType onStop
		 */	
		public static const onStopEVENT : String = "onStop";

		/**
		 * Defines the value of the <code>type</code> property of the event 
		 * object for a <code>onMotionFinished</code> event.
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
	     *     	<td><code>getTween()</code>
	     *     	</td><td>The current Tween carried by event</td>
	     *     </tr>
	     * </table>
	     *  
		 * @eventType onMotionFinished
		 */	
		public static const onMotionFinishedEVENT : String = "onMotionFinished";

		/**
		 * Defines the value of the <code>type</code> property of the event 
		 * object for a <code>onMotionChanged</code> event.
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
	     *     	<td><code>getTween()</code>
	     *     	</td><td>The current Tween carried by event</td>
	     *     </tr>
	     * </table>
	     *  
		 * @eventType onMotionChanged
		 */	
		public static const onMotionChangedEVENT : String = "onMotionChanged";
		
		
		//-------------------------------------------------------------------------
		// Private properties
		//-------------------------------------------------------------------------

		private var _oTween : AdvancedTween;

		//-------------------------------------------------------------------------
		// Public API
		//-------------------------------------------------------------------------
		
		/**
		 * Constructs a new <code>TweenEvent</code> instance broadcasted by <code>Tween</code> 
		 * family classes.
		 * 
		 * @example
		 * <pre class="prettyprint">
		 *   var e:TweenEvent = new TweenEvent( TweenEvent.onMotionFinishedEVENT, this );
		 * </pre>
		 * 
		 * @param	e		name of the event type.
		 * @param	tween 	<code>Tween</code> instance which trigger the event.
		 */
		public function TweenEvent( e : String, tween : AdvancedTween )
		{
			super( e );
			_oTween = tween;
		}

		/**
		 * Returns <code>Tween</code> event source.
		 * 
		 * @example 
		 * <pre class="prettyprint">
		 *   var t:TweenMS = e.getTween();
		 * </pre>
		 * 
		 * @return <code>Tween</code> instance
		 */
		public function getTween() : AdvancedTween
		{
			return _oTween;
		}

		/**
		 * Returns the string representation of this instance.
		 * <p>
		 * <code>com.bourre.events.BasciEvent#toString</code> overridding
		 * </p>
		 * @return <code>String</code> representation of this instance
		 */
		public override function toString() : String
		{
			return PixlibStringifier.stringify( this ) + type + ', ' + getTween( );
		}
	}
}