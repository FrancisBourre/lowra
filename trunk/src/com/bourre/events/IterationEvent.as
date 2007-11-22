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
	public class IterationEvent extends BasicEvent 
	{
		protected var _nIndex : Number;
		protected var _oValue : *;
		
		public function IterationEvent ( sType : String, 
										 oTarget : Object = null,
										 index : Number = 0,
										 value : * = null )
		{
			super( sType, oTarget );
			
			_nIndex = index;
			_oValue = value;
		}
		
		public function getIndex () : Number
		{
			return _nIndex;
		}
		
		public function getValue () : *
		{
			return _oValue;
		}
	}
}
