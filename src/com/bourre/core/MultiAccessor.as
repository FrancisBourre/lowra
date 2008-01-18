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
package com.bourre.core 
{
	public class MultiAccessor implements AccessorComposer
	{
		private var _o : Object;
		private var _aGet : Array;
		private var _aSet : Array;
		private var _a : Array;
		
		public function MultiAccessor ( t : Object, setter : Array, getter : Array = null ) 
		{
			_a = new Array();
			_o = t;
			_aSet = setter;
			_aGet = getter;
			
			var l : Number = setter.length;
			var isMultiTarget : Boolean = t is Array;
			
			for ( var i : Number = 0; i < l; i++ ) 
			{
				_a.push( AccessorFactory.getAccessor( isMultiTarget ? _o[ i ] : _o , _aSet[ i ], _aGet != null ? _aGet[ i ] : null ) );
			}
		}
		
		public function getSetterHelper():Array
		{
			return _aSet;
		}
		
		public function getValue():Array
		{
			var l : Number = _a.length;
			var a : Array = new Array();
			while ( --l -(-1) ) a[ l ] = ( _a[ l ] as Accessor ).getValue();
			return a;
		}
		
		public function getTarget() : Object
		{
			return _o;
		}
		
		public function getGetterHelper():Array
		{
			return _aGet;
		}
		
		public function setValue( values : Array ) : void
		{
			var l : Number = _a.length;
			while ( --l -(-1) ) ( _a[ l ] as Accessor ).setValue( values[ l ] );
		}
	}
}