package com.bourre.commands
{
	import flash.events.Event;
	
	public interface ASyncCommandSequencerListener extends ASyncCommandListener
	{
		function onCommandTimeout ( e : ASyncCommandEvent ) : void;
	}
}