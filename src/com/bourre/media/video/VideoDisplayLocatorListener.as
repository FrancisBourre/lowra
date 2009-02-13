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
	/**
	 * The VideoDisplayLocatorListener interface defines rules for 
	 * <code>VideoDisplayLocator</code> listeners.
	 * 
	 * @author 	Aigret Axel
	 * 
	 * @see VideoDisplay
	 * @see VideoDisplayLocator
	 * @see VideoDisplayLocatorEvent
	 */
	public interface VideoDisplayLocatorListener
	{
		/**
		 *  Dispatched when VideoDisplay object is registered in 
		 *  <code>VideoDisplayLocator</code> locator.
		 *  
		 *  @eventType com.bourre.media.video.VideoDisplayLocatorEvent.onRegisterVideoDisplayEVENT
		 */
		function onRegisterVideo( e : VideoDisplayLocatorListener ) : void;
		
		/**
		 *  Dispatched when VideoDisplay object is unregistered from 
		 *  <code>VideoDisplayLocator</code> locator.
		 *  
		 *  @eventType com.bourre.media.video.VideoDisplayLocatorEvent.onUnregisterVideoDisplayEVENT
		 */
		function onUnregisterVideo( e : VideoDisplayLocatorListener ) : void;
	}
}