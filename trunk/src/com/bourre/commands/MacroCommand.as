package com.bourre.commands
{
	public interface MacroCommand extends Command
	{
		public function addCommand( oCommand : Command ) : Boolean;
		public function removeCommand( oCommand : Command ) : Boolean;
	}
}