package com.bourre.transitions
{
	import com.bourre.commands.ASyncCommand;
	
	public interface BasicTween 
		extends ASyncCommand
	{
		function setEasing( f : Function ) : void;
		function start() : void;
		function stop() : void;
	}
}