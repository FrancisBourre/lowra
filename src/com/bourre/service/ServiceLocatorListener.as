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
package com.bourre.service 
{

	/**
	 * The ServiceLocatorListener interface defines rules for 
	 * <code>ServiceLocatorEvent</code> listeners.
	 * 
	 * @author 	Francis Bourre
	 * 
	 * @see Service
	 * @see ServiceLocator
	 * @see ServiceLocatorEvent
	 */	public interface ServiceLocatorListener 
	{
		/**
		 *  Dispatched when a service is registered in 
		 *  <code>ServiceLocator</code> locator.
		 *  
		 *  @eventType com.bourre.service.ServiceLocatorEvent.onRegisterServiceEVENT
		 */
		function onRegisterService( e : ServiceLocatorEvent) : void;		
		/**
		 *  Dispatched when a service is unregistered from 
		 *  <code>ServiceLocator</code> locator.
		 *  
		 *  @eventType com.bourre.service.ServiceLocatorEvent.onUnregisterServiceEVENT
		 */
		function onUnregisterService( e : ServiceLocatorEvent ) : void;
	}}