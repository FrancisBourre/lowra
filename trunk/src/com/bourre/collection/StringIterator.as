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
	import com.bourre.error.IllegalStateException;
	import com.bourre.error.NoSuchElementException;		

	/**
	 * The <code>StringIterator</code> utility provide a convenient way
	 * to iterate over the character of a string as you can do with a
	 * <code>Collection</code>.
	 * <p>
	 * Iterations performed by the string iterator are done in the index
	 * order of the string. More formally the iterations are always realized
	 * from <code>0</code> to the <code>length</code> of the passed-in string.
	 * </p>
	 * @author 	Cédric Néhémie
	 * @see		Iterator
	 */
	public class StringIterator implements Iterator 
	{
		protected var _sString : String;
		protected var _nSize : Number;
		protected var _nIndex : Number;
		protected var _bRemoved : Boolean;
		
		/**
		 * Creates a new string iterator over the character
		 * of the passed-in string.
		 * 
		 * @param	s	<code>String</code> target of this iterator
		 */
		public function StringIterator ( s : String ) 
		{
			_sString = s;
			_nSize = _sString.length;
			_nIndex = -1;
			_bRemoved = false;
		}
		
		/**
		 * @inheritDoc
		 */
		public function hasNext () : Boolean
	    {	
	        return ( _nIndex + 1 < _nSize );
	    }
	    /**
		 * @inheritDoc
		 */
	    public function next () : *
	    {
	    	if( !hasNext() )
				throw new NoSuchElementException ( this + " has no more elements at " + ( _nIndex + 1 ) );
				
	    	_bRemoved = false;
			return _sString.substr( ++_nIndex, 1 );
		}
		
		/**
		 * @inheritDoc
		 */
		public function remove () : void
		{
			if( !_bRemoved )
			{
				_sString.slice( _nIndex--, 1 );
				_nSize--;
				_bRemoved = true;
			}
			else
			{
				throw new IllegalStateException ( this + ".remove() have been already called for this iteration" );
			}
		}
	}
}
