package com.bourre.plugin
{
	import com.bourre.collection.HashMap;
	import com.bourre.log.PixlibStringifier;
	import com.bourre.events.EventChannel;
	import com.bourre.events.ApplicationBroadcaster;
	
	public class ChannelExpert
	{
		private static var _oI : ChannelExpert;
		private static var _N : uint = 0;
		private var _m : HashMap;
		
		/**
		 * @return singleton instance of ChannelExpert
		 */
		public static function getInstance() : ChannelExpert 
		{
			if (!ChannelExpert._oI) ChannelExpert._oI = new ChannelExpert( new PrivateConstructorAccess() );
			return ChannelExpert._oI;
		}
		
		public function ChannelExpert( access : PrivateConstructorAccess )
		{
			_m = new HashMap();
		}
		
		public function getChannel( o : Object ) : EventChannel
		{
			trace(o,arguments.caller)
			if ( _m.containsKey( ChannelExpert._N ) )
			{
				var channel : EventChannel = _m.get( ChannelExpert._N ) as EventChannel;
				ChannelExpert._N++;
				return channel;
	
			} else
			{
				PluginDebug.getInstance().debug( this + ".getChannel() failed on " + o );
				registerChannel( ApplicationBroadcaster.getInstance().NO_CHANNEL );
				ChannelExpert._N++;
				return ApplicationBroadcaster.getInstance().NO_CHANNEL;
			}
		}
		
		public function registerChannel( channel : EventChannel ) : void
		{
			_m.put( ChannelExpert._N, channel );
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

internal class PrivateConstructorAccess {}