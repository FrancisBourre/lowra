package com.bourre.commands
{
	import flexunit.framework.TestCase;
	
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.events.Event;
	

	public class CommandMSTest extends TestCase
	{
		private var _oCMS : CommandMS;
		private var _oC : MockCommand;
		private var _nI : Number;
		
		public override function setUp ():void
		{
			_oCMS = new CommandMS();
			_oC = new MockCommand();
		} 
		public function testConstruct() : void
		{
			assertNotNull ( "CommandMS constructor return null - test1 failed", _oCMS );
		}
		
		public function testPushAndRemove () : void
		{
			var sn : String = _oCMS.push( _oC, 50 );
			
			assertNotNull ( "CommandMS.push() return null as key of the command - test1 failed", sn );
			assertEquals  ( "CommandMS.push() haven't modify the length - test2 failed", 1, _oCMS.getLength() );
			
			_oCMS.pushWithName( _oC, 50, sn );		
			assertEquals  ( "CommandMS.pushWithName() have modify the length when replacing a command - test3 failed", 1, _oCMS.getLength() );
			
			_oCMS.push( _oC, 50 );
			assertEquals  ( "CommandMS.push() haven't modify the length - test4 failed", 2, _oCMS.getLength() );	
			
			_oCMS.removeWithName( sn );
			assertEquals  ( "CommandMS.removeWithName() haven't modify the length - test5 failed", 1, _oCMS.getLength() );	
			
			_oCMS.remove( _oC );
			assertEquals  ( "CommandMS.remove() haven't modify the length - test6 failed", 0, _oCMS.getLength() );	
			
			_oCMS.push( _oC, 50 );
			_oCMS.push( _oC, 50 );	
			_oCMS.push( _oC, 50 );
			assertEquals  ( "CommandMS.push() haven't modify the length - test7 failed", 3, _oCMS.getLength() );	
			_oCMS.removeAll();
			assertEquals  ( "CommandMS.removeAll() haven't modify the length - test8 failed", 0, _oCMS.getLength() );				
		}
		
		public function testRun () : void
		{		
			_oCMS.push( _oC, 50 );
			var o : Timer = new Timer ( 600, 1 );
			o.addEventListener( TimerEvent.TIMER_COMPLETE, addAsync ( aSyncRunCallBack, 1000, 3 ) );
			o.start();
		}
		
		public function testDelay () : void
		{
			_oCMS.delay( _oC, 500 );
			
			var o : Timer = new Timer ( 600, 1 );
			o.addEventListener( TimerEvent.TIMER_COMPLETE, addAsync ( aSyncRunCallBack, 1000, 1 ) );
			o.start();
		}
		
		public function aSyncRunCallBack ( e : Event, min : Number ) : void
		{			
			assertTrue ( "Command haven't been called by the CommandMS - test1 failed", _oC.called );
			assertTrue ( "Command haven't been called the right number of times", _oC.callCount >= min );
		}
	}
}