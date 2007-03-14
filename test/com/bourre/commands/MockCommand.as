package com.bourre.commands
{
	import flash.events.Event;

	public class MockCommand implements Command
	{
		public var called : Boolean;
		public var callCount : Number;
		public var event : Event;
		
		public function MockCommand ()
		{
			callCount = 0;
			called = false;
		}
		
		public function execute( e : Event = null ) : void
		{
			called = true;
			event = e;
			callCount++;
		}
	}
}