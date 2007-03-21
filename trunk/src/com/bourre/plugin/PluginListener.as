package com.bourre.plugin
{
	import flash.events.Event;
	
	public interface PluginListener
	{
		function onInitPlugin( e : Event ) : void;
		function onDestroyPlugin( e : Event ) : void;
	}
}