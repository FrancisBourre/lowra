package com.bourre.commands
{
	import flash.events.Event;

	public class MockASyncCommandSequencerListener 
		implements ASyncCommandSequencerListener
	{
		public var commandEndCalled : Boolean;
		public var commandTimeoutCalled : Boolean;
		
		public function onCommandEnd( e : ASyncCommandEvent ) : void
		{
			commandEndCalled = true;
		}
		
		public function onCommandTimeout( e : ASyncCommandEvent ) : void
		{
			commandTimeoutCalled = true;
		}
		
	}
}