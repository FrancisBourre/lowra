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
	import flash.events.Event;		

	/**
	 * Extends <code>Batch</code> to process commands in the reversed order.
	 * 
	 * @author Francis Bourre
	 */
	public class ReversedBatch extends Batch
	{
		/**
		 * Executes the whole set of commands in the reversed order
		 * they were registered.
		 * <p>
		 * If an event is passed to the function, it will be relayed
		 * to the sub-commands <code>execute</code> method.
		 * </p>
		 * @param	e	event object to relay to the sub-commands.
		 */
		public override function execute( e : Event = null ) : void
		{
			var l : int = size( );
			while( --l > -1 ) _aCommands[ l ].execute( e ) ;
		}
	}
}