package com.bourre.events
{
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
	
	/**
	 * @author Francis Bourre
	 * @author Romain Flacher
	 * @version 1.0
	 */

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
			if ( !(ApplicationBroadcaster._oI is ApplicationBroadcaster) ) 
				ApplicationBroadcaster._oI = new ApplicationBroadcaster( new PrivateConstructorAccess() );
				
			return ApplicationBroadcaster._oI;
		}
		
		public function ApplicationBroadcaster( access : PrivateConstructorAccess )
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

internal class NoChannel extends EventChannel{};
internal class SystemChannel extends EventChannel{};

internal class PrivateConstructorAccess {};