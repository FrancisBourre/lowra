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
	import com.bourre.events.BasicEvent;
	import com.bourre.events.EventBroadcaster;
	import com.bourre.log.PixlibStringifier;
	
	import flash.events.Event;	

	/**
	 * <code>AbstractSyncCommand</code> provides a skeleton to create
	 * asynchronous stateless commands. As defined in the 
	 * <code>ASyncCommand</code> interface, an asynchronous command
	 * hasn't finished its process at the end of the <code>execute</code>
	 * call. In that context, the command will dispatch an <code>onCommandEnd</code>
	 * event to notice its listener of the end of its process.
	 * <p>
	 * LowRA encourage the creation of stateless commands, it means
	 * that commands must realize all their process entirely in
	 * the <code>execute</code> call. The constructor of a stateless
	 * command should always be empty. In the case of an asynchronous
	 * command, the constructor initialize essentials properties which
	 * allow command owner to setup the command properly, and to register
	 * its <code>FrontController</code> to the command.
	 * </p><p>
	 * See the <a href="../../../howto/howto-commands.html">How to use
	 * the Command pattern implementation in LowRA</a> document for more details
	 * on the commands package structure.
	 * </p>
	 * 
	 * @author Cédric Néhémie
	 */
	public class AbstractSyncCommand extends AbstractCommand implements ASyncCommand
	{	
		/**
		 * Name of the event dispatched at the end of the command's process.
		 */
		static public const onCommandEndEVENT : String = "onCommandEnd";
		
		/**
		 * The internal event broadcaster.
		 */
		protected var _oEB : EventBroadcaster;
		
		/**
		 * An event instance used as event object when dispatching
		 * the <code>onCommandEnd</code> event to its listener.
		 */
		protected var _eOnCommandEnd : BasicEvent;
		
		/**
		 * A boolean value which indicates if this command is currently
		 * processing.
		 */
		protected var _bIsRunning : Boolean;
		
		/**
		 * Initializes event dispatching behavior and <code>Runnable</code>
		 * implementation
		 */
		public function AbstractSyncCommand ()
		{
			_bIsRunning = false;
			_oEB = new EventBroadcaster ( this );
			_eOnCommandEnd = new BasicEvent ( onCommandEndEVENT, this );
		}
		
		/**
		 * Adds the passed-in listener as listener for the <code>onCommandEnd</code>
		 * event of this command.
		 * 
		 * @param	listener	object to be added as listener
		 * @param	rest		additional arguments such defined by the
		 * 						<code>EventBroacaster.addEventListener</code> method
		 * @see		com.bourre.events.EventBroacaster#addEventListener() See the
		 * 			EventBroacaster.addEventListener() documentation
		 */
		public function addASyncCommandListener( listener : ASyncCommandListener, ... rest ) : Boolean
		{
			return _oEB.addEventListener.apply( _oEB, rest.length > 0 ? 
												[ onCommandEndEVENT, listener ].concat( rest )
												: [ onCommandEndEVENT, listener ] );
		}
		
		/**
		 * Removes the passed-in listener for listening
		 * the <code>onCommandEnd</code> event of this command.
		 * 
		 * @param	listener	object to be removed as listener
		 */
		public function removeASyncCommandListener( listener : ASyncCommandListener ) : Boolean
		{
			return _oEB.removeEventListener( onCommandEndEVENT, listener );
		}

		/**
		 * Fires the <code>onCommandEnd</code> event to the listeners
		 * of this command. 
		 */
		public function fireCommandEndEvent() : void
		{
			_bIsRunning = false;
			_oEB.broadcastEvent( _eOnCommandEnd );
		}
		
		/**
		 * By default the implementation of the <code>execute</code> method
		 * in the <code>AbstratSyncCommand</code> set it like running
		 * 
		 * @param	e	An event that will be used as data source by the command. 
		 */
		public override function execute( e : Event = null) : void
		{
			_bIsRunning = true;
		}
		
		/**
		 * Implementation of the <code>Runnable</code> interface, 
		 * a call to <code>run()</code> is equivalent to a call to
		 * <code>execute</code> without argument.
		 */
		public function run() : void
		{
			execute();
		}
		
		/**
		 * Returns <code>true</code> if this command is currently
		 * processing.
		 * 
		 * @return	<code>true</code> if this command is currently
		 * 			processing
		 */
		public function isRunning () : Boolean
		{
			return _bIsRunning;
		}

		/**
		 * Returns the string representation of the object.
		 * 
		 * @return the string representation of the object
		 */
		public override function toString():String
		{
			return PixlibStringifier.stringify( this );
		}
	}
}