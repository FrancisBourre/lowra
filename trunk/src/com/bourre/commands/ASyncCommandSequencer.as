package com.bourre.commands
{
	import flash.events.Event;
	import com.bourre.log.PixlibStringifier;
	import com.bourre.log.PixlibDebug;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import com.bourre.events.EventBroadcaster;

	/*
	 * Upgrade to IOC : 
	 *  - remove abstract protection hack and call super with constructor argument
	 *  - uncomment extends elements 
	 *  - refactor add and remove listener return
	 */

	/**
	 * 
	 * 
	 * @author 	Cédric Néhémie
	 * @see		AbstractSyncCommand
	 * @see		ASyncCommand
	 * @see		ASyncCommandListener
	 */
	public class ASyncCommandSequencer extends AbstractSyncCommand	
		implements ASyncCommand, ASyncCommandListener
	{
		private var _aCommands : Array;
		private var _nTimeout : Number;
		private var _nStep : Number;
		private var _oTimer : Timer;
		private var _bIR : Boolean;
		
		private var _eOnCommandTimeout : ASyncCommandEvent;
		
		/**
		 * 
		 * @param nTimeout
		 */
		public function ASyncCommandSequencer ( nTimeout : int = -1 )
		{
			super( abstractSyncCommandConstructorAccess );
			_nStep = 0;
			_aCommands = new Array();
			
			_nTimeout = isNaN( nTimeout ) ? -1 : nTimeout;
			_oTimer = new Timer( _nTimeout == -1 ? 1 : _nTimeout, 1 );
		  	_oTimer.addEventListener( TimerEvent.TIMER_COMPLETE, _onTimeout );

		  	_eOnCommandTimeout = new ASyncCommandEvent ( ASyncCommandEvent.onCommandTimeoutEVENT, this );
		}		
		
		/**
		 * 
		 * @param oCommand
		 * @return 
		 * 
		 */
		public function addCommand( oCommand : ASyncCommand ) : Boolean
		{
			if( oCommand == null ) return false;
			
			var l : Number = _aCommands.length;
			return (l != _aCommands.push( oCommand ) );
		}
		
		/**
		 * 
		 * @param oCommand
		 * @return 
		 * 
		 */
		public function removeCommand( oCommand : ASyncCommand ):Boolean
		{ 
			var id : Number = _aCommands.indexOf( oCommand ); 
			
			if ( id == -1 ) return false;
			
			while ( ( id = _aCommands.indexOf( oCommand ) ) != -1 )
			{
				_aCommands.splice( id, 1 );
			}
			return true;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function getLength () : uint
		{
			return _aCommands.length;
		}
		
		/**
		 * 
		 * @param e
		 * 
		 */
		public override function execute( e : Event = null ) : void
		{
			if( !isRunning() )
			{
				_bIR = true;
				_executeNextCommand ();
			}
		}
				
		/**
		 * 
		 * @param e
		 * 
		 */
		public function onCommandEnd(e:Event):void
		{
			if ( _nStep + 1 < getLength() )
			{
				_aCommands[ _nStep ].removeASyncCommandListener( this );
				_nStep++;
				_executeNextCommand();
			} 
			else
			{
				_nStep = 0;
				_abortTimeout ();
				_bIR = false;
				_oEB.broadcastEvent( _eOnCommandEnd );
			}
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function isRunning () : Boolean
		{
			return _bIR;
		}
		
		/**
		 * 
		 * @param t
		 * @param o
		 * 
		 */
		public function addEventListener ( t : String, o : * ) : void
		{
			_oEB.addEventListener( t, o );
		}
		
		/**
		 * 
		 * @param t
		 * @param o
		 * 
		 */
		public function removeEventListener ( t : String, o : * ) : void
		{
			_oEB.removeEventListener( t, o );
		}
		
		/**
		 * 
		 * @param o
		 * 
		 */
		public function addListener ( o : ASyncCommandSequencerListener ) : void
		{
			_oEB.addListener( o );
		}
		
		/**
		 * 
		 * @param o
		 * 
		 */
		public function removeListener ( o : ASyncCommandSequencerListener ) : void
		{
			_oEB.removeListener( o );
		}
		
		/**
		 * 
		 * 
		 */
		private function _executeNextCommand () : void
		{
			_abortTimeout ();
			if ( _nStep == -1 )
	  		{
	  			PixlibDebug.WARN( this + " process has been aborted. Can't execute next command." );		
	  		} 
	  		else 
			{
		  		_runTimeout ();
		  		_aCommands[ _nStep ].addASyncCommandListener ( this );
				_aCommands[ _nStep ].execute();
	  		}
		}
		
		/**
		 * 
		 * @param e
		 * 
		 */
		public function _onTimeout ( e : TimerEvent ) : void
		{
			_abortTimeout ();
			_nStep = -1;
			_bIR = false;
			_oEB.broadcastEvent( _eOnCommandTimeout );
		}
		
		/**
		 * 
		 * 
		 */
		private function _runTimeout () : void
		{
			if( _nTimeout != -1 )
		  		_oTimer.start();
		}
		
		/**
		 * 
		 * 
		 */
		private function _abortTimeout () : void
		{
			if( _nTimeout != -1 )
				_oTimer.reset();
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public override function toString () : String
		{
			return PixlibStringifier.stringify( this );
		}
	}
}