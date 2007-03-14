package com.bourre.commands
{
	import flexunit.framework.TestCase;
	import flash.events.Event;

	public class BatchTest extends TestCase
	{
		private var _b : Batch;
		
		public override function setUp () : void
		{
			_b = new Batch();
		}
		
		public function testAddCommand() : void
		{
			var oC : MockCommand = new MockCommand();
			
			assertTrue ( _b + ".addCommand() failed to add the command - test1 failed", _b.addCommand( oC ) );
			assertTrue ( _b + ".contains() failed to find the last inserted command - test2 failed", _b.contains( oC ) );
			assertTrue ( _b + ".addCommand() failed to add the same command a second time - test3 failed", _b.addCommand( oC ) );
			assertEquals ( _b + ".getLength() don't return the right length - test4 failed", _b.getLength(), 2 );
		}
		
		public function testRemoveCommand() : void
		{
			var oC1 : MockCommand = new MockCommand();
			var oC2 : MockCommand = new MockCommand();
			var oC3 : MockCommand = new MockCommand();
			
			_b.addCommand( oC1 );
			_b.addCommand( oC1 );
			_b.addCommand( oC2 );
			
			assertTrue ( _b + ".removeCommand() failed to remove the command - test1 failed", _b.removeCommand( oC1 ) );
			assertFalse ( _b + ".containsCommand() allways find the removed object - test2 failed", _b.contains( oC1 ) );
			assertEquals ( _b + ".getLength() don't return the right length - test3 failed", _b.getLength(), 1 );
			assertFalse ( _b + ".removeCommand() don't return false when trying to remove a command allready removed - test4 failed", _b.removeCommand( oC1 ) );
			assertTrue ( _b + ".removeCommand() failed to remove the command - test5 failed", _b.removeCommand( oC2 ) );
			assertFalse ( _b + ".containsCommand() allways find the removed object - test6 failed", _b.contains( oC2 ) );
			assertEquals ( _b + ".getLength() don't return the right length - test7 failed", _b.getLength(), 0 );
			assertFalse ( _b + ".removeCommand() don't return false when trying to remove a command witch are not stored in the batch - test8 failed", _b.removeCommand( oC3 ) );
		}
		
		public function testRemoveAll () : void
		{
			var oC1 : MockCommand = new MockCommand();
			var oC2 : MockCommand = new MockCommand();
			var oC3 : MockCommand = new MockCommand();
			
			_b.addCommand( oC1 );
			_b.addCommand( oC1 );
			_b.addCommand( oC2 );
			_b.addCommand( oC3 );
			
			assertEquals ( _b + ".getLength() don't return the right length - test1 failed", _b.getLength(), 4 );
			_b.removeAll();
			assertEquals ( _b + ".getLength() don't return the right length after removeAll - test2 failed", _b.getLength(), 0 );
		}
		
		public function testExecuteCommand() : void
		{
			var oC1 : MockCommand = new MockCommand();
			var oC2 : MockCommand = new MockCommand();
			
			var e : Event = new Event ( "foo" );
			
			_b.addCommand( oC1 );
			_b.addCommand( oC1 );
			_b.addCommand( oC2 );
	
			_b.execute( e );
			
			assertTrue ( _b + ".execute() don't called execute on sub-commands - test1 failed", oC1.called );
			assertTrue ( _b + ".execute() don't called execute on subcommands - test2 failed", oC2.called );
			assertEquals ( _b + ".execute() don't called execute the right number of times - test3 failed", oC1.callCount, 2 );
			assertEquals ( _b + ".execute() don't called execute the right number of times - test4 failed", oC2.callCount, 1 );
			assertNotNull ( _b + ".execute() don't pass the event to sub-commands - test5 failed", oC1.event );
			assertStrictlyEquals ( _b + ".execute() don't relay the passed-in event object in sub-commands - test6 failed", oC1.event, e );
		}
	}
}