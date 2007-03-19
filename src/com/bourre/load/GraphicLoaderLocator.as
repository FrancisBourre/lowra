package com.bourre.load
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
	 * @version 1.0
	 */

	import com.bourre.collection.HashMap;
	import com.bourre.core.Locator;
	import com.bourre.events.EventBroadcaster;
	import com.bourre.log.*;
	
	public class GraphicLoaderLocator 
		implements Locator
	{
		private static var _oI : GraphicLoaderLocator = null;

		private var _m : HashMap;
		private var _oEB : EventBroadcaster;
	
		public function GraphicLoaderLocator( o : ConstructorAccess )
		{
			_m = new HashMap();
			_oEB = new EventBroadcaster( this );
		}
		
		public static function getInstance() : GraphicLoaderLocator
		{
			if ( !(GraphicLoaderLocator._oI is GraphicLoaderLocator) ) GraphicLoaderLocator._oI = new GraphicLoaderLocator( new ConstructorAccess() );
			return GraphicLoaderLocator._oI;
		}
		
		public function isRegistered( name : String ) : Boolean
		{
			return _m.containsKey( name );
		}
		
		public function register( name : String, gl : GraphicLoader ) : Boolean
		{
			if ( _m.containsKey( name ) )
			{
				PixlibDebug.ERROR( "GraphicLoader instance is already registered with '" + name + "' name in " + this );
				return false;
			} else
			{
				_m.put( name, gl );
				_oEB.broadcastEvent( new GraphicLoaderLocatorEvent( GraphicLoaderLocatorEvent.onRegisterGraphicLoaderEVENT, name, gl ) );
				return true;
			}
		}
		
		public function unregister( name : String ) : Boolean
		{
			if ( isRegistered( name ) )
			{
				_m.remove( name );
				_oEB.broadcastEvent( new GraphicLoaderLocatorEvent( GraphicLoaderLocatorEvent.onUnregisterGraphicLoaderEVENT, name, null ) );
				return true;
				
			} else
			{
				return false;
			}
		}
		
		public function locate( name : String ) : Object
		{
			if ( isRegistered( name ) ) 
			{
				return _m.get( name );
				
			} else
			{
				PixlibDebug.FATAL( "Can't find GraphicLoader instance with '" + name + "' name in " + this );
				return null;
			}
		}
		
		public function getGraphicLoader( name : String ) : GraphicLoader
		{
			return locate( name ) as GraphicLoader;
		}
		
		public function addListener( oL : GraphicLoaderLocatorListener ) : void
		{
			_oEB.addListener( oL );
		}
		
		public function removeListener( oL : GraphicLoaderLocatorListener ) : void
		{
			_oEB.removeListener( oL );
		}
		
		public function addEventListener( e : String, listener : Object, f : Function ) : void
		{
			_oEB.addEventListener.apply( _oEB, arguments );
		}
		
		public function removeEventListener( e : String, listener : Object ) : void
		{
			_oEB.removeEventListener( e, listener );
		}
		
		/**
		 * Returns the string representation of this instance.
		 * @return the string representation of this instance
		 */
		public function toString() : String 
		{
			return PixlibStringifier.stringify( this );
		}
	}
}

internal class ConstructorAccess {}