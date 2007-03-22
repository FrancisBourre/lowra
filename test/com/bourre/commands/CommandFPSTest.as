package com.bourre.commands
{
	import flexunit.framework.TestCase;
	import com.bourre.transitions.MockBeacon;

	public class CommandFPSTest extends TestCase
	{
		private var _oCommandFPS : MockCommandFPS;
		private var _oCommand : MockCommand;
		private var _nIteration : Number;
		
		public override function setUp () : void
		{
			_oCommandFPS = new MockCommandFPS();
			_oCommand = new MockCommand();
			_nIteration = 0;
		}
		
		public function testConstruct() : void
		{
			assertNotNull ( "CommandFPS constructor return null - test1 failed", _oCommandFPS );
		}
		
		public function testPushAndRemove () : void
		{
			var sn : String = _oCommandFPS.push( _oCommand );
			
			assertNotNull ( "CommandFPS.push() return null as key of the command - test1 failed", sn );
			assertEquals  ( "CommandFPS.push() haven't modify the length - test2 failed", 1, _oCommandFPS.getLength() );
			
			_oCommandFPS.pushWithName( _oCommand, sn );		
			assertEquals  ( "CommandFPS.pushWithName() have modify the length when replacing a command - test3 failed", 1, _oCommandFPS.getLength() );
			
			_oCommandFPS.push( _oCommand );
			assertEquals  ( "CommandFPS.push() haven't modify the length - test4 failed", 2, _oCommandFPS.getLength() );	
			
			_oCommandFPS.removeWithName( sn );
			assertEquals  ( "CommandFPS.removeWithName() haven't modify the length - test5 failed", 1, _oCommandFPS.getLength() );	
			
			_oCommandFPS.remove( _oCommand );
			assertEquals  ( "CommandFPS.remove() haven't modify the length - test6 failed", 0, _oCommandFPS.getLength() );	
			
			_oCommandFPS.push( _oCommand );
			_oCommandFPS.push( _oCommand );	
			_oCommandFPS.push( _oCommand );
			assertEquals  ( "CommandFPS.push() haven't modify the length - test7 failed", 3, _oCommandFPS.getLength() );	
			_oCommandFPS.removeAll();
			assertEquals  ( "CommandFPS.removeAll() haven't modify the length - test8 failed", 0, _oCommandFPS.getLength() );				
		}
		
		public function testRun () : void
		{
			_oCommandFPS.push( _oCommand );
			
			assertTrue ( "Command.execute() haven't been called - test1 failed", _oCommand.called );
			assertEquals ( "Command.execute() haven't been called one times - test2 failed", 1, _oCommand.callCount );	
			
			_oCommand.called = false;
			_oCommand.callCount = 0;
			
			while ( _nIteration < 10 )
			{
				MockBeacon.getInstance().enterFrameHandler( null );
				_nIteration++;
			}
			
			assertTrue ( "Command.execute() haven't been called - test3 failed", _oCommand.called );
			assertEquals ( "Command.execute() haven't been called on each frame - test4 failed", 10, _oCommand.callCount );						
		}
		
		public function testStopAndResume() : void
		{
			var c : MockCommand = new MockCommand();
			var sn : String = _oCommandFPS.push( c );
			_oCommandFPS.push( _oCommand );
			
			_oCommand.called = false;
			_oCommand.callCount = 0;
			
			c.called = false;
			c.callCount = 0;
			
			while ( _nIteration < 10 )
			{
				if( _nIteration == 2 )
				{
					assertTrue( _oCommandFPS+".stop() failed to stop the passed in command - test1 failed", _oCommandFPS.stop( _oCommand ) );
					assertTrue(  _oCommandFPS+".stopWithName() failed to stop the passed in command - test2 failed", _oCommandFPS.stopWithName( sn ) );
				}
				else if ( _nIteration == 6 )
				{
					assertTrue( _oCommandFPS+".resume() failed to resume the passed-in command - test3 failed", _oCommandFPS.resume( _oCommand ) );
					assertTrue( _oCommandFPS+".resumeWithName() failed to resume the passed-in command - test4 failed", _oCommandFPS.resumeWithName( sn ) );
				}
				
				MockBeacon.getInstance().enterFrameHandler( null );
				_nIteration++;				
			}
			
			assertTrue ( "Command.execute() haven't been called - test5 failed", _oCommand.called );
			assertEquals ( "Command.execute() haven't been called on each frame - test6 failed", 7, _oCommand.callCount );
			
			assertTrue ( "Command.execute() haven't been called - test7 failed", c.called );
			assertEquals ( "Command.execute() haven't been called on each frame - test8 failed", 7, c.callCount );	
		}
		
		public function testDelay () : void
		{
			_oCommandFPS.delay( _oCommand );
			
			MockBeacon.getInstance().enterFrameHandler( null );
			
			assertTrue ( "Command.execute() haven't been called on the succeeding frame - test1 failed", _oCommand.called );
			assertEquals ( "Command.execute() haven't been called on the succeeding frame - test2 failed", 1, _oCommand.callCount );
			
			MockBeacon.getInstance().enterFrameHandler( null );
			
			assertEquals ( "Command.execute() have been called a second time - test2 failed", 1, _oCommand.callCount );
		}
	}
}