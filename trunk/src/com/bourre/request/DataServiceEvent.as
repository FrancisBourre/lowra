package com.bourre.request
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

	import com.bourre.events.BasicEvent;
	import com.bourre.collection.Set;
	import com.bourre.collection.Collection;
	
	public class DataServiceEvent 
		extends BasicEvent
	{
		public static const onDataResultEVENT : String = "onDataResult";
		public static const onDataErrorEVENT : String = "onDataError";
		
		private var _oDataService 	: DataService;
		private var _oConnector		: DataServiceConnector ;
		
		public function DataServiceEvent( type : String, dataService : DataService ) 
		{
			super( type, dataService );
			
			_oDataService = dataService;
		}
		
		public function getDataService():DataService
		{
			return _oDataService ;
		}
		
		public function getDataConnector():DataServiceConnector
		{
			return _oConnector ;
		}
		
		public function setDataConnector(dataConnector:DataServiceConnector):void
		{
			_oConnector = dataConnector ;
		}
	}
}