package com.bourre.transitions
{
	import com.bourre.commands.ASyncCommand;
	
	public interface IBasicTween 
		extends ASyncCommand
	{
		public function setEasing( f : Function ) : void;
		public function start() :void;
		public function stop() :void;
	}
}