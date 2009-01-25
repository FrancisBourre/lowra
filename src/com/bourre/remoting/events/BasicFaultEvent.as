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
 
package com.bourre.remoting.events 
{
	import com.bourre.events.BasicEvent;
	import com.bourre.remoting.ServiceMethod;		

	/**
	 * The BasicFaultEvent interface.
	 * 
	 * <p>TODO Documentation.</p>
	 * 
	 * @author Romain Flacher
	 * @author Axel Aigret
	 */
	public class BasicFaultEvent extends BasicEvent 
	{
		
		public static var onFaultEVENT : String = "onFault";
		
		
		
		private var _sCode 				: String;
		private var _sCorrelationId 	: String;
		private var _sDetail 			: String;
		private var _sDescription 		: String;
		
		private var _sServiceMethodName : ServiceMethod;
		
		/**
		 * @param	code
		 * @param	correlationId
		 * @param	details
		 * @param	description
		 * @param	sServiceMethodName
		 */
		public function BasicFaultEvent(code : String, 
										correlationId : String, 
										details : String, 
										description : String,
										sServiceMethodName : ServiceMethod ) 
		{
			super( BasicFaultEvent.onFaultEVENT );
			
			_sCode = code ;
			_sCorrelationId = correlationId ;
			_sDetail = details;
			_sDescription = description;
			_sServiceMethodName = sServiceMethodName;
		}
		
		public function getCode() : String
		{
			return _sCode;
		}

		public function getCorrelationId() : String
		{
			return _sCorrelationId;
		}
		
		public function getDetail() : String
		{
			return _sDetail;
		}
		
		public function getDescription() : String
		{
			return _sDescription;
		}

		public function getServiceMethodName() : ServiceMethod
		{
			return _sServiceMethodName;
		}
		
		override public function toString() : String 
		{
			return "BasicFaultEvent code: "+getCode()+
					                "id: "+ getCorrelationId()+
					                "detail" +getDetail()+
					                "description" + getDescription()+
					                "methodname" + getServiceMethodName();
		}
		
	}
}
