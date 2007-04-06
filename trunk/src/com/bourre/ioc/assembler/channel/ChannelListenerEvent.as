package com.bourre.ioc.assembler.channel
{
	import com.bourre.events.BasicEvent;
	import com.bourre.log.PixlibStringifier;

	public class ChannelListenerEvent extends BasicEvent
	{
		public static var onBuildChannelListenerEVENT : String = "onBuildChannelListener" ;
		private var _oChannelListener : ChannelListener;
		
		public function ChannelListenerEvent(channelListener : ChannelListener)
		{
			super (ChannelListenerEvent.onBuildChannelListenerEVENT);
			
			_oChannelListener = channelListener ;
		}
		
		public function getChannelListener () : ChannelListener
		{
			return _oChannelListener ;
		}
		
		/**
		 * Returns the string representation of this instance.
		 * @return the string representation of this instance
		 */
		public override function toString() : String 
		{
			return PixlibStringifier.stringify( this );
		}
	}
}