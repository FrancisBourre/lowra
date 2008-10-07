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
package com.bourre.service 
{
	import com.bourre.events.BasicEvent;	
	
	/**
	 * @author Francis Bourre
	 * @version 1.0
	 */
	public class ServiceEvent 
		extends BasicEvent
	{
		public static const onDataResultEVENT 	: String = "onDataResult";
		public static const onDataErrorEVENT 	: String = "onDataError";

		private var _oService 	: Service;

		public function ServiceEvent( type : String , service : Service ) 
		{
			super( type, service );

			_oService = service;
		}

		public function getService() : Service
		{
			return _oService ;
		}
	}
}