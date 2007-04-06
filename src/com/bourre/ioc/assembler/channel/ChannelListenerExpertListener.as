package com.bourre.ioc.assembler.channel
{
	import com.bourre.ioc.assembler.channel.ChannelListenerEvent ;
	
	public interface ChannelListenerExpertListener
	{
		function onBuildChannelListener (e : ChannelListenerEvent):void ;
	}
}