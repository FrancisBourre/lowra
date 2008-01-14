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
	 * The <code>AdvancedTween</code> interface extends <code>Tween</code> and
	 * add the support for event dispatching.
	 * <p>
	 * The tween object invokes the <code>TweenEvent.onMotionChangedEVENT</code>
	 * event on a regular interval on the effect instance for the duration of
	 * the tween, passing to the <code>onMotionChanged</code> method the interpolated
	 * value between the startValue and endValue. Typically, the callback function
	 * updates some property of the target object, causing that object to animate
	 * over the duration of the effect.
	 * </p><p>
	 * When the effect ends, the tween objects invokes <code>TweenEvent.onMotionFinishedEVENT</code>
	 * event on its listeners, if you defined one.
	 * </p><p>
	 * Take a look at <a href='MultiTweenFPS.html'>MultiTweenFPS</code>, 
	 * <a href='MultiTweenMS.html'>MultiTweenMS</code>, <a href='TweenFPS.html'>TweenFPS</code> 
	 * and <a href='cTweenMS.html'>TweenMS</code> for concret implementations.
	 * </p>
	 * @author	Francis Bourre
	 * @author	Cédric Néhémie
	 */
	public interface AdvancedTween extends Tween
	{
		/**
		 * Adds the passed-in listener object as listener for
		 * all events dispatched by the tween. The object must
		 * implements the <code>TweenListener</code> interface.
		 * 
		 * @param	listener object to be added as listener.
		 */
		function addListener( listener : TweenListener ) : Boolean;
		
		/**
		 * Removes the passed-in listener from listening all events
		 * dispatched by this tween. 
		 * 
		 * @param	listener object to be removed as listener.
		 */
		function removeListener( listener : TweenListener ) : Boolean;
		
		/**
		 * Adds listener for specifical event.
		 * 
		 * @param	type name of the event type.
		 * @param	listener object to be added as listener.
		 */
		function addEventListener( type : String, listener : Object, ... rest ) : Boolean;
		
		/**
		 * Removes listener for specifical event.
		 * 
		 * @param e Name of the Event.
		 * @param oL Listener object.
		 */
		function removeEventListener( type : String, listener : Object ) : Boolean;
	}
}