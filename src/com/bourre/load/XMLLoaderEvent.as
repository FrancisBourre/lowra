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

	/**
	 * The XMLLoaderEvent class represents the event object passed 
	 * to the event listener for <code>XMLLoader</code> events.
	 * 
	 * @author 	Francis Bourre
	 * 
	 * @see XMLLoader
	 */
	public class XMLLoaderEvent extends LoaderEvent
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
		 *     	<td><code>getXMLLoader()</code>
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
		 *     	<td><code>getXMLLoader()</code>
		 *     	</td><td>The loader object</td>
		 *     </tr>
		 *     <tr>
		 *     	<td><code>getXML()</code>
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
		 *     	<td><code>getXMLLoader()</code>
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
		 *     	<td><code>getXMLLoader()</code>
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
		 *     	<td><code>getFileLoader()</code>
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
		 * Creates a new <code>XMLLoaderEvent</code> object.
		 * 
		 * @param	type			Name of the event type
		 * @param	xl				XMLLoader object carried by this event
		 * @param	errorMessage	(optional) Error message carried by this event
		 */
		public function XMLLoaderEvent( type : String, xl : XMLLoader, errorMessage : String = "" )
		{
			super( type, xl, errorMessage );
		}
		
		/**
		 * Returns the xml file loader object carried by this event.
		 * 
		 * @return	The xml file loader value carried by this event.
		 */
		public function getXMLLoader() : XMLLoader
		{
			return getLoader( ) as XMLLoader;
		}
		
		/**
		 * Returns the file content object carried by this event.
		 * 
		 * @return	The file content value carried by this event.
		 */
		public function getXML() : XML
		{
			return getXMLLoader( ).getXML( );
		}
	}
}