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
	import com.bourre.events.ValueObjectEvent;
	import com.bourre.load.LoaderListener;	
	
	/**
	 * Display object builder listeners must implement this interface.
	 *  
	 * @author Francis Bourre
	 */
	public interface DisplayObjectBuilderListener extends LoaderListener
	{
		/**
		 * Triggered when a display loader is registred.
		 */
		function onDisplayLoaderInit( e : ValueObjectEvent ) : void;

		/**
		 * Triggered when context files starts processing.
		 */
		function onDisplayObjectBuilderLoadStart( e : DisplayObjectBuilderEvent ) : void;

		/**
		 * Triggered when a DLL file starts loading.
		 */
		function onDLLLoadStart( e : DisplayObjectBuilderEvent ) : void;	

		/**
		 * Triggered when a DLL file loading is finished.
		 */
		function onDLLLoadInit( e : DisplayObjectBuilderEvent ) : void;

		/**
		 * Triggered when a resource file loading is finished.
		 */
		function onRSCLoadInit( e : DisplayObjectBuilderEvent ) : void;
		/**
		 * Triggered when a resource file starts loading.
		 */
		function onRSCLoadStart( e : DisplayObjectBuilderEvent ) : void;

		/**
		 * Triggered when a graphic file starts loading.
		 */
		function onDisplayObjectLoadStart( e : DisplayObjectBuilderEvent ) : void;

		/**
		 * Triggered when a graphic file loading is finished.
		 */
		function onDisplayObjectLoadInit( e : DisplayObjectBuilderEvent ) : void;
		
		/**
		 * All files in xml context are loaded.
		 */
		function onDisplayObjectBuilderLoadInit( e : DisplayObjectBuilderEvent ) : void;

		/**
		 * Triggered when a display object is built.
		 */
		function onBuildDisplayObject( e : DisplayObjectEvent ) : void;	}}