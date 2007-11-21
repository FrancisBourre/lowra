package com.bourre.commands 
{
	import com.bourre.events.LoopEvent;

	/**
	 * @author Cédric Néhémie
	 */
	public interface LoopCommandListener extends ASyncCommandListener 
	{
		function onLoopStart( e : LoopEvent ) : void;
	}
}