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
 
package com.bourre.ioc.context.processor 
{

	/**
	 * IoC context pre processor must implements this interface.
	 * 
	 * <p>Processor allow to tranform xml context data on fly when 
	 * xml is loaded.<br />
	 * Pre processing is done before context parsing.</p>
	 * 
	 * @author Romain Ecarnot
	 */
	public interface ContextProcessor 
	{
		/**
		 * Transforms passed-in xml content using conrete 
		 * implementation in this method.
		 * 
		 * @param	xml	Original xml content
		 * 
		 * @return	The new xml content
		 */
		function process( xml : XML ) : XML;
	}
}
