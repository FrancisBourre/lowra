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
	
	public class DataRequestEvent 
		extends BasicEvent
	{
		public static const onDataResultEVENT : String = "onDataResult";
		public static const onDataErrorEVENT : String = "onDataError";
		
		private var _aRequestArgument : Array;
		private var _oResult : Object;
		private var _cListener : Set;
		private var _oDataRequest : DataRequest;
		
		public function DataRequestEvent( type : String, dataRequest : DataRequest ) 
		{
			super( type, dataRequest );
			
			_oDataRequest = dataRequest;
			_cListener = new Set();
		}
		
		public function setResult( result : Object ) : void
		{
			_oResult = result;
		}
		
		public function getResult() : Object
		{
			return _oResult;
		}

		public function addRequestListener( listener : Object ) : void
		{
			_cListener.add( listener );
		}
		
		public function removeRequestListener( listener : Object ) : void
		{
			_cListener.remove( listener );
		}
		
		public function getRequestListener() : Collection
		{
			return _cListener;
		}

		public function setArguments( ... rest ) : void
		{
			_aRequestArgument = rest;
		}
		
		public function getArguments() : Array
		{
			return _aRequestArgument;
		}
		
		public function getDataRequest() : DataRequest
		{
			return _oDataRequest;
		}
	}
}