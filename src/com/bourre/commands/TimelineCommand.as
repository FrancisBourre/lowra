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
	 * <code>TimelineCommand</code> defines rules for suspendable process which
	 * may evolve in time. The biggest difference between <code>ASyncCommand</code>
	 * and timeline commands is the fact that an asynchronous command is more
	 * suitable for unsuspendable operation, such loading or remote request when
	 * timeline commands are more suitable for suspendable operation, such playing
	 * animation, video, sound and music, or tweens. Implementers should consider
	 * the possibility for the user of the class to suspend or not the operation, 
	 * if the operation could be suspended, the implementer should create a timeline
	 * command instead of an asynchronous command.
	 * <p>
	 * Suspendable doesn't mean cancelable, more formally, an operation is suspendable
	 * if and only if the operation could be paused and resumed without breaking the
	 * state of the process. For example, a loading process could be stopped, but
	 * it couldn't be suspended, when a file loading is canceled there's no possibility
	 * to restart it at the point it was stopped.
	 * </p><p>
	 * Implementing the <code>TimelineCommand</code> doesn't require anything regarding
	 * the time outflow approach. The only requirements concerned the suspendable nature
	 * of the process.
	 * </p>
	 * @author 	Cédric Néhémie
	 * @see		ASyncCommand
	 */
	public interface TimelineCommand extends ASyncCommand 
	{
		/**
		 * Starts the operation of this timeline command.
		 * If a call to the <code>start</code> method is done
		 * while the command is playing, concret class must
		 * ignore it. 
		 */
		function start() : void;
		
		/**
		 * Stops the operation in process. If a call to the
		 * <code>stop</code> method is done whereas this command
		 * is already stopped, concret class must ignore it.
		 */
		function stop() : void;
		
		/**
		 * Returns <code>true</code> if this command is currently
		 * processing its operation, either the function returns
		 * <code>false</code>.
		 * 
		 * @return	<code>true</code> if this command is currently
		 * 			processing its operation, either <code>false</code>
		 */
		function isPlaying () : Boolean;
	}
}
