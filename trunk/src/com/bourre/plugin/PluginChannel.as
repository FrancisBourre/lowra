package com.bourre.plugin
{
	import com.bourre.events.EventChannel;
	
	public class PluginChannel
		extends EventChannel
	{
		public function PluginChannel( channelName : String )
		{
			super( channelName );
		}
	}
}