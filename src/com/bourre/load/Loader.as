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

	import com.bourre.commands.ASyncCommand;
	import flash.display.*;
	
	public interface Loader 
		extends ASyncCommand
	{
		function load( url : String = null ) : void;
		function getURL() : String;
		function setURL( url : String ) : void;
		function prefixURL( prefixURL : String ) : void;
		function getName() : String;
		function setName( name : String ) : void;
		function getPerCent() : Number;
		function addListener( listener : LoaderListener ) : void;
		function removeListener( listener : LoaderListener ) : void;
		function setAntiCache( b : Boolean ) : void;
		
		function setContent( content : DisplayObject ) : void;
		function fireOnLoadProgressEvent() : void;
	    function fireOnLoadInitEvent() : void;
	    function fireOnLoadStartEvent() : void;
		function fireOnLoadErrorEvent() : void;
	}
}