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
	 *  Dispatched when loader starts loading.
	 *  
	 *  @eventType com.bourre.load.XMLLoaderEvent.onLoadStartEVENT
	 */
	[Event(name="onLoadStart", type="com.bourre.load.XMLLoaderEvent")]
	
	/**
	 *  Dispatched when loading is finished.
	 *  
	 *  @eventType com.bourre.load.XMLLoaderEvent.onLoadInitEVENT
	 */
	[Event(name="onLoadInit", type="com.bourre.load.XMLLoaderEvent")]
	
	/**
	 *  Dispatched during loading progression.
	 *  
	 *  @eventType com.bourre.load.XMLLoaderEvent.onLoadProgressEVENT
	 */
	[Event(name="onLoadProgress", type="com.bourre.load.XMLLoaderEvent")]
	
	/**
	 *  Dispatched when a timeout occurs during loading.
	 *  
	 *  @eventType com.bourre.load.XMLLoaderEvent.onLoadTimeOutEVENT
	 */
	[Event(name="onLoadTimeOut", type="com.bourre.load.XMLLoaderEvent")]
	
	/**
	 *  Dispatched when an error occurs during loading.
	 *  
	 *  @eventType com.bourre.load.XMLLoaderEvent.onLoadErrorEVENT
	 */
	[Event(name="onLoadError", type="com.bourre.load.XMLLoaderEvent")]
	
	/**
	 * The XMLLoader class allow to load xml content.
	 * 
	 * @example
	 * <pre class="prettyprint">
	 * 
	 * var loader : XMLLoader = new XMLLoader(  );
	 * loader.addEventListener( XMLLoader.onLoadInitEVENT, onLoaded );
	 * loader.load( new URLRequest( "content.xml" );
	 * </pre>
	 * 
	 * @author 	Francis Bourre
	 */
	public class XMLLoader extends FileLoader
	{
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
		
		/**
		 * Creates new <code>XMLLoader</code> instance.
		 */	
		public function XMLLoader()
		{
			super( FileLoader.TEXT );
		}
		
		/**
		 * @inheritDoc
		 */
		protected override function getLoaderEvent( type : String, errorMessage : String = "" ) : LoaderEvent
		{
			return new XMLLoaderEvent( type, this, errorMessage );
		}
		
		/**
		 * Returns xml content.
		 * 
		 * @return	XML content
		 */
		public function getXML() : XML
		{
			return XML( getContent() );
		}
	}
}