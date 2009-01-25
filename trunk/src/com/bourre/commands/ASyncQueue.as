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
	import com.bourre.commands.ASyncBatch;
	
	import flash.events.Event;	

	/**
	 * An asynchronous queue behave as the asynchronous batch, but use
	 * the event dispatch by a sub-command to pass it in the execute method
	 * of the next sub-command.
	 * <p>
	 * The <code>ASyncBatch</code> class extends <code>AbstractSyncCommand</code>
	 * and so, dispatch an <code>onCommandEnd</code> event at the execution end
	 * of all commands. The event dispatched with the <code>onCommandEnd</code>
	 * event is the one dispatched by the last sub-command.
	 * </p> 
	 * 
	 * @author Cédric Néhémie
	 */
	public class ASyncQueue extends ASyncBatch 
	{
		/**
		 * Creates a new asynchronous queue object.
		 */
		public function ASyncQueue ()
		{
			super( );
		}
		
		/**
		 * Receives event of the last executed command and start the
		 * next one with the event object received in this call.
		 */
		override public function onCommandEnd ( e : Event ) : void
		{
			if( _hasNext() )
			{
				_next().execute( e );
			}
			else
			{
				_bIsRunning = false;
				_oEB.dispatchEvent( e );
			}
		}
	}
}
