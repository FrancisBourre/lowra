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
	import com.bourre.error.IllegalStateException;
	import com.bourre.events.BasicEvent;
	import com.bourre.events.EventBroadcaster;
	import com.bourre.log.PixlibDebug;
	import com.bourre.log.PixlibStringifier;
	
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;		

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
	public class ASyncCommandSequencer extends AbstractSyncCommand	implements ASyncCommand, ASyncCommandListener
	{
		static public const onCommandTimeoutEVENT : String = "onCommandTimeout";
		
		private var _aCommands : Array;
		private var _nTimeout : Number;
		private var _nStep : Number;
		private var _oTimer : Timer;
		
		private var _eOnCommandTimeout : BasicEvent;
		
		/**
		 * 
		 * @param nTimeout
		 */
		public function ASyncCommandSequencer ( nTimeout : int = -1 )
		{
			_nStep = 0;
			_aCommands = new Array();
			
			_nTimeout = isNaN( nTimeout ) ? -1 : nTimeout;
			_oTimer = new Timer( _nTimeout == -1 ? 1 : _nTimeout, 1 );
		  	_oTimer.addEventListener( TimerEvent.TIMER_COMPLETE, _onTimeout );

		  	_eOnCommandTimeout = new BasicEvent ( onCommandTimeoutEVENT, this );
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
		 * Clear all the commands
		 * @return 
		 * 
		 */
		public function clear() : void
		{
			if(!_bIsRunning)
			{
				_aCommands = new Array();
			}
		}
		
		/**
		 * 
		 * @param indexCommand
		 * @param oCommand
		 * @return 
		 * 
		 */
		public function addCommandBefore( indexCommand : ASyncCommand, oCommand : ASyncCommand ) : Boolean
		{
			var index : uint = _aCommands.indexOf(indexCommand) ;
			if( oCommand == null && indexCommand != -1) return false;
			
			return addCommandAt(index , oCommand) ;
		}
		
		/**
		 * 
		 * @param indexCommand
		 * @param oCommand
		 * @return 
		 * 
		 */
		public function addCommandAfter( indexCommand : ASyncCommand, oCommand : ASyncCommand ) : Boolean
		{
			var index : uint = _aCommands.indexOf(indexCommand) ;
			if( oCommand == null && indexCommand != -1) return false;
			
			return addCommandAt(index + 1 , oCommand) ;
		}
		
		/**
		 * 
		 * @param oCommand
		 * @return 
		 * 
		 */
		public function addCommandStart(oCommand : ASyncCommand ) : Boolean
		{
			return addCommandAt(0, oCommand) ;
		}
		
		/**
		 * 
		 * @param oCommand
		 * @return 
		 * 
		 */
		public function addCommandEnd(oCommand : ASyncCommand ) : Boolean
		{
			return addCommandAt(_aCommands.length,oCommand) ;
		}
		
		/**
		 * 
		 * @param p index at which the command is to be inserted.
		 * @param oCommand
		 * @return 
		 * 
		 */
		protected function addCommandAt( index : uint, oCommand : ASyncCommand ) : Boolean
		{
			var l : uint = _aCommands.length;
			
			if( oCommand == null && index > l) return false;
			
			_aCommands.splice( index, 0, oCommand );
			return (l != _aCommands.length );
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
		 * @return the <code>ASyncCommand</code> that running at this time in the sequencer
		 * 
		 */
		public function getRunningCommand () : ASyncCommand
		{
			if( isRunning() )
				return _aCommands[ _nStep ];
			else
			{
				throw new IllegalStateException(this + ".getRunningCommand cannot be call when the sequencer is not running ");
				return null ;
			}
		}
		
		/**
		 * 
		 * @param e
		 * 
		 */
		public override function execute( e : Event = null ) : void
		{
			if( !isRunning() &&  getLength())
			{
				_bIsRunning = true;
				_executeNextCommand ();
			}
		}
				
		/**
		 * 
		 * @param e
		 * 
		 */
		public function onCommandEnd( e : Event):void
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
				_bIsRunning = false;
				_oEB.broadcastEvent( _eOnCommandEnd );
			}
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
			_bIsRunning = false;
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