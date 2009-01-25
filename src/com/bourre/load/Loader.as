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
		function getURL() : URLRequest;
		function setURL( url : URLRequest ) : void;
		function prefixURL( prefixURL : String ) : void;
		function getName() : String;
		function setName( name : String ) : void;
		function getPerCent() : Number;
		
		/**
		 * Returns loading strategy used by the loader.
		 */
		function getStrategy() : LoadStrategy;
		function addListener( listener : LoaderListener ) : Boolean;
		function removeListener( listener : LoaderListener ) : Boolean;
		function addEventListener( type : String, listener : Object, ... rest ) : Boolean;
		function removeEventListener( type : String, listener : Object ) : Boolean;
		function setAntiCache( b : Boolean ) : void;

		function setContent( content : Object ) : void;
		function fireOnLoadProgressEvent() : void;
	    function fireOnLoadInitEvent() : void;
	    function fireOnLoadStartEvent() : void;
		function fireOnLoadErrorEvent( message : String = null ) : void;
	}
}