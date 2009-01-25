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
	 * All loaders listener must implements this interface.
	 * 
	 * @author Francis Bourre
	 */
	public interface LoaderListener 
	{
		/**
		 * Triggered when loading starts.
		 */
		function onLoadStart( e : LoaderEvent ) : void;
		
		/**
		 * Triggered when loading is finished.
		 */
		function onLoadInit( e : LoaderEvent ) : void;

		/**
		 * Triggered during loading progession.
		 */
		function onLoadProgress( e : LoaderEvent ) : void;

		/**
		 * Triggered when the loading time causes a tiemout.
		 */
		function onLoadTimeOut( e : LoaderEvent ) : void;

		/**
		 * Triggered when an error occurs during loading
		 */
		function onLoadError( e : LoaderEvent ) : void;
	}
}