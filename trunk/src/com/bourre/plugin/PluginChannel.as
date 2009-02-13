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
 
package com.bourre.plugin
{
	import com.bourre.collection.HashMap;
	import com.bourre.error.PrivateConstructorException;
	import com.bourre.events.EventChannel;	

	/**
	 * The PluginChannel class defines event channel for a target plugin.
	 * 
	 * <p>Each plugin has only one event channel.</p>
	 * 
	 * @author 	Francis Bourre
	 */
	public class PluginChannel extends EventChannel
	{
		//--------------------------------------------------------------------
		// Private properties
		//--------------------------------------------------------------------

		private static var _M : HashMap = new HashMap( );

		
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
		
		/**
		 * Returns a <code>PluginChannel</code> registered with passed-in name.
		 * 
		 * <p>If channel not exist, it will be created and register using name 
		 * argument.</p>
		 * 
		 * @param	channelName	Name of the event channel to retreive or 
		 * 			to create.
		 * 			
		 * 	@return Plugin channel with channelName name.
		 */	
		public static function getInstance( channelName : String ) : PluginChannel
		{
			if ( !(PluginChannel._M.containsKey( channelName )) )
				PluginChannel._M.put( channelName, new PluginChannel( new ConstructorAccess( ), channelName ) );
				
			return PluginChannel._M.get( channelName ) as PluginChannel;
		}

		
		//--------------------------------------------------------------------
		// Private implementation
		//--------------------------------------------------------------------
		
		/**
		 * @private
		 */
		public function PluginChannel( access : ConstructorAccess, channelName : String )
		{
			super( channelName );
			
			if ( !(access is ConstructorAccess) ) throw new PrivateConstructorException( );
		}		
	}
}

internal class ConstructorAccess
{
}