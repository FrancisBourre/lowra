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
	import com.bourre.error.PrivateConstructorException;
	
	import flash.system.ApplicationDomain;		
	
	/**
	 *  Dispatched when graphic loader is registered in 
	 *  <code>GraphicLoaderLocator</code> locator.
	 *  
	 *  @eventType com.bourre.load.GraphicLoaderLocatorEvent.onRegisterGraphicLoaderEVENT
	 */
	[Event(name="onRegisterGraphicLoader", type="com.bourre.load.GraphicLoaderLocatorEvent")]
	
	/**
	 *  Dispatched when graphic loader is unregistered from 
	 *  <code>GraphicLoaderLocator</code> locator.
	 *  
	 *  @eventType com.bourre.load.GraphicLoaderLocatorEvent.onUnregisterGraphicLoaderEVENT
	 */
	[Event(name="onUnregisterGraphicLoader", type="com.bourre.load.GraphicLoaderLocatorEvent")]
	
	/**
	 * The GraphicLoaderLoacator store and register 
	 * <code>GraphicLoader</code> objects.
	 * 
	 * @example 
	 * <pre class="prettyprint">
	 * 
	 * public function loadFile( ) : void
	 * {
	 * 	var loader : GraphicLoader = new GraphicLoader( );
	 * 	loader.setName( "MyLogo" );
	 * 	loader.load( new URLRequest( "logo.jpg" );
	 * }
	 * 
	 * public function anotherFunction( ) :void
	 * {
	 * 	var logo : DisplayObject = GraphicLoaderLocator.getInstance().getGraphicLoader( "MyLogo" ).getView();
	 * }
	 * </pre>
	 * 
	 * @author 	Francis Bourre
	 * 
	 * @see GraphicLoader
	 */
	public class GraphicLoaderLocator extends AbstractLocator
	{
		//--------------------------------------------------------------------
		// Private properties
		//--------------------------------------------------------------------
				
		private static var _oI : GraphicLoaderLocator = null;
		
		
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
		
		/**
		 * Returns unique <code>GraphicLoaderLocator</code>.
		 * 
		 * @return the unique <code>GraphicLoaderLocator</code>.
		 */		
		public static function getInstance() : GraphicLoaderLocator
		{
			if ( !(GraphicLoaderLocator._oI is GraphicLoaderLocator) ) GraphicLoaderLocator._oI = new GraphicLoaderLocator( new ConstructorAccess() );
			return GraphicLoaderLocator._oI;
		}
		
		/**
		 * Releases instance.
		 */
		public static function release():void
		{
			if ( GraphicLoaderLocator._oI is GraphicLoaderLocator ) GraphicLoaderLocator._oI = null;
		}
		
		/**
		 * Dispatches <code>GraphicLoaderLocatorEvent</code> event using passed-in 
		 * arguments as event properties when a <code>GraphicLoader</code> is 
		 * registered in locator.
		 * 
		 * <p>Event type is <code>GraphicLoaderLocatorEvent.onRegisterGraphicLoaderEVENT</code></p>
		 * 
		 * @param	name	Name of the registered <code>GraphicLoader</code>
		 * @param	o		The registered <code>GraphicLoader</code>
		 * 
		 * @see GraphicLoader		 * @see GraphicLoaderLocatorEvent
		 * @see GraphicLoaderLocatorEvent#onRegisterGraphicLoaderEVENT
		 */
		override protected function onRegister( name : String = null, o : Object = null ) : void
		{
			broadcastEvent( new GraphicLoaderLocatorEvent( GraphicLoaderLocatorEvent.onRegisterGraphicLoaderEVENT, name, o as GraphicLoader ) );
		}
		
		/**
		 * Dispatches <code>GraphicLoaderLocatorEvent</code> event using passed-in 
		 * arguments as event properties when a <code>GraphicLoader</code> is 
		 * unregistered from locator.
		 * 
		 * <p>Event type is <code>GraphicLoaderLocatorEvent.onUnregisterGraphicLoaderEVENT</code></p>
		 * 
		 * @param	name	Name of the registredred <code>GraphicLoader</code>
		 * @param	o		The registered <code>GraphicLoader</code>
		 * 
		 * @see GraphicLoader
		 * @see GraphicLoaderLocatorEvent		 * @see GraphicLoaderLocatorEvent#onUnregisterGraphicLoaderEVENT
		 */
		override protected function onUnregister( name : String = null ) : void
		{
			broadcastEvent( new GraphicLoaderLocatorEvent( GraphicLoaderLocatorEvent.onUnregisterGraphicLoaderEVENT, name, null ) );
		} 
		
		/**
		 * Returns <code>GraphicLoader</code> object registered with passed-in 
		 * name identifier.
		 * 
		 * @return <code>GraphicLoader</code> object registered with passed-in 
		 * name identifier.
		 * 
		 * @throws 	<code>Error</code> — name is not registered in current 
		 * 			locator
		 */
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
		
		/**
		 * Returns the <code>applicationDomain</code> of loaded display object.
		 * 
		 * @return The <code>applicationDomain</code> of loaded display object.
		 */
		public function getApplicationDomain( name : String ) : ApplicationDomain
		{
			return getGraphicLoader( name ).getApplicationDomain();
		}
		
		/**
		 * @copy com.bourre.events.Broadcaster#addListener()
		 */
		public function addListener( listener : GraphicLoaderLocatorListener ) : Boolean
		{
			return getBroadcaster().addListener( listener );
		}
		
		/**
		 * @copy com.bourre.events.Broadcaster#removeListener()
		 */
		public function removeListener( listener : GraphicLoaderLocatorListener ) : Boolean
		{
			return getBroadcaster().removeListener( listener );
		}
		
		
		//--------------------------------------------------------------------
		// Private implementation
		//--------------------------------------------------------------------
		
		/** private */
		function GraphicLoaderLocator( access : ConstructorAccess )
		{
			super( GraphicLoader, GraphicLoaderLocatorListener );
			
			if ( !(access is ConstructorAccess) ) throw new PrivateConstructorException();
		}		
	}
}

internal class ConstructorAccess {}