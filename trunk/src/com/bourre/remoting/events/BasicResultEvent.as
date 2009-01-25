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
	 * The BasicResultEvent interface.
	 * 
	 * <p>TODO Documentation.</p>
	 * 
	 * @author Romain Flacher
	 * @author Axel Aigret
	 */
	public class BasicResultEvent extends BasicEvent {
		
		public static const onResultEVENT : String = "onResult";
		
		private var _oResult : *;
		private var _oServiceMethod : ServiceMethod;
		
		public function BasicResultEvent(  result : *, sServiceMethodName : ServiceMethod ) 
		{
			super( BasicResultEvent.onResultEVENT );
			
			_oResult = result;
			_oServiceMethod = sServiceMethodName;
		}
		
		public function getResult() : *
		{
			return _oResult;
		}
		
		// TODO: know which type of function name we want for callback of methodcallby service
		// we can use onResult + functionname onResultlogin onResultgetListName / or on + functionname
		public function redirectType() : void
		{
			if (_oServiceMethod is ServiceMethod) setType( _oServiceMethod.toString());
		}
		
		public function getServiceMethode() : ServiceMethod
		{
			return _oServiceMethod;
		}
	
		
	}
}
