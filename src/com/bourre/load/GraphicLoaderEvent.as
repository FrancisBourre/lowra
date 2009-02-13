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
	import flash.display.DisplayObjectContainer;
	import flash.system.ApplicationDomain;	
	
	/**
	 * The GraphicLoaderEvent class represents the event object passed 
	 * to the event listener for <code>GraphicLoader</code> events.
	 * 
	 * @author 	Francis Bourre
	 * 
	 * @see GraphicLoader
	 */
	public class GraphicLoaderEvent extends LoaderEvent
	{
		//--------------------------------------------------------------------
		// Events
		//--------------------------------------------------------------------
		
		/**
		 * Defines the value of the <code>type</code> property of the event 
		 * object for a <code>onLoadStart</code> event.
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
		 *     	<td><code>getGraphicLoader()</code>
		 *     	</td><td>The loader object</td>
		 *     </tr>
		 * </table>
		 * 
		 * @eventType onLoadStart
		 */				
		public static const onLoadStartEVENT : String = LoaderEvent.onLoadStartEVENT;

		/**
		 * Defines the value of the <code>type</code> property of the event 
		 * object for a <code>onLoadInit</code> event.
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
		 *     	<td><code>getGraphicLoader()</code>
		 *     	</td><td>The loader object</td>
		 *     </tr>
		 *     <tr>
		 *     	<td><code>getView()</code>
		 *     	</td><td>The loaded file content</td>
		 *     </tr>
		 * </table>
		 * 
		 * @eventType onLoadInit
		 */
		public static const onLoadInitEVENT : String = LoaderEvent.onLoadInitEVENT;

		/**
		 * Defines the value of the <code>type</code> property of the event 
		 * object for a <code>onLoadProgress</code> event.
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
		 *     	<td><code>getGraphicLoader()</code>
		 *     	</td><td>The loader object</td>
		 *     </tr>
		 * </table>
		 * 
		 * @eventType onLoadProgress
		 */
		public static const onLoadProgressEVENT : String = LoaderEvent.onLoadProgressEVENT;

		/**
		 * Defines the value of the <code>type</code> property of the event 
		 * object for a <code>onLoadTimeOut</code> event.
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
		 *     	<td><code>getGraphicLoader()</code>
		 *     	</td><td>The loader object</td>
		 *     </tr>
		 * </table>
		 * 
		 * @eventType onLoadTimeOut
		 */
		public static const onLoadTimeOutEVENT : String = LoaderEvent.onLoadTimeOutEVENT;

		/**
		 * Defines the value of the <code>type</code> property of the event 
		 * object for a <code>onLoadError</code> event.
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
		 *     	<td><code>getGraphicLoader()</code>
		 *     	</td><td>The loader object</td>
		 *     </tr>
		 * </table>
		 * 
		 * @eventType onLoadError
		 */
		public static const onLoadErrorEVENT : String = LoaderEvent.onLoadErrorEVENT;
		
		
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
		
		/**
		 * Creates a new <code>GraphicLoaderEvent</code> object.
		 * 
		 * @param	type			Name of the event type
		 * @param	gl				GraphicLoader object carried by this event
		 * @param	errorMessage	(optional) Error message carried by this event
		 */		
		public function GraphicLoaderEvent( type : String, gl : GraphicLoader, errorMessage : String = "" )
		{
			super( type, gl, errorMessage );
		}
		
		/**
		 * Returns the display object carried by this event.
		 * 
		 * @return	The display object carried by this event.
		 */
		public function getView() : DisplayObjectContainer
		{
			return getGraphicLoader().getView();
		}
		
		/**
		 * Returns the graphic loader object carried by this event.
		 * 
		 * @return	The graphic loader value carried by this event.
		 */
		public function getGraphicLoader() : GraphicLoader
		{
			return getLoader() as GraphicLoader;
		}
		
		/**
		 * Returns the <code>applicationDomain</code> of loaded display object.
		 * 
		 * @return The <code>applicationDomain</code> of loaded display object.
		 */
		public function getApplicationDomain() : ApplicationDomain
		{
			return getGraphicLoader().getApplicationDomain();
		}
	}
}