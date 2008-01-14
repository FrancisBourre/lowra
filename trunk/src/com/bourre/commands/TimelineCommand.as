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
package com.bourre.commands 
{
	import com.bourre.commands.ASyncCommand;
	
	/**
	 * <code>TimelineCommand</code> defines rules for objects which
	 * evolve in time. The biggest difference between <code>ASyncCommand</code>
	 * and timeline commands is the fact that an asynchronous command are more
	 * suited for unsuspendable operation, such loading or remote request. 
	 * 
	 * @author Cédric Néhémie
	 */
	public interface TimelineCommand extends ASyncCommand 
	{
		/**
		 * 
		 */
		function start() : void;
		
		/**
		 * 
		 */
		function stop() : void;
		
		/**
		 * 
		 */
		function pause () : void;
		
		/**
		 * 
		 */
		function resume () : void;
		
		/**
		 * 
		 */
		function isPlaying () : void;
	}
}
