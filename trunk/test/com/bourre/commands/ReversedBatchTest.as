package com.bourre.commands
{
	import flexunit.framework.TestCase;
	import flash.events.Event;

	public class ReversedBatchTest extends TestCase
	{
		private var _oRB:ReversedBatch ;
		
		public override function setUp():void
		{
			_oRB = new ReversedBatch () ;
		}
		
		public function testConstruct () : void
		{
			assertNotNull("ReversedBatch constructor returns Null", _oRB) ;
		}
		
		
		
		public function testExecute ():void
		{
			var oC : MockCommand = new MockCommand();
			assertTrue("ReversedBatch.addCommand command not added", _oRB.addCommand(oC));
			
			var e : Event = new Event ( "foo" );
			
			_oRB.execute(e) ;
			assertTrue ( "Reversedbatch.execute() don't called execute on sub-commands - test failed", oC.called );
			assertEquals ( _oRB + ".execute() don't called execute the right number of times - test3 failed", oC.callCount, 1 );
			assertNotNull ( _oRB + ".execute() don't pass the event to sub-commands - test5 failed", oC.event );
		}
	}
}