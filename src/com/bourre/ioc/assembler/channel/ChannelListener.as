package com.bourre.ioc.assembler.channel
{
	public class ChannelListener
	{
		public var _sListenerID : String;
		public var _sChannel : String;
		
		public function ChannelListener(listenerID:String, channel:String)
		{
			_sListenerID = listenerID ;
			_sChannel = channel ;
		}
		
	}
}