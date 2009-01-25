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
 
package com.bourre.ioc.assembler.channel
{
	import com.bourre.events.ValueObject;
	import com.bourre.log.PixlibStringifier;	

	/**
	 * The ChannelListener class store information about communication channel 
	 * defined in the xml context file.
	 * 
	 * @author Francis Bourre
	 */
	public class ChannelListener implements ValueObject
	{
		//--------------------------------------------------------------------
		// Public properties
		//--------------------------------------------------------------------
		
		/**
		 * Listener identifier.
		 * @default null
		 */		
		public var listenerID : String;

		/**
		 * Event channel name.
		 * @default null
		 */		
		public var channelName : String;

		/**
		 * Arguments list.
		 * @default null
		 */	
		public var arguments : Array;

		
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
		
		/**
		 * Creates instance.
		 * 
		 * @param	listenerID	Identifer of listener.
		 * @param	channelName	Event channel identifer
		 * @param	args		(optional) Arguments list
		 */
		public function ChannelListener( listenerID : String, channelName : String, args : Array = null )
		{
			this.listenerID = listenerID;
			this.channelName = channelName;
			this.arguments = args;
		}

		/**
		 * Returns the string representation of this instance.
		 * @return the string representation of this instance
		 */
		public function toString() : String
		{
			return PixlibStringifier.stringify( this ) + "(" + "listenerID:" + listenerID + ", " + "channelName:" + channelName + ", " + "arguments:[" + arguments + "])";
		}
	}
}