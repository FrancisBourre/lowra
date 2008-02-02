package com.bourre.ioc.assembler.method
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
	import com.bourre.ioc.assembler.method.Method;	

	public class MethodEvent 
		extends BasicEvent
	{
		public static const onRegisterMethodEVENT : String = "onRegisterMethod";		public static const onUnregisterMethodEVENT : String = "onUnregisterMethod";

		protected var _sID : String;
		protected var _oMethod : Method;

		public function MethodEvent( type : String, id : String, method : Method = null )
		{
			super( type );

			_sID = id;
			_oMethod = method;
		}

		public function getExpertID() : String
		{
			return _sID;
		}

		public function getMethod() : Method
		{
			return _oMethod;
		}
	}
}