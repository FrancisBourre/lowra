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
 
package com.bourre.ioc.context
{
	import com.bourre.load.LoaderEvent;
	import com.bourre.load.XMLLoader;	
	
	/**
	 *  Dispatched when context file starts loading.
	 *  
	 *  @eventType com.bourre.ioc.context.ContextLoaderEvent.onLoadStartEVENT
	 */
	[Event(name="onLoadStart", type="com.bourre.ioc.context.ContextLoaderEvent")]
	
	/**
	 *  DDispatched when context file loading is finished.
	 *  
	 *  @eventType com.bourre.ioc.context.ContextLoaderEvent.onLoadInitEVENT
	 */
	[Event(name="onLoadInit", type="com.bourre.ioc.context.ContextLoaderEvent")]
	
	/**
	 *  Dispatched during context file loading progression.
	 *  
	 *  @eventType com.bourre.ioc.context.ContextLoaderEvent.onLoadProgressEVENT
	 */
	[Event(name="onLoadProgress", type="com.bourre.ioc.context.ContextLoaderEvent")]
	
	/**
	 *  Dispatched when a timeout occurs during context file loading.
	 *  
	 *  @eventType com.bourre.ioc.context.ContextLoaderEvent.onLoadTimeOutEVENT
	 */
	[Event(name="onLoadTimeOut", type="com.bourre.ioc.context.ContextLoaderEvent")]
	
	/**
	 *  Dispatched when an error occurs during context file loading.
	 *  
	 *  @eventType com.bourre.ioc.context.ContextLoaderEvent.onLoadErrorEVENT
	 */
	[Event(name="onLoadError", type="com.bourre.ioc.context.ContextLoaderEvent")]
	
	
	/**
	 * Context loader implementation based on the 
	 * <code>XMLLoader</code> system.
	 * 
	 * @author Francis Bourre
	 */
	public class ContextLoader extends XMLLoader 
	{
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
		
		/**
		 * Creates instance.
		 */	
		public function getContext() : XML
		{
			return getXML();
		}
		
		/**
		 * Creates and returns concrete Loader event for this context loader.
		 * 
		 * @return	A ContextLoaderEvent event
		 * 
		 * @see ContextLoaderEvent
		 */
		protected override function getLoaderEvent( type : String, errorMessage : String = "" ) : LoaderEvent
		{
			return new ContextLoaderEvent( type, this, errorMessage );
		}
	}
}