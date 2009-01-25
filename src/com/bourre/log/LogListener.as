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
package com.bourre.log 
{
	/**
	 * The LogListener must be implemented by all objects which want to listen 
	 * to Logging API events, like logging console.
	 * 
	 * @see	com.bourre.utils.AirLoggerLayout
	 * @see com.bourre.utils.SOSLayout
	 * @see com.bourre.utils.FlashInspectorLayout
	 * @see com.bourre.utils.FirebugLayout
	 * 
	 * @author Francis Bourre
	 */
	public interface LogListener 
	{
		/**
		 * Triggered when a Log event is broadcasted by the Logging API.
		 * 
		 * @param	e	LogEvent event
		 * 
		 * @see	Logger	
		 */
		function onLog( e : LogEvent ) : void;
	}
}