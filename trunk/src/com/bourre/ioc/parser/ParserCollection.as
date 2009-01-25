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
	 
package com.bourre.ioc.parser 
{
	import com.bourre.collection.ArrayIterator;
	import com.bourre.collection.Iterable;
	import com.bourre.collection.Iterator;	
	
	/**
	 * Parser collection.
	 * 
	 * @author romain Ecarnot
	 */
	public class ParserCollection implements Iterable
	{
		//--------------------------------------------------------------------
		// Protected properties
		//--------------------------------------------------------------------
		
		/** Parsers storage. */		
		protected var _a : Array;
		
		
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
		
		/**
		 * Creates instance.
		 */
		public function ParserCollection( a : Array = null ) 
		{
			_a = a == null ? new Array() : a;
		}
		
		/**
		 * Adds passed-in parser into this collection.
		 */
		public function push( parser : AbstractParser ) : void
		{
			_a.push( parser );
		}
		
		/**
		 * Clears collection.
		 */
		public function clear() : void
		{
			_a = new Array() ;
		}
		
		/**
		 * Returns an iterator to iterate throw this collection.
		 */
		public function iterator() : Iterator
		{
			return new ArrayIterator( _a );
		}
	}}