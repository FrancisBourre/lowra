/**
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
package lowra.plugins.utils 
{
	import com.bourre.events.EventChannel;	import com.bourre.log.LogListener;	import com.bourre.log.Logger;	import com.bourre.log.PixlibStringifier;	import com.bourre.plugin.AbstractPlugin;	
		/**
	 * Registers Logging target into Lowra Logging API.
	 * 
	 * <p>This plugin don't activate logging process, it just register different target for it.</p>
	 * 
	 * @author Romain Ecarnot
	 */
	public class LoggerPlugin extends AbstractPlugin
	{
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
		
		/**
		 * Constructor.
		 */
		public function LoggerPlugin(  )
		{
			super( );	
		}

		/**
		 * Registers new Logging target.
		 * 
		 * @param	listener	Logging target to register
		 * @param	channel		Target dedicadted EventChannel
		 */
		public function register( listener : *, channel : EventChannel = null ) : void
		{
			try
			{
				Logger.getInstance( ).addLogListener( listener, channel );
			}
			catch( e : Error )
			{
				Logger.ERROR( this + ":: listener can't be added as Logging target : " + PixlibStringifier.stringify( listener ) );
			}
		}

		/**
		 * Unregisters passed-in Logging target.
		 */
		public function unregister( listener : LogListener ) : void
		{
			Logger.getInstance( ).removeLogListener( listener );
		}

		/**
		 * Removes all Logging targets.
		 */
		public function clear(  ) : void
		{
			Logger.getInstance( ).removeAllListeners( );
		}
	}
}
