package com.bourre.commands
{
	public interface ISyncCommand extends Command
	{
		public function addListener( o : ISyncCommandListener ) : void;
		public function removeListener( o : ISyncCommandListener ) : void;
		public function fireCommandEndEvent() : void;
	}
}