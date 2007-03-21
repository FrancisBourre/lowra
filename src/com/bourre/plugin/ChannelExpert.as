package com.bourre.plugin
{
	import com.bourre.collection.HashMap;
	import com.bourre.log.PixlibStringifier;
	import com.bourre.events.EventChannel;
	import com.bourre.events.ApplicationBroadcaster;
	
	public class ChannelExpert
	{
		private static var _oI : ChannelExpert;
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
			if ( _m.containsKey( o ) )
			{
				return _m.get( o ) as EventChannel;
	
			} else
			{
				PluginDebug.getInstance().debug( this + ".getChannel() failed on " + o );
				registerChannel( o, ApplicationBroadcaster.NO_CHANNEL );
				return null;
			}
		}
		
		public function registerChannel( target : Object, channel : EventChannel ) : void
		{
			_m.put( target, channel );
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