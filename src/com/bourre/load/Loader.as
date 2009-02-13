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
	import com.bourre.commands.ASyncCommand;
	import com.bourre.load.strategy.LoadStrategy;
	
	import flash.net.URLRequest;
	import flash.system.LoaderContext;	
	
	/**
	 * The Loader interface defines rules for loader implementations.
	 * 
	 * @author 	Francis Bourre
	 */
	public interface Loader extends ASyncCommand
	{
		/**
		 * Loads content.
		 * 
		 * @param	request	The absolute or relative URL of the content to load.
		 * @param	context	(optional) A LoaderContext object, which has properties that define the following: 
		 * <ul>
		 * 	<li>Whether or not to check for the existence of a policy file upon loading the object</li>
		 * 	<li>The ApplicationDomain for the loaded object</li>
		 * 	<li>The SecurityDomain for the loaded object</li></ul>
		 */
		function load( url : URLRequest = null, context : LoaderContext = null ) : void;
		
		/**
		 * Returns the URL used by this loader.
		 * 
		 * <p>If 'anticache' or 'prefix' are used, returns the full 
		 * qualified url.</p>
		 * 
		 * @return The URL used by this loader.
		 * 
		 * @see #setAntiCache()
		 * @see #prefixURL()
		 */
		function getURL() : URLRequest;
		
		/**
		 * Defined from which the URL will be loaded.
		 * 
		 * @param	url	URL to load
		 */
		function setURL( url : URLRequest ) : void;
		
		/**
		 * Adds prefix to URL passed to the loader instance.
		 * 
		 * @example
		 * <pre class="prettyprint">
		 * 
		 * var loader : Loader = new FileLoader();
		 * loader.prefixURL( "config/context/" );
		 * loader.load( new URLRequest( "info.txt" ) );
		 * </pre>
		 * The loaded url path is : <code>config/context/info.txt</code>
		 * 
		 * @param	prefixURL	String ( prefix ) to insert before url value.
		 */
		function prefixURL( prefixURL : String ) : void;
		
		/**
		 * Returns the loader identifier.
		 * 
		 * @return The loader identifier.
		 */
		function getName() : String;
		
		/**
		 * Sets the loader identifier.
		 * 
		 * <p>Identifier is used to register some loader into locator.</p>
		 * 
		 * @param	name	Loader identifier
		 */
		function setName( name : String ) : void;
		
		/**
		 * Returns a percentage of bytes loaded and total bytes to load.
		 * 
		 * @returns	a percentage of bytes loaded and total bytes to load.
		 */
		function getPerCent() : Number;
		
		/**
		 * Returns loading strategy used by the loader.
		 */
		function getStrategy() : LoadStrategy;
		
		/**
		 * @copy com.bourre.events.Broadcaster#addListener()
		 */
		function addListener( listener : LoaderListener ) : Boolean;
		
		/**
		 * @copy com.bourre.events.Broadcaster#removeListener()
		 */
		function removeListener( listener : LoaderListener ) : Boolean;
		
		/**
		 * @copy com.bourre.events.Broadcaster#addEventListener()
		 */
		function addEventListener( type : String, listener : Object, ... rest ) : Boolean;
		
		/**
		 * @copy com.bourre.events.Broadcaster#removeEventListener()
		 */
		function removeEventListener( type : String, listener : Object ) : Boolean;
		
		/**
		 * Sets the 'anticache' system to <code>true</code> to add timestamp value 
		 * to the loaded URL. In this way, it force the re loading of content and 
		 * not use the possible cache content.
		 * 
		 * @param	b	<code>true</code> to set 'anticache' to 'on'
		 */
		function setAntiCache( b : Boolean ) : void;
		
		/**
		 * Uses to replace this loader content.
		 * 
		 * @param	content	New content to set as loader content
		 */
		function setContent( content : Object ) : void;
		
		/**
		 * Dispatches event during loading progression.
		 */
		function fireOnLoadProgressEvent() : void;
	    
	    /**
		 * Dispatches event when the loading is finished.
		 */
	    function fireOnLoadInitEvent() : void;
	    
	    /**
		 * Dispatches event when the loading starts.
		 */
	    function fireOnLoadStartEvent() : void;
		
		/**
		 * Dispatches event when an error occur.
		 */
		function fireOnLoadErrorEvent( message : String = null ) : void;
	}
}