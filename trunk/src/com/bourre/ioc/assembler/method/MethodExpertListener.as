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
	 
package com.bourre.ioc.assembler.method
{
	import com.bourre.ioc.assembler.method.MethodEvent;				
	
	/**
	 * The MethodExpertListener interface defines rules for 
	 * method listeners.
	 * 
	 * @see Method
	 * @see MethodExpert
	 * 
	 * @author Francis Bourre
	 */
	public interface MethodExpertListener
	{
		/**
		 *  Dispatched when a method is registered.
		 */
		function onRegisterMethod( e : MethodEvent ) : void;		
		/**
		 *  Dispatched when a method is unregistered.
		 */
		function onUnregisterMethod( e : MethodEvent ) : void;
	}
}