package com.bourre.ioc.assembler.displayobject 
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
	import com.bourre.load.LoaderListener;	

	public interface DisplayObjectBuilderListener 
		extends LoaderListener
	{
		function onDisplayObjectBuilderLoadStart( e : DisplayObjectBuilderEvent ) : void;
		function onDLLLoadStart ( e : DisplayObjectBuilderEvent ) : void;	
		function onDLLLoadInit ( e : DisplayObjectBuilderEvent ) : void;
		function onDisplayObjectLoadStart ( e : DisplayObjectBuilderEvent ) : void;
		function onDisplayObjectLoadInit ( e : DisplayObjectBuilderEvent ) : void;
		function onDisplayObjectBuilderLoadInit ( e : DisplayObjectBuilderEvent ) : void;

		function onBuildDisplayObject ( e : DisplayObjectEvent ) : void;	}}