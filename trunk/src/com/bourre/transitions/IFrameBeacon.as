package com.bourre.transitions
{
	public interface IFrameBeacon
	{
		function addFrameListener ( o : IFrameListener ) : void;
		function removeFrameListener ( o : IFrameListener ) : void;
		function start () : void;
		function stop () : void;
		function isPlaying () : Boolean;
	}
}