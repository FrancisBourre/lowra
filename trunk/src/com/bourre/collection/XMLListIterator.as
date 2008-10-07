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
package com.bourre.collection 
{
	import com.bourre.collection.Iterator;
	import com.bourre.error.NoSuchElementException;
	import com.bourre.error.UnsupportedOperationException;		

	/**
	 * @author Cédric Néhémie
	 */
	public class XMLListIterator implements Iterator 
	{
		private var list : XMLList;
		private var length : Number;
		private var index : Number;

		public function XMLListIterator ( list : XMLList )
		{
			this.list = list;
			this.length = list.length();
			index = -1;
		}

		public function hasNext () : Boolean
		{
			return index + 1 < length;
		}
		
		public function next () : *
		{
			if( !hasNext() )
				throw new NoSuchElementException ( this + " has no more elements at " + ( index + 1 ) );
			
			return list[ ++index ];
		}
		
		public function remove () : void
		{
			throw new UnsupportedOperationException( "remove is not currently supported by the XMLListIterator" );
		}
	}
}
