package com.bourre.commands
{
	import flash.events.Event;

	public class MockFailureASyncCommand extends AbstractSyncCommand implements ASyncCommand
	{
		public function MockFailureASyncCommand ()
		{
			super( abstractConstructorAccess );
		}
		public override function execute(e:Event=null):void
		{
		}
	}
}