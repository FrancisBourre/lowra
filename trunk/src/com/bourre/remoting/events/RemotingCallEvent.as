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
	import com.bourre.load.LoaderEvent;
	import com.bourre.remoting.RemotingCall;		

	/**
	 * The RemotingCallEvent interface.
	 * 
	 * <p>TODO Documentation.</p>
	 * 
	 * @author Romain Flacher
	 */
	public class RemotingCallEvent extends LoaderEvent
	{
		private var _oResult : Object;
		public static var onLoadInitEVENT : String = LoaderEvent.onLoadInitEVENT;
		public static var onLoadErrorEVENT : String = LoaderEvent.onLoadErrorEVENT;
		
		public function RemotingCallEvent( e : String, oLib : RemotingCall, result : Object = null)
		{
			super( e, oLib );
			
			_oResult = result;
		}
		
		public function getLib() : RemotingCall
		{
			return _loader as RemotingCall;
		}
		
		public function getResult() : Object
		{
			return _oResult;
		}
	}
}
