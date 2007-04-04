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

package com.bourre.collection
{
	import flash.utils.Dictionary;
	import com.bourre.log.*;
	import com.bourre.error.IllegalArgumentException;
	
	public class HashMap 
	{
		private var _n : uint;
		private var _oKeyDico : Dictionary;
		private var _oValueDico : Dictionary;
		
		public function HashMap()
		{
			_init();
		}
		
		private function _init() : void
		{
			_n = 0;
			_oKeyDico = new Dictionary( true );
			_oValueDico = new Dictionary( true );
		}
		
		public function clear() : void
		{
			_init();
		}
		
		public function isEmpty() : Boolean
		{
			return ( _n == 0 );
		}
		
		public function containsKey( key : * ) : Boolean
		{
			return _oKeyDico[ key ] != null;
		}
		
		public function containsValue( value : * ) : Boolean
		{
			return _oValueDico[ value ] != null;
		}
		
		public function put ( key : *, value : * ) : void
		{
			if (key != null)
			{
				if ( containsKey( key ) ) remove( key );
				
				_n++;
				var count : uint = _oValueDico[ value ];
				_oValueDico[ value ] = (count > 0) ? count+1 : 1;
				_oKeyDico[ key ] = value;
			}
			else
			{
				throw new IllegalArgumentException( this + ".put() failed. key can't be null" );
			}
		}
		
		public function get ( key : * ) : *
		{
			return _oKeyDico[ key ];
		}

		public function remove( key : * ) : *
		{
			var value : *;
			
			if ( containsKey( key ) ) 
			{
				_n--;
				value = _oKeyDico[ key ];
				
				var count : uint = _oValueDico[ value ];
				if (count > 1)
				{
					_oValueDico[ value ] = count - 1;
				} else
				{
					delete _oValueDico[ value ];
				}
				
				delete _oKeyDico[ key ];
			}
			
			return value;
		}

		public function size() : Number
		{
			return _n;
		}
		
		public function getKeys() : Array
		{
			var a : Array = new Array();
			for ( var key : * in _oKeyDico ) a.push( key );
			return a;
		}
		
		public function getValues() : Array
		{
			var a : Array = new Array();
			for each ( var value : * in _oKeyDico ) a.push( value );
			return a;
		}
		
		/**
		 * Returns the string representation of this instance.
		 * @return the string representation of this instance
		 */
		public function toString() : String 
		{
			return PixlibStringifier.stringify( this );
		}
	}
}