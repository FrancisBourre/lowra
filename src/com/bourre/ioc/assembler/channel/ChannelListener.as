package com.bourre.ioc.assembler.channel
{
	import com.bourre.log.*;
	
	public class ChannelListener
	{
		public var listenerID : String;
		public var channel : String;
		
		public function ChannelListener( listenerID : String, channel : String )
		{
			this.listenerID = listenerID ;
			this.channel = channel ;
		}
		
		/**
		 * Returns the string representation of this instance.
		 * @return the string representation of this instance
		 */
		public function toString() : String 
		{
			return PixlibStringifier.stringify( this );
		}
	}
}