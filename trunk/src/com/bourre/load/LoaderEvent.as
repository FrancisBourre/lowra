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
	import com.bourre.events.BasicEvent;	
	
	/**
	 * @author Francis Bourre
	 * @version 1.0
	 */
	public class LoaderEvent 
		extends BasicEvent
	{
		public static const onLoadStartEVENT 	: String = "onLoadStart";
		public static const onLoadInitEVENT 	: String = "onLoadInit";
		public static const onLoadProgressEVENT : String = "onLoadProgress";
		public static const onLoadTimeOutEVENT 	: String = "onLoadTimeOut";
		public static const onLoadErrorEVENT 	: String = "onLoadError";
		
		protected var _loader : Loader;
		protected var _sErrorMessage : String;
		
		public function LoaderEvent( type : String, loader : Loader, errorMessage : String = "" )
		{
			super( type, loader );
			_loader = loader;
			_sErrorMessage = errorMessage;
		}

		public function getLoader() : Loader
		{
			return _loader;
		}
		
		public function getPerCent() : Number
		{
			return getLoader().getPerCent();
		}
		
		public function getName() : String
		{
			return getLoader().getName();
		}
		
		public function setErrorMessage( errorMessage : String = "" ) : void
		{
			_sErrorMessage = errorMessage.length > 0 ? errorMessage : getLoader() + " loading fails with '" + getLoader().getURL().url + "'";
		}
		
		public function getErrorMessage() : String
		{
			return _sErrorMessage;
		}
	}
}