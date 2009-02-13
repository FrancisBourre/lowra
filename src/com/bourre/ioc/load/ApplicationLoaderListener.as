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
package com.bourre.ioc.load
{
	import com.bourre.load.LoaderListener;	

	/**
	 * Application loader listener implementation.
	 * 
	 * <p>All objects that want to listen to the loading of the application 
	 * must implement this interface</p>.
	 * 
	 * @see com.bourre.ioc.DefaultApplicationRunner
	 * 
	 * @author Francis Bourre
	 */
	public interface ApplicationLoaderListener extends LoaderListener
	{
		/**
		 * Triggered when xml context starts loading.
		 */
		function onApplicationStart( e : ApplicationLoaderEvent ) : void
		
		/**
		 * Triggered when IOC process change his state.
		 * 
		 * <p>Retreives state value using : <code>e.getApplicationState()</code><br />
		 * Possible values are : 
		 * <ul>
		 * 	<li>ApplicationLoaderEvent.LOAD_STATE</li>		 * 	<li>ApplicationLoaderEvent.PARSE_STATE</li>		 * 	<li>ApplicationLoaderEvent.DLL_STATE</li>		 * 	<li>ApplicationLoaderEvent.RSC_STATE</li>		 * 	<li>ApplicationLoaderEvent.GFX_STATE</li>		 * 	<li>ApplicationLoaderEvent.BUILD_STATE</li>		 * 	<li>ApplicationLoaderEvent.RUN_STATE</li>
		 * </ul>
		 * 
		 * @see ApplicationLoaderEvent
		 */
		function onApplicationState( e : ApplicationLoaderEvent ) : void
		
		/**
		 * Triggered when xml context is loaded and parsed.
		 */
		function onApplicationParsed( e : ApplicationLoaderEvent ) : void;
		
		/**
		 * Triggered when objects are created.
		 */
		function onApplicationObjectsBuilt( e : ApplicationLoaderEvent ) : void;
		
		/**
		 * Triggered when communication channels are created.
		 */
		function onApplicationChannelsAssigned( e : ApplicationLoaderEvent ) : void;
		
		/**
		 * Triggered when all methods defined in xml context are called on 
		 * their respective owner instance.
		 */
		function onApplicationMethodsCalled( e : ApplicationLoaderEvent ) : void;
		
		/**
		 * Triggered when application is ready.
		 * 
		 * <p>All is loaded, parsed, created and linked.<br />
		 * Depedencies are resolved</p>
		 */
		function onApplicationInit( e : ApplicationLoaderEvent ) : void;
	}
}