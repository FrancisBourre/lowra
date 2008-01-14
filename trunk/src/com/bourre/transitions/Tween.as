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
	import com.bourre.commands.TimelineCommand;		

	/**
	 * The <code>Tween</code> interface defines a tween, a property animation
	 * performed on a target object over a period of time. That animation
	 * can be a change in position, a change in size, a change in visibility,
	 * or other types of animations.
	 * <p>
	 * When defining tween effects, you typically create an instance of
	 * a concret <code>Tween</code> class. A Tween instance accepts the
	 * startValue, endValue, and duration properties, and an optional
	 * easing function to define the animation.
	 * </p><p>
	 * Concret tweens doesn't specifically work on a special member type.
	 * A tween should work for both properties and methods of an object.
	 * See the <a href=''>Accessor</a> interface for a description of 
	 * members access.
	 * </p> 
	 * @author	Cédric Néhémie
	 * @see		com.bourre.code.Accessor
	 * @see		com.bourre.commands.TimelineCommand
	 */
	public interface Tween extends TimelineCommand
	{
		/**
		 * 
		 */
		function setEasing( f : Function ) : void;
	}
}