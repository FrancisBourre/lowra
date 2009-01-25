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
	import com.bourre.log.PixlibDebug;	
	import com.bourre.error.IllegalStateException;
	import com.bourre.error.IndexOutOfBoundsException;
	import com.bourre.error.NoSuchElementException;
	import com.bourre.error.NullPointerException;		

	/**
	 * The <code>ArrayIterator</code> class provides a convenient way
	 * to iterate through each entry of an <code>Array</code> instance 
	 * as you could do with a <code>List</code> instance.
	 * <p>
	 * Iterations are performed from <code>0</code> to <code>length</code> 
	 * of the passed-in array.
	 * </p> 
	 * 
	 * @author 	Cedric Nehemie
	 * 
	 * @see		ListIterator
	 */
	public class ArrayIterator implements ListIterator 
	{
	    protected var _aArray 	: Array;
	    protected var _nSize 	: Number;
	    protected var _nIndex 	: Number;
	    protected var _bRemoved : Boolean;	    protected var _bAdded 	: Boolean;

		/**
		 * Creates a new iterator for the passed-in array.
		 * 
		 * @param	a	<code>Array</code> iterator's target
		 * @param	i	iterator's start index
		 * @throws 	<code>NullPointerException</code> — if the array's target is null
		 * @throws 	<code>IndexOutOfBoundsException</code> — if the index is out of range
		 */
		public function ArrayIterator ( a : Array, i : uint = 0 )
	    {
	    	if ( a == null )
	    	{
	    		var msg0 : String = "Array target of " + this + "can't be null.";
				PixlibDebug.ERROR ( msg0 );
				throw new NullPointerException ( msg0 );
	    	}

	    	if ( i > a.length )
	    	{
	    		var msg1 : String = "'" + i + "' is not a valid index for an array with '" + a.length + "' length.";
	    		PixlibDebug.ERROR ( msg1 );
	    		throw new IndexOutOfBoundsException ( msg1 );
	    	}
		
			_aArray 	= a;
	        _nSize 		= a.length;
	        _nIndex 	= i - 1;
			_bRemoved 	= false;
			_bAdded 	= false;
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
	    	{
	    		var msg : String = this + " has no more element at '" + ( _nIndex + 1 ) +"' index.";
				PixlibDebug.ERROR ( msg );
				throw new NoSuchElementException ( msg );
	    	}
			
	    	_bRemoved 	= false;
			_bAdded 	= false;
			return _aArray[ ++_nIndex ];
	    }
		
		/**
		 * @inheritDoc
		 */
		public function remove () : void
		{
			if( !_bRemoved )
			{
				_aArray.splice( _nIndex--, 1 );
				_nSize--;
				_bRemoved = true;

			} else
			{
				var msg : String = this + ".remove() has been already called in this iteration.";
				PixlibDebug.ERROR ( msg );
				throw new IllegalStateException ( msg );
			}
		}

		/**
		 * @inheritDoc
		 */
		public function add ( o : Object ) : void
		{
			if( !_bAdded )
			{
				_aArray.splice ( _nIndex + 1, 0, o );
				_nSize++;
				_bAdded = true;

			} else
			{
				var msg : String = this + ".add() has been already called in this iteration.";
				PixlibDebug.ERROR ( msg );
				throw new IllegalStateException ( msg );
			}
		}

		/**
		 * @inheritDoc
		 */
		public function hasPrevious () : Boolean
		{
			return _nIndex >= 0;
		}

		/**
		 * @inheritDoc
		 */
		public function nextIndex () : uint
		{
			return _nIndex + 1;
		}

		/**
		 * @inheritDoc
		 */
		public function previous () : *
		{
			if( !hasPrevious() )
			{
				var msg : String = this + " has no more element at '" + ( _nIndex ) + "' index.";
				PixlibDebug.ERROR ( msg );
				throw new NoSuchElementException ( msg );
			}
			
	    	_bRemoved 	= false;
			_bAdded 	= false;
			
			return _aArray[ _nIndex-- ];
		}

		/**
		 * @inheritDoc
		 */
		public function previousIndex () : uint
		{
			return _nIndex;
		}

		/**
		 * @inheritDoc
		 */
		public function set ( o : Object ) : void
		{
			if( !_bRemoved && !_bAdded )
			{
				_aArray[ _nIndex ] = o;

			} else
			{
				var msg : String = 	this + ".add() or " + this + ".remove() have been " +
									"already called in this iteration, the set() operation cannot be done";
				PixlibDebug.ERROR ( msg );
				throw new IllegalStateException ( msg );
			}
		}
	}
}
