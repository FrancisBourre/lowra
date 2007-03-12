package com.bourre.commands
{
	public interface MacroCommand extends Command
	{
		public function addCommand( oCommand : Command ) : void;
		public function removeCommand( oCommand : Command ) : void;
	}
}