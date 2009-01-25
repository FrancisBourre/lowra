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
package com.bourre.events 
{
	import com.bourre.error.IllegalArgumentException;
	import com.bourre.log.PixlibDebug;
	
	import flash.utils.getQualifiedClassName;	

	/**
	 * An <code>EventChannel</code> object defines a communication
	 * channel in the <code>ChannelBroadcaster</code>. 
	 * 
	 * @author 	Francis Bourre
	 * @see		ChannelBroadcaster
	 */
	public class EventChannel 
	{
		private var _sChannelName : String;

		/**
		 * Creates a new event channel with the passed-in channel name.
		 * <p>
		 * Several channel can have the same name, as the channel broadcaster
		 * use the instance of the class as key.
		 * </p>
		 * @param	channelName	name of this channel
		 */
		public function EventChannel( channelName : String = null )
		{
			_sChannelName =  channelName ? channelName : getQualifiedClassName( this );

			if ( _sChannelName == "EventChannel" )
			{
			 	var msg : String = "EventChannel must have a name, or be extended by another class";
			 	PixlibDebug.ERROR( msg );
			 	throw new IllegalArgumentException( msg );
			}
		}

		/**
		 * Returns the string representation of this object.
		 * 
		 * @return	the string representation of this object.
		 */
		public function toString() : String
		{
			return _sChannelName;
		}
	}
}