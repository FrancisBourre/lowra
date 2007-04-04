package com.bourre.events
{
	import com.bourre.log.PixlibStringifier;
	
	public class ApplicationBroadcaster
		extends ChannelBroadcaster
	{
		private static var _oI : ApplicationBroadcaster;
		public const NO_CHANNEL : EventChannel = new NoChannel();
		public const SYSTEM_CHANNEL : EventChannel = new SystemChannel();
		
		/**
		 * @return singleton instance of ApplicationBroadcaster
		 */
		public static function getInstance() : ApplicationBroadcaster 
		{
			if (!_oI) _oI = new ApplicationBroadcaster(new PrivateConstructorAccess());
			return _oI;
		}
		
		public function ApplicationBroadcaster(access : PrivateConstructorAccess)
		{
			super( SYSTEM_CHANNEL );
		}
		
		public override function getChannelDispatcher( channel : EventChannel = null, owner : Object = null ) : EventBroadcaster
		{
			return ( channel != NO_CHANNEL ) ? super.getChannelDispatcher( channel, owner ) : null;
		}
	}
}

import com.bourre.events.EventChannel;

internal class NoChannel 
	extends EventChannel
{
	public function NoChannel()
	{

	}
}

internal class SystemChannel 
	extends EventChannel
{
	public function SystemChannel()
	{
	}
}

internal class PrivateConstructorAccess {}