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

	import com.bourre.log.*;
	import flash.events.Event;
	import flash.display.DisplayObjectContainer;

	public class LoaderEvent 
		extends Event
	{
		public static const onLoadInitEVENT : String = "onLoadInit";
		public static const onLoadProgressEVENT : String = "onLoadProgress";
		public static const onLoadTimeOutEVENT : String = "onLoadTimeOut";
		public static const onLoadErrorEVENT : String = "onLoadError";
		
		protected var _load : AbstractLoader;
		
		public function LoaderEvent( type : String, load : AbstractLoader )
		{
			super( type );
			_load = load;
		}
		
		public function getLoader() : Loader
		{
			return _load;
		}
		
		public function getPerCent() : Number
		{
			return getLoader().getPerCent();
		}
		
		public function getName() : String
		{
			return getLoader().getName();
		}
	}
}