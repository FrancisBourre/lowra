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
	 * The ServiceListener interface defines rules for 
	 * <code>Service</code> listeners.
	 * 
	 * @author 	Francis Bourre
	 * 
	 * @see Service
	 * @see ServiceEvent
	 */	public interface ServiceListener 
	{
		/**
		 *  Dispatched when a result is available.
		 *  
		 *  @eventType com.bourre.service.ServiceEvent.onDataResultEVENT
		 */
		function onDataResult( event : ServiceEvent ) : void;
		
		/**
		 *  Dispatched when an error occurs.
		 *  
		 *  @eventType com.bourre.service.ServiceEvent.onDataErrorEVENT
		 */
		function onDataError( event : ServiceEvent ) : void;	}}