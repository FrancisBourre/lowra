package com.bourre.commands 
{
	import com.bourre.commands.AbstractSyncCommand;
	import com.bourre.commands.ASyncCommand;
	
	import flash.events.Event;
	
	import com.bourre.transitions.FrameListener;
	import com.bourre.collection.Iterator;
	import com.bourre.transitions.FrameBeacon;
	import com.bourre.transitions.FPSBeacon;
	import com.bourre.events.IterationEvent;
	
	import flash.utils.getTimer;
	
	import com.bourre.events.LoopEvent;

	/**
	 * @author Cédric Néhémie
	 */
	public class LoopCommand extends AbstractSyncCommand 
		   implements ASyncCommand, ASyncCommandListener, FrameListener
	{
		static public const DEFAULT_ITERATION_TIME_LIMIT : Number = 15;
		static public const NO_LIMIT : Number = Number.POSITIVE_INFINITY;

		static public const onLoopStartEVENT : String = "onLoopStart";
		static public const onLoopProgressEVENT : String = "onLoopProgress";		static public const onLoopEndEVENT : String = "onLoopEnd";
		
		static public const onIterationEVENT : String = "onIteration";
		
		protected var _oCommand : IterationCommand;
		protected var _oIterator : Iterator;
		protected var _oBeacon : FrameBeacon;
		protected var _nIterationTimeLimit : Number;
		protected var _nIndex : Number;
		protected var _bIsPlaying : Boolean;

		public function LoopCommand ( command : IterationCommand, 
									  iterationLimit : Number = DEFAULT_ITERATION_TIME_LIMIT )
		{
			super();
			
			_oBeacon = FPSBeacon.getInstance();
			
			_oCommand =  command;
			_nIterationTimeLimit = iterationLimit;
			_bIsPlaying = false;
		}

		override public function execute (e : Event = null) : void
		{
			_oIterator = _oCommand.iterator();
			_nIndex = 0;
			_bIsPlaying = true;
			
			_oBeacon.addFrameListener( this );
		}
		
		public function onEnterFrame (e : Event = null) : void
		{
			var time:Number = 0;
			var tmpTime:Number;
			
			while( time < _nIterationTimeLimit )
			{
				tmpTime = getTimer();
				if(_oIterator.hasNext())
				{
					fireOnIterationEvent( _nIndex, _oIterator.next() );
					_nIndex++;
				}
				else
				{
					_oBeacon.removeFrameListener( this );
					_bIsPlaying = false;
					
					fireOnLoopProgressEvent( _nIndex );
					fireOnLoopEndEvent( _nIndex );
					fireCommandEndEvent();
					
					return;
				}
				time += getTimer() - tmpTime;
			}
			fireOnLoopProgressEvent( _nIndex );
		}
		
		public function onCommandEnd ( e : ASyncCommandEvent ): void
		{
			(e.getTarget( ) as AbstractSyncCommand ).removeASyncCommandListener( this );
			execute( e );
		}
		
		public function isPlaying () : Boolean
		{
			return _bIsPlaying;
		}

		public function setFrameBeacon ( beacon : FrameBeacon ) : void
		{
			if( _bIsPlaying ) _oBeacon.removeFrameListener( this );
			
			_oBeacon = beacon;
			
			if( _bIsPlaying ) _oBeacon.addFrameListener( this );
		}

		public function addLoopCommandListener ( listener : LoopCommandListener ) : Boolean
		{
			return _oEB.addListener( listener );
		}
		public function removeLoopCommandListener ( listener : LoopCommandListener ) : Boolean
		{
			return _oEB.removeListener( listener );
		}
		public function fireOnLoopStartEvent () : void
		{
			_oEB.broadcastEvent( new LoopEvent( onLoopStartEVENT, this, 0 ) );
		}
		public function fireOnLoopProgressEvent ( n : Number ) : void
		{
			_oEB.broadcastEvent(  new LoopEvent( onLoopProgressEVENT, this, n ) );
		}
		public function fireOnLoopEndEvent ( n : Number ) : void
		{
			_oEB.broadcastEvent(  new LoopEvent( onLoopEndEVENT, this, n ) );
		}
		public function fireOnIterationEvent ( i : Number, o : * ) : void
		{
			_oCommand.execute( new IterationEvent( onIterationEVENT, this, i, o ) );
		}		
	}
}
