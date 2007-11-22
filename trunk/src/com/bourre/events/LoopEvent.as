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
package com.bourre.events 
{
	import com.bourre.events.BasicEvent;
	
	/**
	 * @author Cédric Néhémie
	 */
	public class LoopEvent extends BasicEvent 
	{
		protected var _nIndex : Number;
		
		public function LoopEvent (sType : String, oTarget : Object = null, index : Number = 0)
		{
			super( sType, oTarget );
			_nIndex = index;
		}
		
		public function getIndex () : Number
		{
			return _nIndex;
		}
	}
}
