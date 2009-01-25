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
	/**
	 * The TweenFPS class.
	 * 
	 * <p>TODO Documentation.</p>
	 * 
	 * @author 	Cédric Néhémie
	 */
	public class TweenFPS 
		extends AbstractTween
	{
		public function TweenFPS( 	target : Object,
									setter : String, 
									endValue : Number,
									duration : Number, 
									startValue : Number = NaN, 
									easing : Function = null, 
									getter : String = null )
		{
			super( target, setter, endValue, duration, startValue, easing, getter );
			_oBeacon = FPSBeacon.getInstance();
		}
		
		//-------------------------------------------------------------------------
		// VIRTUAL METHODS IMPLEMENTATION
		//-------------------------------------------------------------------------
		
		override public function isMotionFinished() : Boolean
		{
			return ++_nPlayHead >= _nDuration;
		}
		
		override public function isReversedMotionFinished () : Boolean
		{
			return --_nPlayHead <= 0;
		}
	}
}