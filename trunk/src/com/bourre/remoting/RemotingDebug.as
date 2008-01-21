package com.bourre.remoting {
	import com.bourre.events.EventChannel;
	import com.bourre.log.LogLevel;
	import com.bourre.log.Logger;
	
	import flash.utils.getQualifiedClassName;	
	
	/**
	 * @author romain
	 */
	public class RemotingDebug {
		
		public static var isOn : Boolean = true;
		public static var _CHANNEL : EventChannel ;
		
		public function RemotingDebug( access : PrivateConstructorAccess ) 
		{
		}
		
		public static function get CHANNEL() : EventChannel
		{
			if ( !RemotingDebug._CHANNEL ) RemotingDebug._CHANNEL = new RemotingDebugChannel();
			return RemotingDebug._CHANNEL;
		}
		
		public static function DEBUG( o : * ) : void
		{
			if (RemotingDebug.isOn) Logger.LOG(o, LogLevel.DEBUG, RemotingDebug.CHANNEL );
		}
		
		public static function INFO( o : *) : void
		{
			if (RemotingDebug.isOn) Logger.LOG( o, LogLevel.INFO, RemotingDebug.CHANNEL );
		}
		
		public static function WARN( o : *) : void
		{
			if (RemotingDebug.isOn) Logger.LOG( o, LogLevel.WARN, RemotingDebug.CHANNEL );
		}
		
		public static function ERROR( o : *) : void
		{
			if (RemotingDebug.isOn) Logger.LOG( o, LogLevel.ERROR, RemotingDebug.CHANNEL );
		}
		
		public static function FATAL( o : *) : void
		{
			if (RemotingDebug.isOn) Logger.LOG( o, LogLevel.FATAL, RemotingDebug.CHANNEL );
		}
	}
}

import com.bourre.events.EventChannel;
internal class PrivateConstructorAccess {}  
internal class RemotingDebugChannel extends EventChannel {} 