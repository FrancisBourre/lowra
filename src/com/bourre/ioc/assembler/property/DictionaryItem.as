package com.bourre.ioc.assembler.property 
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
	import com.bourre.log.PixlibStringifier;												

	public class DictionaryItem 
	{
		protected var _pKey : Property;
		protected var _pValue : Property;
		
		public var key : Object;
		public var value : Object;

		public function DictionaryItem ( key : Property, value : Property ) 
		{
			_pKey = key;
			_pValue = value;
		}

		public function getPropertyKey() : Property
		{
			return _pKey;
		}

		public function getPropertyValue() : Property
		{
			return _pValue;
		}

		/**
		 * Returns the string representation of this instance.
		 * @return the string representation of this instance
		 */
		public function toString() : String 
		{
			return PixlibStringifier.stringify( this ) + " [key:" + getPropertyKey() + ", value:" + getPropertyValue() + "]";
		}
	}
}
