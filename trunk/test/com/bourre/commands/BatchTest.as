package com.bourre.commands
{
	import flexunit.framework.TestCase;

	public class BatchTest extends TestCase
	{
		private var _b : Batch;
		
		public override function setUp () : void
		{
			_b = new Batch();
		}
		
		public function testAddCommand() : void
		{
			var oC : Command = new MockCommand();
			assertTrue ( _b + ".addCommand() failed to add the command - test1 failed", _b.addCommand( oC ) );
			assertTrue ( _b + ".addCommand() failed to add the same command a second time - test2 failed", _b.addCommand( oC ) );
		}
		
		public function testRemoveCommand() : void
		{
			var oC1 : Command = new MockCommand();
			var oC2 : Command = new MockCommand();
			
			_b.addCommand( oC1 );
			_b.addCommand( oC1 );
			
			
		}
	}
}