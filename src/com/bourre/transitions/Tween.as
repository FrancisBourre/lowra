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
	 * <code>@code ITween</code> defines basic rules for all tween implementations.
	 * 
	 * <p>Take a look at <code>BasicTweenFPS</code>, <code>BasicTweenMS</code>, 
	 * <code>TweenFPS</code> and <code>TweenMS</code> for implementation.
	 * 
	 * @author Francis Bourre
	 * @author Cédric Néhémie
	 * @version 1.0
	 */
	public interface Tween extends BasicTween
	{
		/**
		 * Adds listener for receiving all events.
		 * 
		 * @param oL Listener object which implements {@link TweenListener} interface.
		 */
		function addListener( listener : TweenListener ) : Boolean;
		
		/**
		 * Removes listener for receiving all events.
		 * 
		 * @param oL Listener object which implements {@link TweenListener} interface.
		 */
		function removeListener( listener : TweenListener ) : Boolean;
		
		/**
		 * Adds listener for specifical event.
		 * 
		 * @param e Name of the Event.
		 * @param oL Listener object.
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