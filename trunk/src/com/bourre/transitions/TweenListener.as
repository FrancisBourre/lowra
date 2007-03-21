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
package  com.bourre.transitions
{ 	
	/**
	 * {@code TweenListener} defines rules for tween listener.
	 * 
	 * <p>All instances which want to listen to {@link Tween} progression, 
	 * must implement {@code TweenListener} interface
	 * 
	 * <p>a {@link TweenEvent} is broadcasted throw event.
	 * 
	 * @author Francis Bourre
	 * @author Cédric Néhémie
	 * @version 1.0
	 * 
	 * @see com.bourre.transitions.TweenEvent
	 */
	import com.bourre.transitions.TweenEvent;
	import com.bourre.commands.ASyncCommandListener;
	
	public interface TweenListener extends ASyncCommandListener
	{
		/**
		 * Triggers when tween starts.
		 * 
		 * @param e {@link TweenEvent} instance
		 */
		function onStart( e : TweenEvent ) : void;
		
		/**
		 * Triggers when tween stops.
		 * 
		 * @param e {@link TweenEvent} instance
		 */
		function onStop( e : TweenEvent ) : void;
		
		/**
		 * Triggers when tween ends.
		 * 
		 * @param e {@link TweenEvent} instance
		 */
		function onMotionFinished( e : TweenEvent ) : void;
		
		/**
		 * Triggers when object property value is updated.
		 * 
		 * @param e {@link TweenEvent} instance
		 */
		function onMotionChanged( e : TweenEvent ) : void;
	}
}