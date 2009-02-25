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
 
package com.bourre.ioc.assembler.plugins
{
	import com.bourre.commands.Batch;
	import com.bourre.core.AbstractLocator;
	import com.bourre.error.PrivateConstructorException;
	import com.bourre.log.PixlibDebug;
	import com.bourre.plugin.Plugin;		

	/**
	 * The PluginExpert class is a locator for 
	 * <code>Plugin</code> object.
	 * 
	 * @author Romain Ecarnot
	 */
	public class PluginExpert extends AbstractLocator
	{
		//--------------------------------------------------------------------
		// Private properties
		//--------------------------------------------------------------------
				
		private static var _oI : PluginExpert;
		
		
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
		
		/**
		 * Returns unique instance of PluginExpert class.
		 */
		public static function getInstance() : PluginExpert 
		{
			if ( !(PluginExpert._oI is PluginExpert) ) 
				PluginExpert._oI = new PluginExpert( new ConstructorAccess() );

			return PluginExpert._oI;
		}
		
		/**
		 * Release instance.
		 */
		public static  function release() : void
		{
			_oI.release();			PluginExpert._oI = null;
		}
		
		/**
		 * Notifies all registered plugins that IoC process 
		 * is finished.
		 * 
		 * <p>Batch processing throw all registered plugins></p>
		 * 
		 * <p>Locator is release after process.</p>
		 * 
		 * @see #notifyPlugin()
		 */
		public function notifyAllPlugins(  ) : void
		{
			Batch.process( notifyPlugin, getKeys() );
			
			PluginExpert.getInstance().release();
		}
		
		/**
		 * Notifies registered plugins that IoC process 
		 * is finished.
		 */
		public function notifyPlugin( id : String ) : void
		{
			if ( isRegistered( id ) )
			{
				var plugin : Plugin = locate( id ) as Plugin;
				
				try
				{
					plugin.onApplicationInit();
				}
				catch( e : Error )
				{
					PixlibDebug.ERROR( this + "<" + plugin + "> can't be notified : " + e.message );
				}
				finally
				{
					unregister( id );
				}
			}
		}
		
		
		//--------------------------------------------------------------------
		// Private implementation
		//--------------------------------------------------------------------
		
		/** @private */
		function PluginExpert( access : ConstructorAccess )
		{
			super( Plugin, null, null );
			
			if ( !(access is ConstructorAccess) ) throw new PrivateConstructorException();
		}
				
	}
}

internal class ConstructorAccess {}