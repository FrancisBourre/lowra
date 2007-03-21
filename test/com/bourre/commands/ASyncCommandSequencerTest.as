package com.bourre.commands
{
	import flexunit.framework.TestCase;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import com.bourre.log.PixlibDebug;
	import flash.events.Event;

	public class ASyncCommandSequencerTest extends TestCase
	{
		private var _c1 : MockAbstractSyncCommand;
		private var _c2 : MockAbstractSyncCommand;
		private var _s : ASyncCommandSequencer;
		private var _l : MockASyncCommandSequencerListener;
		
		public override function setUp () : void
		{
			_c1 = new MockAbstractSyncCommand ();
			_c2 = new MockAbstractSyncCommand ();
			_s = new ASyncCommandSequencer ( 10 );			
			_l = new MockASyncCommandSequencerListener ();
		}
		
		public function testNoFailedCommand () : void
		{
			_s.addListener( _l );
			
			assertTrue ( _s + ".addCommand() failed to add the command", _s.addCommand( _c1 ) );
			assertTrue ( _s + ".addCommand() failed to add the command", _s.addCommand( _c2 ) );
			assertEquals ( _s + ".getLength() don't return the right number of commands", _s.getLength(), 2 );
			assertTrue ( _s + ".removeCommand() failed to remove the command", _s.removeCommand( _c2 ) );
			assertEquals ( _s + ".getLength() don't return the right number of commands", _s.getLength(), 1 );
			assertTrue ( _s + ".addCommand() failed to add the command", _s.addCommand( _c2 ) );
			
			_s.execute();
			
			assertTrue ( "onCommandEnd haven't been called.", _l.commandEndCalled );
			assertFalse ( _s + ".isRunning() return true", _s.isRunning() );
		}
		
		public function testFailedCommand () : void
		{
			
			_s.addListener( _l );

			assertTrue ( _s + ".addCommand() failed to add the command", _s.addCommand( new MockFailureASyncCommand() ) );
			assertTrue ( _s + ".addCommand() failed to add the command", _s.addCommand( _c1 ) );
			assertTrue ( _s + ".addCommand() failed to add the command", _s.addCommand( _c2 ) );
			
			var o : Timer = new Timer ( 50, 1 );
			o.addEventListener( TimerEvent.TIMER_COMPLETE, addAsync ( _onTimeOut, 100 ) );
			o.start();
			
			_s.execute();
			
			assertTrue ( _s + ".isRunning() return false", _s.isRunning() );
		}
		
		public function _onTimeOut ( e : Event ) : void
		{
			assertTrue ( "onTimeout haven't been called.", _l.commandTimeoutCalled );
		}
		
	}
}