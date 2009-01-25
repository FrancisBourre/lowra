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
	import flash.events.Event;	

	/**
	 * The GraphicLoaderLocatorEvent class represents the event object passed 
	 * to the event listener for <code>GraphicLoaderLocator</code> events.
	 * 
	 * @author 	Francis Bourre
	 * 
	 * @see GraphicLoaderLocator
	 */
	public class GraphicLoaderLocatorEvent extends Event 
	{
		//--------------------------------------------------------------------
		// Events
		//--------------------------------------------------------------------
		
		/**
		 * Defines the value of the <code>type</code> property of the event 
		 * object for a <code>onRegisterGraphicLoader</code> event.
		 * 
		 * <p>The properties of the event object have the following values:</p>
		 * <table class="innertable">
		 *     <tr><th>Property</th><th>Value</th></tr>
		 *     <tr>
		 *     	<td><code>type</code></td>
		 *     	<td>Dispatched event type</td>
		 *     </tr>
		 *     
		 *     <tr><th>Method</th><th>Value</th></tr>
		 *     <tr>
		 *     	<td><code>getName()</code>
		 *     	</td><td>The registration key</td>
		 *     </tr>
		 *     <tr>
		 *     	<td><code>getGraphicLib()</code>
		 *     	</td><td>The Graphic loader object</td>
		 *     </tr>
		 * </table>
		 * 
		 * @eventType onRegisterGraphicLoader
		 */	
		public static const onRegisterGraphicLoaderEVENT 	: String = "onRegisterGraphicLoader";
		
		/**
		 * Defines the value of the <code>type</code> property of the event 
		 * object for a <code>onUnregisterGraphicLoader</code> event.
		 * 
		 * <p>The properties of the event object have the following values:</p>
		 * <table class="innertable">
		 *     <tr><th>Property</th><th>Value</th></tr>
		 *     <tr>
		 *     	<td><code>type</code></td>
		 *     	<td>Dispatched event type</td>
		 *     </tr>
		 *     
		 *     <tr><th>Method</th><th>Value</th></tr>
		 *     <tr>
		 *     	<td><code>getName()</code>
		 *     	</td><td>The registration key</td>
		 *     </tr>
		 *     <tr>
		 *     	<td><code>getGraphicLib()</code>
		 *     	</td><td>The Graphic loader object</td>
		 *     </tr>
		 * </table>
		 * 
		 * @eventType onUnregisterGraphicLoader
		 */	
		public static const onUnregisterGraphicLoaderEVENT 	: String = "onUnregisterGraphicLoader";
		
		
		//--------------------------------------------------------------------
		// Protected properties
		//--------------------------------------------------------------------
		
		/** @private */		
		protected var _sName 	: String;
		
		/** @private */		
		protected var _gl 		: GraphicLoader;
		
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
		
		/**
		 * Creates a new <code>GraphicLoaderLocatorEvent</code> object.
		 * 
		 * @param	type			Name of the event type
		 * @param	name			Registration key
		 * @param	gl				Graphic loader object
		 */	
		public function GraphicLoaderLocatorEvent( type : String, name : String, gl : GraphicLoader ) 
		{
			super( type );
			
			_sName = name;
			_gl = gl;
		}
		
		/**
		 * Returns the registration key carried by this event.
		 * 
		 * @return The registration key carried by this event.
		 */
		public function getName() : String
		{
			return _sName;
		}
		
		/**
		 * Returns the graphic loader object carried by this event.
		 * 
		 * @return The graphic loader object carried by this event.
		 */
		public function getGraphicLib() : GraphicLoader
		{
			return _gl;
		}
	}
}