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
	 * The <code>ArrayIterator</code> utility provide a convenient way
	 * to iterate in an array as you can do with a <code>Collection</code>.
	 * <p>
	 * Iterations performed by the array iterator are done in the index
	 * order of the array. More formally the iterations are always realized
	 * from <code>0</code> to the <code>length</code> of the passed-in array.
	 * </p> 
	 * @author 	Cedric Nehemie
	 * @see		Iterator
	 */
	public class ArrayIterator implements Iterator 
	{
	    protected var _aArray : Array;
	    protected var _nSize : Number;
	    protected var _nIndex : Number;
	    protected var _bRemoved : Boolean;

		/**
		 * Creates a new iterator over the passed-in array.
		 * 
		 * @param	a	<code>Array</code> target for this iterator
		 */
		public function ArrayIterator ( a : Array )
	    {
	        _aArray = a;
	        _nSize = a.length;
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
	        return _aArray[ ++_nIndex ];
	    }
		
		/**
		 * @inheritDoc
		 */
		public function remove () : void
		{
			if( _bRemoved )
			{
				_aArray.splice( _nIndex--, 1 );
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
