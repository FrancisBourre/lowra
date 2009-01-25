/*
 * Copyright the original author or authors.
 * 
 * Licensed under the MOZILLA PUBLIC LICENSE, Version 1.1 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *      http://www.mozilla.org/MPL/MPL-1.1.html
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
 
package com.bourre.remoting 
{
	import com.bourre.error.PrivateConstructorException;
	import com.bourre.events.EventChannel;
	import com.bourre.log.LogLevel;
	import com.bourre.log.Logger;	

	/**
	 * The RemotingDebug class.
	 * 
	 * <p>TODO Documentation.</p>
	 * 
	 * @author 	Romain Flacher
	 */
	public class RemotingDebug 
	{
		public static var isOn : Boolean = true;
		public static var _CHANNEL : EventChannel ;
		
		public function RemotingDebug( access : PrivateConstructorAccess ) 
		{
			if ( !(access is PrivateConstructorAccess) ) throw new PrivateConstructorException();
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