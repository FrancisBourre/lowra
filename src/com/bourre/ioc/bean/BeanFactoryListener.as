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
package com.bourre.ioc.bean
{
	/**
	 * All bean factory listeners must implement this iterface.
	 * 
	 * @see BeanFactory
	 * 
	 * @author Francis Bourre
	 */
	public interface BeanFactoryListener
	{
		/**
		 * Triggered when a new object is registered into the 
		 * Bean factory.
		 * 
		 * @param	e	BeanEvent event containing ID and value of 
		 * 				registered object
		 */
		function onRegisterBean		( e : BeanEvent ) : void;
		
		/**
		 * Triggered when a object is unregistered from the 
		 * Bean factory.
		 * 
		 * @param	e	BeanEvent event containing ID and value of 
		 * 				unregistered object
		 */
		function onUnregisterBean	( e : BeanEvent ) : void;
	}
}