package com.bourre.transitions
{
	import com.bourre.commands.ISyncCommand;
	
	public interface IBasicTween extends ISyncCommand
	{
		public function setEasing(f:Function) : Void;
		public function start() :Void;
		public function stop() :Void;
	}
}