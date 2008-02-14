package com.bourre.events 
{
	import flash.events.Event;						

	public interface ArgumentCallbackFactory 
	{
		function getArguments( e : Event ) : Array;	}}