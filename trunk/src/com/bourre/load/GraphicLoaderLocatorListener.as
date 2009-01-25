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
package com.bourre.load
{
	/**
	 * The GraphicLoaderLocatorListener interface defines rules for 
	 * <code>GraphicLoaderLocator</code> listeners.
	 * 
	 * @author 	Francis Bourre
	 * 
	 * @see GraphicLoader
	 * @see GraphicLoaderLocator	 * @see GraphicLoaderLocatorEvent
	 */
	public interface GraphicLoaderLocatorListener
	{
		/**
		 *  Dispatched when graphic loader is registered in 
		 *  <code>GraphicLoaderLocator</code> locator.
		 *  
		 *  @eventType com.bourre.load.GraphicLoaderLocatorEvent.onRegisterGraphicLoaderEVENT
		 */
		function onRegisterGraphicLoader	( e : GraphicLoaderLocatorEvent ) : void;
		
		/**
		 *  Dispatched when graphic loader is unregistered from 
		 *  <code>GraphicLoaderLocator</code> locator.
		 *  
		 *  @eventType com.bourre.load.GraphicLoaderLocatorEvent.onUnregisterGraphicLoaderEVENT
		 */
		function onUnregisterGraphicLoader	( e : GraphicLoaderLocatorEvent ) : void;
	}
}