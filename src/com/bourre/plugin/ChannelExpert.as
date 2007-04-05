package com.bourre.plugin
{
	import com.bourre.collection.HashMap;
	import com.bourre.log.PixlibStringifier;
	import com.bourre.events.EventChannel;
	import com.bourre.events.ApplicationBroadcaster;
	import flash.utils.Dictionary;
	
	public class ChannelExpert
	{
		private static var _oI : ChannelExpert;
		private static var _N : uint = 0;
		private var _m : HashMap;
		private var _oRegistred : Dictionary
		
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
			_oRegistred = new Dictionary(true)
		}
		
		public function getChannel( o : Object ) : EventChannel
		{
			if(_oRegistred[o]==null)
			{
				if ( _m.containsKey( ChannelExpert._N) )
				{
					var channel : EventChannel = _m.get( ChannelExpert._N ) as EventChannel;
					_oRegistred[o] = channel
					ChannelExpert._N++;
					return channel;
		
				} else
				{
					PluginDebug.getInstance().debug( this + ".getChannel() failed on " + o );
					_oRegistred[o] = ApplicationBroadcaster.getInstance().NO_CHANNEL
					return ApplicationBroadcaster.getInstance().NO_CHANNEL;
				}
			}
			else
			{
				 return _oRegistred[o] as EventChannel;
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