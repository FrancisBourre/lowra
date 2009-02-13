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
package com.bourre.ioc.assembler.displayobject 
{
	import com.bourre.load.Loader;
	import com.bourre.load.LoaderEvent;
	import com.bourre.load.QueueLoaderEvent;	
	
	/**
	 * The DisplayObjectBuilderEvent class represents the event object passed 
	 * to the event listener for <strong>DisplayObjectBuilder</strong> events.
	 * 
	 * @author Francis Bourre
	 * 
	 * @see DisplayObjectBuilder
	 */
	public class DisplayObjectBuilderEvent extends LoaderEvent
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
	     *     	<td><code>getLoader()</code>
	     *     	</td><td>The loader object</td>
	     *     </tr>
	     *     <tr>
	     *     	<td><code>getName()</code>
	     *     	</td><td>The loader identifier</td>
	     *     </tr>
	     * </table>
	     * 
		 * @eventType onLoadStart
		 */	
		public static const onLoadStartEVENT : String = QueueLoaderEvent.onLoadStartEVENT;
		
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
	     *     	<td><code>getLoader()</code>
	     *     	</td><td>The loader object</td>
	     *     </tr>
	     *     <tr>
	     *     	<td><code>getName()</code>
	     *     	</td><td>The loader identifier</td>
	     *     </tr>
	     * </table>
	     * 
		 * @eventType onLoadInit
		 */
		public static const onLoadInitEVENT	: String = QueueLoaderEvent.onLoadInitEVENT; 
		
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
	     *     	<td><code>getLoader()</code>
	     *     	</td><td>The loader object</td>
	     *     </tr>
	     *     <tr>
	     *     	<td><code>getName()</code>
	     *     	</td><td>The loader identifier</td>
	     *     </tr>
	     *     <tr>
	     *     	<td><code>getPercent()</code>
	     *     	</td><td>The loading progression</td>
	     *     </tr>
	     * </table>
	     * 
		 * @eventType onLoadProgress
		 */
		public static const onLoadProgressEVENT	: String = QueueLoaderEvent.onLoadProgressEVENT; 
		
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
	     *     	<td><code>getLoader()</code>
	     *     	</td><td>The loader object</td>
	     *     </tr>
	     *     <tr>
	     *     	<td><code>getName()</code>
	     *     	</td><td>The loader identifier</td>
	     *     </tr>
	     * </table>
	     * 
		 * @eventType onLoadTimeOut
		 */
		public static const onLoadTimeOutEVENT : String = QueueLoaderEvent.onLoadTimeOutEVENT;
		
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
	     *     	<td><code>getLoader()</code>
	     *     	</td><td>The loader object</td>
	     *     </tr>
	     *     <tr>
	     *     	<td><code>getName()</code>
	     *     	</td><td>The loader identifier</td>
	     *     </tr>
	     *     <tr>
	     *     	<td><code>getErrorMessage()</code>
	     *     	</td><td>The loader identifier</td>
	     *     </tr>
	     * </table>
	     * 
		 * @eventType onLoadError
		 */
		public static const onLoadErrorEVENT : String = QueueLoaderEvent.onLoadErrorEVENT;

		/**
		 * Defines the value of the <code>type</code> property of the event 
		 * object for a <code>onDisplayObjectBuilderLoadStart</code> event.
		 * 
		 * <p>The properties of the event object have the following values:</p>
	     * <table class="innertable">
	     *     <tr><th>Property</th><th>Value</th></tr>
	     *     <tr>
	     *     	<td><code>type</code></td>
	     *     	<td>Dispatched event type</td>
	     *     </tr>
	     * </table>
	     * 
		 * @eventType onDisplayObjectBuilderLoadStart
		 */
		public static const onDisplayObjectBuilderLoadStartEVENT : String = "onDisplayObjectBuilderLoadStart"; 
		
		/**
		 * Defines the value of the <code>type</code> property of the event 
		 * object for a <code>onDisplayLoaderInit</code> event.
		 * 
		 * <p>The properties of the event object have the following values:</p>
	     * <table class="innertable">
	     *     <tr><th>Property</th><th>Value</th></tr>
	     *     <tr>
	     *     	<td><code>type</code></td>
	     *     	<td>Dispatched event type</td>
	     *     </tr>
	     * </table>
	     * 
		 * @eventType onDisplayLoaderInit
		 */
		public static const onDisplayLoaderInitEVENT : String = "onDisplayLoaderInit";
		
		/**
		 * Defines the value of the <code>type</code> property of the event 
		 * object for a <code>onDLLLoadStart</code> event.
		 * 
		 * <p>The properties of the event object have the following values:</p>
	     * <table class="innertable">
	     *     <tr><th>Property</th><th>Value</th></tr>
	     *     <tr>
	     *     	<td><code>type</code></td>
	     *     	<td>Dispatched event type</td>
	     *     </tr>
	     * </table>
	     * 
		 * @eventType onDLLLoadStart
		 */
		public static const onDLLLoadStartEVENT : String = "onDLLLoadStart";	
		
		/**
		 * Defines the value of the <code>type</code> property of the event 
		 * object for a <code>onDLLLoadInit</code> event.
		 * 
		 * <p>The properties of the event object have the following values:</p>
	     * <table class="innertable">
	     *     <tr><th>Property</th><th>Value</th></tr>
	     *     <tr>
	     *     	<td><code>type</code></td>
	     *     	<td>Dispatched event type</td>
	     *     </tr>
	     * </table>
	     * 
		 * @eventType onDLLLoadInit
		 */
		public static const onDLLLoadInitEVENT : String = "onDLLLoadInit";			
		/**
		 * Defines the value of the <code>type</code> property of the event 
		 * object for a <code>onRSCLoadStart</code> event.
		 * 
		 * <p>The properties of the event object have the following values:</p>
	     * <table class="innertable">
	     *     <tr><th>Property</th><th>Value</th></tr>
	     *     <tr>
	     *     	<td><code>type</code></td>
	     *     	<td>Dispatched event type</td>
	     *     </tr>
	     * </table>
	     * 
		 * @eventType onRSCLoadStart
		 */
		public static const onRSCLoadStartEVENT : String = "onRSCLoadStart";		
		/**
		 * Defines the value of the <code>type</code> property of the event 
		 * object for a <code>onRSCLoadInit</code> event.
		 * 
		 * <p>The properties of the event object have the following values:</p>
	     * <table class="innertable">
	     *     <tr><th>Property</th><th>Value</th></tr>
	     *     <tr>
	     *     	<td><code>type</code></td>
	     *     	<td>Dispatched event type</td>
	     *     </tr>
	     * </table>
	     * 
		 * @eventType onRSCLoadInit
		 */
		public static const onRSCLoadInitEVENT : String = "onRSCLoadInit";
		
		/**
		 * Defines the value of the <code>type</code> property of the event 
		 * object for a <code>onDisplayObjectLoadStart</code> event.
		 * 
		 * <p>The properties of the event object have the following values:</p>
	     * <table class="innertable">
	     *     <tr><th>Property</th><th>Value</th></tr>
	     *     <tr>
	     *     	<td><code>type</code></td>
	     *     	<td>Dispatched event type</td>
	     *     </tr>
	     * </table>
	     * 
		 * @eventType onDisplayObjectLoadStart
		 */
		public static const onDisplayObjectLoadStartEVENT : String = "onDisplayObjectLoadStart"; 
		
		/**
		 * Defines the value of the <code>type</code> property of the event 
		 * object for a <code>onDisplayObjectLoadInit</code> event.
		 * 
		 * <p>The properties of the event object have the following values:</p>
	     * <table class="innertable">
	     *     <tr><th>Property</th><th>Value</th></tr>
	     *     <tr>
	     *     	<td><code>type</code></td>
	     *     	<td>Dispatched event type</td>
	     *     </tr>
	     * </table>
	     * 
		 * @eventType onDisplayObjectLoadInit
		 */
		public static const onDisplayObjectLoadInitEVENT : String = "onDisplayObjectLoadInit"; 
		
		/**
		 * Defines the value of the <code>type</code> property of the event 
		 * object for a <code>onDisplayObjectBuilderLoadInit</code> event.
		 * 
		 * <p>The properties of the event object have the following values:</p>
	     * <table class="innertable">
	     *     <tr><th>Property</th><th>Value</th></tr>
	     *     <tr>
	     *     	<td><code>type</code></td>
	     *     	<td>Dispatched event type</td>
	     *     </tr>
	     * </table>
	     * 
		 * @eventType onDisplayObjectBuilderLoadInit
		 */
		public static const onDisplayObjectBuilderLoadInitEVENT : String = "onDisplayObjectBuilderLoadInit";
		
		
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
		
		/**
		 * Creates a new <code>DisplayObjectBuilderEvent</code> object.
		 * 
		 * @param	type			Name of the event type
		 * @param	loader			Loader object carried by this event
		 * @param	errorMessage	(optional) Error message carried by this event
		 */	
		public function DisplayObjectBuilderEvent( type : String, loader : Loader = null, errorMessage : String = "" ) 
		{
			super( type, loader, errorMessage );
		}
	}
}