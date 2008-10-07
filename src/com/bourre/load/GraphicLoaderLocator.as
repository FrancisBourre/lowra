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
package com.bourre.load
{
	import com.bourre.core.AbstractLocator;
	
	import flash.system.ApplicationDomain;	
	
	/**
	 * @author Francis Bourre
	 * @version 1.0
	 */
	public class GraphicLoaderLocator 
		extends AbstractLocator
	{
		private static var _oI : GraphicLoaderLocator = null;

		public function GraphicLoaderLocator( o : ConstructorAccess )
		{
			super( GraphicLoader, GraphicLoaderLocatorListener );
		}

		public static function getInstance() : GraphicLoaderLocator
		{
			if ( !(GraphicLoaderLocator._oI is GraphicLoaderLocator) ) GraphicLoaderLocator._oI = new GraphicLoaderLocator( new ConstructorAccess() );
			return GraphicLoaderLocator._oI;
		}

		public static function release():void
		{
			if ( GraphicLoaderLocator._oI is GraphicLoaderLocator ) GraphicLoaderLocator._oI = null;
		}

		override protected function onRegister( name : String = null, o : Object = null ) : void
		{
			broadcastEvent( new GraphicLoaderLocatorEvent( GraphicLoaderLocatorEvent.onRegisterGraphicLoaderEVENT, name, o as GraphicLoader ) );
		}

		override protected function onUnregister( name : String = null ) : void
		{
			broadcastEvent( new GraphicLoaderLocatorEvent( GraphicLoaderLocatorEvent.onUnregisterGraphicLoaderEVENT, name, null ) );
		} 

		public function getGraphicLoader( name : String ) : GraphicLoader
		{
			try
			{
				var gl : GraphicLoader = locate( name ) as GraphicLoader;
				return gl;

			} catch ( e : Error )
			{
				throw( e );
			}

			return null;
		}

		public function getApplicationDomain( name : String ) : ApplicationDomain
		{
			return getGraphicLoader( name ).getApplicationDomain();
		}

		public function addListener( listener : GraphicLoaderLocatorListener ) : Boolean
		{
			return getBroadcaster().addListener( listener );
		}

		public function removeListener( listener : GraphicLoaderLocatorListener ) : Boolean
		{
			return getBroadcaster().removeListener( listener );
		}
	}
}

internal class ConstructorAccess {}