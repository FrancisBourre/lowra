package com.bourre.commands {

	public interface ASyncCommandSequencerListener extends ASyncCommandListener
	{
		function onCommandTimeout ( e : ASyncCommandEvent ) : void;
	}
}