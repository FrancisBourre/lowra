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
package com.bourre.ioc.assembler.resource
{

	/**
	 * The ResourceExpertListener interface defines rules for 
	 * resource listeners.
	 * 
	 * @author Romain Ecarnot
	 * 
	 * @see Resource
	 * @see ResourceExpert
	 */
	public interface ResourceExpertListener
	{
		/**
		 *  Dispatched when a resource is registered.
		 */
		function onRegisterResource( e : ResourceEvent ) : void;
		
		/**
		 *  Dispatched when a resource is unregistered.
		 */
		function onUnregisterResource( e : ResourceEvent ) : void;
	}
}