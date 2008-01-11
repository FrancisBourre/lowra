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
	import flash.utils.getTimer;
	
	import com.bourre.collection.Iterator;
	import com.bourre.commands.ASyncCommand;
	import com.bourre.commands.AbstractSyncCommand;
	import com.bourre.events.IterationEvent;
	import com.bourre.events.LoopEvent;
	import com.bourre.log.PixlibDebug;
	import com.bourre.transitions.FPSBeacon;
	import com.bourre.transitions.FrameBeacon;
	import com.bourre.transitions.FrameListener;	

	/**
	 * 
	 * @author Cédric Néhémie
	 */
	public class LoopCommand extends AbstractSyncCommand 
							 implements ASyncCommand, ASyncCommandListener, FrameListener
	{
		static public const DEFAULT_ITERATION_TIME_LIMIT : Number = 15;
		static public const NO_LIMIT : Number = Number.POSITIVE_INFINITY;
		
		static public const onLoopStartEVENT 	: String = "onLoopStart";
		static public const onLoopProgressEVENT : String = "onLoopProgress";		static public const onLoopEndEVENT 		: String = "onLoopEnd";		static public const onLoopAbortEVENT 	: String = "onLoopAbort";
		
		static private const onIterationEVENT 	: String = "onIteration";
		
		private var _oCommand : IterationCommand;
		private var _oIterator : Iterator;
		private var _oBeacon : FrameBeacon;
		private var _nIterationTimeLimit : Number;
		private var _nIndex : Number;
		private var _bIsPlaying : Boolean;

		/**
		 * 
		 * @param	command
		 * @param	iterationLimit
		 */
		public function LoopCommand ( command : IterationCommand, iterationLimit : Number = DEFAULT_ITERATION_TIME_LIMIT )
		{
			super();
			
			_oBeacon = FPSBeacon.getInstance();
			
			_oCommand =  command;
			_nIterationTimeLimit = iterationLimit;
			_bIsPlaying = false;
		}

		/**
		 * 
		 * @param	e
		 */
		override public function execute (e : Event = null) : void
		{
			_oIterator = _oCommand.iterator();
			_nIndex = 0;
			
			start();
		}
		
		/**
		 * 
		 */
		public function abort () : void
		{
			stop();
			
			_oCommand.abort();
			_oCommand = null;
			_oIterator = null;
			
			fireOnLoopAbortEvent( _nIndex );
		}			
		
		/**
		 * 
		 */
		public function start() : void
		{
			if( !_oCommand )
			{
				PixlibDebug.WARN( "You're attempting to start a loop " +
								  "without any IterationCommand in " + this );
				return;
			}
				
			if( !_bIsPlaying )
			{
				_oBeacon.addFrameListener( this );
				_bIsPlaying = true;
			}
		}
		
		/**
		 * 
		 */
		public function stop() : void
		{
			if( _bIsPlaying )
			{
				_oBeacon.removeFrameListener( this );
				_bIsPlaying = false;
			}
		}
		
		/**
		 * 
		 * @param	e
		 */
		public function onEnterFrame (e : Event = null) : void
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
		 * 
		 * @param	e
		 */
		public function onCommandEnd ( e : ASyncCommandEvent ): void
		{
			(e.getTarget( ) as AbstractSyncCommand ).removeASyncCommandListener( this );
			execute( e );
		}
		
		/**
		 * 
		 * @return
		 */
		public function isPlaying () : Boolean
		{
			return _bIsPlaying;
		}
		
		/**
		 * 
		 * @param	beacon
		 */
		public function setFrameBeacon ( beacon : FrameBeacon ) : void
		{
			if( _bIsPlaying ) _oBeacon.removeFrameListener( this );
			
			_oBeacon = beacon;
			
			if( _bIsPlaying ) _oBeacon.addFrameListener( this );
		}

		/**
		 * 
		 * @param	listener
		 */
		public function addLoopCommandListener ( listener : LoopCommandListener ) : Boolean
		{
			return _oEB.addListener( listener );
		}
		
		/**
		 * 
		 * @param	listener
		 */
		public function removeLoopCommandListener ( listener : LoopCommandListener ) : Boolean
		{
			return _oEB.removeListener( listener );
		}
		
		/**
		 * 
		 */
		protected function fireOnLoopStartEvent () : void
		{
			_oEB.broadcastEvent( new LoopEvent( onLoopStartEVENT, this, 0 ) );
		}
		/**
		 * 
		 */
		protected function fireOnLoopProgressEvent ( n : Number ) : void
		{
			_oEB.broadcastEvent(  new LoopEvent( onLoopProgressEVENT, this, n ) );
		}
		/**
		 * 
		 */
		protected function fireOnLoopAbortEvent ( n : Number ) : void
		{
			_oEB.broadcastEvent(  new LoopEvent( onLoopAbortEVENT, this, n ) );
		}
		/**
		 * 
		 */
		protected function fireOnLoopEndEvent ( n : Number ) : void
		{
			_oEB.broadcastEvent(  new LoopEvent( onLoopEndEVENT, this, n ) );
		}
		/**
		 * 
		 */
		protected function fireOnIterationEvent ( i : Number, o : * ) : void
		{
			_oCommand.execute( new IterationEvent( onIterationEVENT, this, i, o ) );
		}		
	}
}
