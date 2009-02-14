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
	import com.bourre.collection.Collection;
	import com.bourre.commands.ASyncCommand;	

	/**
	 * The Service interface defines rules for remoting service.
	 * 
	 * @author 	Francis Bourre
	 */
	public interface Service extends ASyncCommand
	{
		/**
		 * @private
		 */
		function setResult( result : Object ) : void;
		
		/**
		 * Returns the service treatment result.
		 * 
		 * @return The service treatment result.
		 */
		function getResult() : Object;
		
		/**
		 * @copy com.bourre.events.Broadcaster#addListener()
		 */
		function addServiceListener( listener : ServiceListener ) : Boolean;
		
		/**
		 * @copy com.bourre.events.Broadcaster#removeListener()
		 */
		function removeServiceListener( listener : ServiceListener ) : Boolean;
		
		/**
		 * @copy com.bourre.events.EventBroadcaster#getListenerCollection()
		 */
		function getServiceListener() : Collection;
		
		/**
		 * Defines arguments to use for this service.
		 * 
		 * @param	...	argument list
		 */
		function setArguments( ... rest ) : void;
		
		/**
		 * Returns arguments used by this service.
		 * 
		 * @return arguments used by this service.
		 */
		function getArguments() : Object;
		
		/**
		 * Dispatches event to tell listeners that a result is 
		 * available. 
		 */
		function fireResult() : void;
		
		/**
		 * Dispatches an  error event to tell listeners that an error 
		 * occurs. 
		 */
		function fireError() : void;
		
		/**
		 * Releases service.
		 * 
		 * <p>Event broadcaster, service arguments and result are released.</p>
		 */
		function release() : void;

		/**
		 * @copy com.bourre.events.Broadcaster#addEventListener()
		 */
		function addEventListener( type : String, listener : Object, ... rest ) : Boolean;
		
		/**
		 * @copy com.bourre.events.Broadcaster#removeListener()
		 */
		function removeEventListener( type : String, listener : Object ) : Boolean;
	}}