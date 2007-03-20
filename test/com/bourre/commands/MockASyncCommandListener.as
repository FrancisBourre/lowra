package com.bourre.commands
{
	import flash.events.Event;

	public class MockASyncCommandListener implements ASyncCommandListener
	{
		public var called : Boolean;
		
		public function onCommandEnd( e : ASyncCommandEvent ) : void
		{
			called = true;
		}
		
	}
}