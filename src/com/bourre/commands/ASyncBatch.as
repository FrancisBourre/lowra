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
	import com.bourre.commands.AbstractSyncCommand;
	import com.bourre.commands.MacroCommand;
	import com.bourre.plugin.Plugin;
	
	import flash.events.Event;	

	/**
	 * An asynchronous batch behave as a normal batch, but is designed to handle 
	 * asynchronous commands. A command executed by this batch could only start 
	 * when the previous command have fire its <code>onCommandEnd</code> event.
	 * <p>
	 * The <code>Event</code> object received in the <code>execute</code> is passed
	 * to each commands contained in this batch.
	 * </p><p>
	 * The <code>ASyncBatch</code> class extends <code>AbstractSyncCommand</code>
	 * and so, dispatch an <code>onCommandEnd</code> event at the execution end
	 * of all commands.
	 * </p> 
	 * 
	 * @author Cédric Néhémie
	 */
	public class ASyncBatch extends AbstractSyncCommand implements MacroCommand, ASyncCommandListener
	{
		/**
		 * Contains all commands currently in this macro command
		 */
		protected var _aCommands : Array;
		/**
		 * Store the index of the currently executed command.
		 */
		protected var _nIndex : Number;
		
		/**
		 * Event received by the batch and redispatched to 
		 * the internal commands execute method.
		 */
		protected var _eEvent : Event;
		/**
		 * Last executed command
		 */
		protected var _oLastCommand : ASyncCommand;
		
		/**
		 * Creates a new asynchronous batch object.
		 */
		public function ASyncBatch ()
		{
			_aCommands = new Array();
		}		
		/**
		 * @inheritDoc
		 */
		override public function setOwner ( owner : Plugin ) : void
		{
			super.setOwner( owner );
			
			var l : Number = _aCommands.length;
			var c : AbstractCommand;
			while( --l -(-1 ) )
			{
				if( ( c = _aCommands[ l ]  as AbstractCommand ) != null )
					c.setOwner( owner );
			}
		}
		/**
		 * @inheritDoc
		 */
		public function addCommand (command : Command) : Boolean
		{
			if( command == null ) return false;
			
			if( command is AbstractCommand )
				( command as AbstractCommand).setOwner( getOwner() );
				
			var l : Number = _aCommands.length;
			return (l != _aCommands.push( command ) );
		}
		/**
		 * @inheritDoc
		 */
		public function removeCommand (command : Command) : Boolean
		{
			var id : Number = _aCommands.indexOf( command ); 

			if ( id == -1 ) return false;
			
			while ( ( id = _aCommands.indexOf( command ) ) != -1 )
			{
				_aCommands.splice( id, 1 );
			}
			return true;
		}
		/**
		 * Starts the execution of the batch. The received event 
		 * is registered and then passed to sub commands.
		 */
		override public function execute (e : Event = null) : void
		{
			_eEvent = e;
			_nIndex = -1;
			_bIsRunning = true;
			
			if( _hasNext() )
				_next().execute( _eEvent );
		}
		/**
		 * Receive events from its internal asynchronous commands.
		 */
		public function onCommandEnd ( e : Event ) : void
		{
			if( _hasNext() )
			{
				_next().execute( _eEvent );
			}
			else
			{
				_bIsRunning = false;
				fireCommandEndEvent();
			}
		}
		
		/**
		 * Returns the next command to execute.
		 * 
		 * @return 	the next command to execute
		 */
		protected function _next () : ASyncCommand
		{
			if( _oLastCommand )
				_oLastCommand.removeASyncCommandListener( this );
			
			_oLastCommand = _aCommands.shift( ) as ASyncCommand;
			
			_oLastCommand.addASyncCommandListener( this );
			
			return _oLastCommand;
		}
		/**
		 * Returns <code>true</code> if there is a command
		 * to execute.
		 * 
		 * @return	<code>true</code> if there is a command
		 * 			to execute
		 */
		protected function _hasNext () : Boolean
		{
			return _nIndex + 1 < _aCommands.length;
		}
	}
}
