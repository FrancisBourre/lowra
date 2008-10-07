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
	import com.bourre.events.LoopEvent;	

	/**
	 * Objects which want to listen to a <code>LoopCommand</code>
	 * instance have to implement the <code>LoopCommandListener</code>
	 * interface.
	 * 
	 * @author Cédric Néhémie
	 */
	public interface LoopCommandListener extends ASyncCommandListener 
	{
		/**
		 * Called when the loop command start or restart its process.
		 * 
		 * @param	e	event object dispatched by the loop command
		 */
		function onLoopStart( e : LoopEvent ) : void;		
		/**
		 * Called at each step performed by the loop. 
		 * 
		 * @param	e	event object dispatched by the loop command
		 */
		function onLoopProgress( e : LoopEvent ) : void;
		
		/**
		 * Called when the loop command stop its process.
		 * 
		 * @param	e	event object dispatched by the loop command
		 */
		function onLoopStop( e : LoopEvent ) : void;		
		/**
		 * Called at the end of the loop process.
		 * 
		 * @param	e	event object dispatched by the loop command
		 */
		function onLoopEnd( e : LoopEvent ) : void;		
		/**
		 * Called when the loop have been canceled due to a user
		 * input.
		 * 
		 * @param	e	event object dispatched by the loop command
		 */
		function onLoopCancel( e : LoopEvent ) : void;
	}
}
