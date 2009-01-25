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
	import com.bourre.collection.Iterator;
	import com.bourre.commands.AbstractSyncCommand;
	import com.bourre.error.IllegalStateException;
	import com.bourre.events.IterationEvent;
	import com.bourre.events.LoopEvent;
	import com.bourre.log.PixlibDebug;
	import com.bourre.plugin.Plugin;
	import com.bourre.transitions.FPSBeacon;
	import com.bourre.transitions.TickBeacon;
	import com.bourre.transitions.TickListener;
	
	import flash.events.Event;
	import flash.utils.getTimer;	

	/**
	 * A <code>LoopCommand</code> wrap a loop statement within a command. Loop
	 * are strecthed over time using functionnalities of a <code>TickBeacon</code>
	 * object. According to the maximum execution time limit of this command
	 * the maximum amout of iteration will be performed for each step since the
	 * step execution time exceed the maximum execution time.
	 * <p>
	 * For informations and examples on these classes see the 
	 * <a href="../../../../docs/howto/howto-loopcommands.html">How to use LoopCommand
	 * and IterationCommand</a> document.
	 * </p>
	 * 
	 * @author 	Cédric Néhémie
	 * @see		IterationCommand
	 */
	public class LoopCommand extends AbstractSyncCommand 
							 implements Cancelable, Suspendable, ASyncCommandListener, TickListener
	{
		/**
		 * Default execution time limit by loop iterations group
		 */
		static public const DEFAULT_ITERATION_TIME_LIMIT : Number = 15;
		/**
		 * Defines an unlimited execution time for loop iterations.
		 */
		static public const NO_LIMIT : Number = Number.POSITIVE_INFINITY;
		
		/**
		 * Name of the event dispatched at the start of the command's process.
		 */
		static public const onLoopStartEVENT 	: String = "onLoopStart";
		/**
		 * Name of the event dispatched at the stop of the command's process.
		 */
		static public const onLoopStopEVENT 	: String = "onLoopStop";
		/**
		 * Name of the event dispatched at each step of computation.
		 */
		static public const onLoopProgressEVENT : String = "onLoopProgress";
		/**
		 * Name of the event dispatched at the end of the command's process.
		 */		static public const onLoopEndEVENT 		: String = "onLoopEnd";
		/**
		 * Name of the event dispatched on user cancelation.
		 */		static public const onLoopCancelEVENT 	: String = "onLoopCancel";
		
		/*---------------------------------------
		 *  PRIVATE MEMBERS
		 *---------------------------------------*/
		static private const onIterationEVENT 	: String = "onIteration";
		
		private var _oCommand : IterationCommand;
		private var _oIterator : Iterator;
		private var _oBeacon : TickBeacon;
		private var _nIterationTimeLimit : Number;
		private var _nIndex : Number;		private var _bIsCancelled : Boolean;
		private var _bIsDone : Boolean;

		/**
		 * Creates a new <code>LoopCommand</code> object which will handle
		 * the passed-in <code>IterationCommand</code>
		 * 
		 * @param	command			iteration command which will be called
		 * 							during the loop, it also provide the
		 * 							iterator the loop command will use
		 * @param	iterationLimit	maximum execution time for each step of
		 * 							the loop command process
		 */
		public function LoopCommand ( command : IterationCommand, iterationLimit : Number = DEFAULT_ITERATION_TIME_LIMIT )
		{
			super();
			
			_oBeacon = FPSBeacon.getInstance();
			
			_oCommand =  command;
			_nIterationTimeLimit = iterationLimit;
			_bIsRunning = false;
			_bIsCancelled = false;
			_bIsDone = false;
		}
		
		/**
		 * Resets and then start the loop command process.
		 * <p>
		 * The command cannot be executed after a call to
		 * the <code>cancel</code> method. If a call to <code>
		 * execute</code> is done after the command be canceled
		 * the function fail and throw an error
		 * </p> 
		 * @param	e	event object to initialise the command (not use)
		 * @throws 	<code>IllegalStateException</code> — if the <code>execute</code>
		 * 			method have been called wheras the operation have been already
		 * 			cancelled
		 */
		override public function execute (e : Event = null) : void
		{
			if( !isCancelled() )
			{
				reset();			
				start();
			}
			else
			{
				var msg : String = "Can't execute a process which is already canceled : " + this;
				
				PixlibDebug.ERROR( msg );
				throw new IllegalStateException( msg );
			}
		}
		
		/**
		 * Attempts to cancel execution of this task.
		 * This attempt will fail if the task has already completed,
		 * has already been cancelled, or could not be cancelled for
		 * some other reason. If successful, and this task has not
		 * started when cancel is called, this task should never run.
		 * <p>
		 * After this method returns, subsequent calls to <code>isRunning</code>
		 * will always return <code>false</code>. Subsequent calls to
		 * <code>run</code> will always fail with an exception. Subsequent
		 * calls to <code>cancel</code> will always failed with the throw
		 * of an exception. 
		 * </p>
		 * @throws 	<code>IllegalStateException</code> — if the <code>cancel</code>
		 * 			method have been called wheras the operation have been already
		 * 			cancelled
		 */
		public function cancel () : void
		{
			if( !isCancelled() && !isDone() )
			{
				stop();
	
				//_oCommand = null;
				_oIterator = null;
				_bIsCancelled = true;
				
				fireOnLoopCancelEvent( _nIndex );
			}
			else
			{
				var msg : String = "Can't cancel a process which is already canceled : " + this;
				
				PixlibDebug.ERROR( msg );
				throw new IllegalStateException( msg );
			}	
		}		
		
		/**
		 * Returns <code>true</code> if the loop process have been
		 * canceled by the user.
		 * 
		 * @return	<code>true</code> if the loop process have been
		 * 			canceled by the user
		 */
		public function isCancelled () : Boolean
		{
			return _bIsCancelled;
		}
		
		/**
		 * Returns <code>true</code> if the loop process have been 
		 * completed.
		 * 
		 * @return	<code>true</code> if the loop process have been 
		 * 			completed
		 */
		public function isDone () : Boolean
		{
			return _bIsDone;
		}
		
		
		/**
		 * Resets the state of this command. A loop command cannot be reset
		 * while running. If a call to the <code>reset</code> is done
		 * while the command is running, the call fail with an error.
		 * 
		 * @throws 	<code>IllegalStateException</code> — Can't reset an
		 * 			operation currently running.
		 */
		public function reset() : void
		{
			if( !isRunning() )
			{
				_oIterator = _oCommand.iterator();
				_nIndex = 0;
				_bIsDone = false;
			}
			else
			{
				var msg : String = "Can't reset a process which is already running : " + this;
				
				PixlibDebug.ERROR( msg );
				throw new IllegalStateException( msg );
			}
		}	
		
		/**
		 * Starts or restarts the loop process.
		 * The process can be started only if there is a valid
		 * <code>IterationCommand</code> and if the command 
		 * haven't be canceled or completed.
		 * 
		 * @throws 	<code>IllegalStateException</code> — Can't start
		 * 			a command which has no specified iteration command
		 * @throws 	<code>IllegalStateException</code> — Can't start a
		 * 			canceled or completed command
		 */
		public function start() : void
		{
			var msg : String;
			if( !_oCommand )
			{
				msg = "You're attempting to start a loop " +
								   "without any IterationCommand in " + this;
								  
				PixlibDebug.ERROR( msg );
				throw new IllegalStateException( msg );
			}
			
			if( isCancelled() )
			{
				msg = "You're attempting to start a loop " +
					  "which was canceled : " + this;
								  
				PixlibDebug.ERROR( msg );
				throw new IllegalStateException( msg );
			}
			else if ( isDone() )
			{
				msg = "You're attempting to start a loop " +
					  "which was completed : " + this;
								  
				PixlibDebug.ERROR( msg );
				throw new IllegalStateException( msg );
			}
			else if( !isRunning() )
			{
				_oBeacon.addTickListener( this );
				_bIsRunning = true;
				fireOnLoopStartEvent( _nIndex );
			}
		}
		
		/**
		 * Stops the loop process. Command could be
		 * stop only when it is running.
		 */
		public function stop() : void
		{
			if( _bIsRunning )
			{
				_oBeacon.removeTickListener( this );
				_bIsRunning = false;
				fireOnLoopStopEvent( _nIndex );
			}
		}
		
		override public function setOwner ( owner : Plugin ) : void
		{
			super.setOwner(owner );
			if( _oCommand is AbstractCommand )
				(_oCommand as AbstractCommand).setOwner(owner);
		}

		/**
		 * Process the loop. At each call of this function
		 * a real loop statement is performed until its
		 * execution time go past the maximum execution time
		 * defined for this command.
		 * 
		 * @param	e	event object dispatched by the beacon
		 */
		public function onTick (e : Event = null) : void
		{
			var time:Number = 0;
			var tmpTime:Number;
			
			while( time < _nIterationTimeLimit )
			{
				tmpTime = getTimer();
				if( _oIterator.hasNext() )
				{
					fireOnIterationEvent( _nIndex, _oIterator.next() );
					_nIndex++;
				}
				else
				{
					stop();
					_bIsDone = true;
					fireOnLoopProgressEvent( _nIndex );
					fireOnLoopEndEvent( _nIndex );
					fireCommandEndEvent();
					
					return;
				}
				time += getTimer() - tmpTime;
			}
			fireOnLoopProgressEvent( _nIndex );
		}
		
		/**
		 * Called at the end of another loop command. 
		 * The <code>LoopCommand</code> class implements 
		 * <code>ASyncCommandListener</code> in order to
		 * provide a way to automatically chain several
		 * commands together. 
		 * 
		 * @param	e	event object dispatched by the asynchronous command
		 */
		public function onCommandEnd ( e : Event ): void
		{
			(e.target as AbstractSyncCommand ).removeASyncCommandListener( this );
			execute( e );
		}
		
		
		/**
		 * Defines on which beacon the loop command will perform
		 * its operation. It allow to the user to control the
		 * speed at which execution steps will be called.
		 * 
		 * @param	beacon	beacon object onto which the command
		 * 			will run
		 */
		public function setFrameBeacon ( beacon : TickBeacon ) : void
		{
			if( _bIsRunning ) _oBeacon.removeTickListener( this );
			
			_oBeacon = beacon;
			
			if( _bIsRunning ) _oBeacon.addTickListener( this );
		}

		/**
		 * Adds the passed-in listener as listener for this command's events.
		 * 
		 * @param	listener	listener to be added
		 */
		public function addLoopCommandListener ( listener : LoopCommandListener ) : Boolean
		{
			return _oEB.addListener( listener );
		}
		
		/**
		 * Removes the passed-in listener as listener for this command's events.
		 * 
		 * @param	listener	listener to be removed
		 */
		public function removeLoopCommandListener ( listener : LoopCommandListener ) : Boolean
		{
			return _oEB.removeListener( listener );
		}
		
		/**
		 * Fires the <code>onLoopStart</code> event to its listeners.
		 * 
		 * @param	n	iterations performed until the restart
		 */
		protected function fireOnLoopStartEvent ( n : Number ) : void
		{
			_oEB.broadcastEvent( new LoopEvent( onLoopStartEVENT, this, n ) );
		}
		/**
		 * Fires the <code>onLoopProgresst</code> event to its listeners.
		 * 
		 * @param	n	iterations performed until the call
		 */
		protected function fireOnLoopProgressEvent ( n : Number ) : void
		{
			_oEB.broadcastEvent(  new LoopEvent( onLoopProgressEVENT, this, n ) );
		}
		/**
		 * Fires the <code>onLoopCancel</code> event to its listeners.
		 * 
		 * @param	n	iterations performed until the cancelation
		 */
		protected function fireOnLoopCancelEvent ( n : Number ) : void
		{
			_oEB.broadcastEvent(  new LoopEvent( onLoopCancelEVENT, this, n ) );
		}
		/**
		 * Fires the <code>onLoopEnd</code> event to its listeners.
		 * 
		 * @param	n	iterations performed until the end
		 */
		protected function fireOnLoopEndEvent ( n : Number ) : void
		{
			_oEB.broadcastEvent(  new LoopEvent( onLoopEndEVENT, this, n ) );
		}
		/**
		 * Fires the <code>onLoopStop</code> event to its listeners.
		 * 
		 * @param	n	iterations performed until the stop
		 */
		protected function fireOnLoopStopEvent ( n : Number ) : void
		{
			_oEB.broadcastEvent(  new LoopEvent( onLoopStopEVENT, this, n ) );
		}
		/**
		 * Fires the <code>onLoopStart</code> event to the internal
		 * <code>IterationCommand</code>.
		 * 
		 * @param	i	current iteration number
		 * @param	o 	value retreived from the iterator <code>next</code>
		 * 				method
		 */
		protected function fireOnIterationEvent ( i : Number, o : * ) : void
		{
			_oCommand.execute( new IterationEvent( onIterationEVENT, this, i, o ) );
		}		
	}
}
