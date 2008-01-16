package com.bourre.commands
{
	import flash.events.Event;
	import flash.utils.describeType;

	public class MockAbstractSyncCommand extends AbstractSyncCommand implements ASyncCommand
	{
		public function isRegistered ( o : ASyncCommandListener ) : Boolean
		{
			return _oEB.isRegistered( o,  AbstractSyncCommand.onCommandEndEVENT );
		}
		 
		public override function execute( e : Event = null ) : void
		{
			fireCommandEndEvent();
		}
	}
}