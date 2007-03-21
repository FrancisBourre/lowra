package com.bourre.transitions 
{ 
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
	
	import com.bourre.events.BasicEvent;
	import com.bourre.log.PixlibStringifier;
	
	/**
	 * <code>TweenEvent</code> defines event model for Tween API.
	 * 
	 * <p>Based on <code>com.bourre.events.BasicEvent</code> class.
	 * 
	 * <p>{@code TweenEvent} events are broadcasted by <code>Tween</code>
	 * instances. 
	 * 
	 * @author Francis Bourre
	 * @version 1.0
	 */
	
	public class TweenEvent extends BasicEvent
	{
		/**
		 * Broadcasted to listeners when tween starts.
		 */
		public static var onStartEVENT:String = "onStart";
		
		/**
		 * Broadcasted to listeners when tween stops.
		 */
		public static var onStopEVENT:String = "onStop";
		
		/**
		 * Broadcasted to listeners when tween is finished.
		 */
		public static var onMotionFinishedEVENT:String = "onMotionFinished";
		
		/**
		 * Broadcasted to listeners when property value is updated.
		 */
		public static var onMotionChangedEVENT:String = "onMotionChanged";
		
		//-------------------------------------------------------------------------
		// Private properties
		//-------------------------------------------------------------------------
		
		protected var _oTween:Tween;
		
		
		//-------------------------------------------------------------------------
		// Public API
		//-------------------------------------------------------------------------
		
		/**
		 * Constructs a new {@code TweenEvent} instance broadcasted by {@link Tween} 
		 * family classes.
		 * 
		 * <p>Example
		 * <code>
		 *   var e:TweenEvent = new TweenEvent(TweenFPS.onMotionFinished, this);
		 * </code>
		 * 
		 * @param e event type (event name).
		 * @param oTween event source ({@link Tween} instance).
		 */
		public function TweenEvent( e : String, oTween : Tween )
		{
			super(e);
			_oTween = oTween;
		}
		
		/**
		 * Returns {@link Tween} event source.
		 * 
		 * <p>Example
		 * <code>
		 *   var t:TweenMS = TweenMS( e.getType() );
		 * </code>
		 * 
		 * @return {@link Tween} instance
		 */
		public function getTween() : Tween
		{
			return _oTween;
		}
		
		/**
		 * Returns the string representation of this instance.
		 * 
		 * <p>{@link com.bourre.events.BasciEvent#toString} overridding
		 * 
		 * @return {@code String} representation of this instance
		 */
		public override function toString() : String
		{
			return PixlibStringifier.stringify( this ) + type + ', ' + getTween();
		}
	}
}