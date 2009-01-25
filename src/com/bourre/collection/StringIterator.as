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
	import com.bourre.error.IllegalArgumentException;
	import com.bourre.error.IllegalStateException;
	import com.bourre.error.IndexOutOfBoundsException;
	import com.bourre.error.NoSuchElementException;
	import com.bourre.error.NullPointerException;	

	/**
	 * The <code>StringIterator</code> class provides a convenient way
	 * to iterate through each character of a string as you could do with 
	 * a <code>List</code> instance.
	 * <p>
	 * Iterations are performed from <code>0</code> to the <code>length</code> 
	 * of the passed-in string.
	 * </p>
	 * 
	 * @author 	Cédric Néhémie
	 * @see		ListIterator
	 */
	public class StringIterator 
		implements ListIterator 
	{
		protected var _sString 	: String;
		protected var _nSize 	: Number;
		protected var _nIndex 	: Number;
		protected var _bRemoved : Boolean;
		protected var _bAdded 	: Boolean;
		protected var _nGap 	: Number;

		/**
		 * Creates a new string iterator to iterate through
		 * each character of the passed-in string.
		 * 
		 * @param	s	<code>String</code> iterator's target
		 * @param 	gap	
		 * @param	i	iterator's start index
		 * @throws 	<code>NullPointerException</code> — if the string's target is null
		 * @throws 	<code>IndexOutOfBoundsException</code> — if the index is out of range
		 */
		public function StringIterator ( s : String, gap : Number = 1, i : uint = 0 ) 
		{
			if ( s == null )
			{
				var msg0 : String = "String target of " + this + "can't be null.";
				PixlibDebug.ERROR( msg0 );
				throw new NullPointerException( msg0 );
			}

	    	if ( i > s.length )
	    	{
	    		var msg1 : String = "'" + i + "' is not a valid index for a string with '" + s.length +"' length.";
				PixlibDebug.ERROR( msg1 );
				throw new IndexOutOfBoundsException ( msg1 );
	    	}

			if ( gap < 1 || gap > s.length || s.length % gap != 0 )
			{
				var msg2 : String = "'" + gap + "' is not a valid gap for a string with '" + s.length +"' length.";
				PixlibDebug.ERROR( msg2 );
				throw new IndexOutOfBoundsException ( msg2 );
			}

			_sString 	= s;
			_nSize 		= _sString.length / gap;
			_nIndex 	= i - 1;
			_bRemoved 	= false;
			_bAdded 	= false;
			_nGap 		= gap;
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
	    	if ( !hasNext() )
	    	{
	    		var msg : String = this + " has no more element at '" + ( _nIndex + 1 ) +"' index.";
	    		PixlibDebug.ERROR( msg );
				throw new NoSuchElementException ( msg );
	    	}

			_bAdded = false;
	    	_bRemoved = false;
			return _sString.substr( ++_nIndex * _nGap, _nGap );
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

			} else
			{
				var msg : String = this + ".remove() has been already called in this iteration.";
				PixlibDebug.ERROR( msg );
				throw new IllegalStateException ( msg );
			}
		}

		/**
		 * @inheritDoc
		 * @throws 	<code>IllegalArgumentException</code> — The passed-in string couldn't be added due to its length
		 */
		public function add (o : Object) : void
		{
			if ( !_bAdded )
			{
				if ( ( o as String ).length != 1 )
				{
					var msg0 : String = this + ".add() failed, expected length '1', get '" + (o as String).length + "' length.";
					PixlibDebug.ERROR ( msg0 );
					throw new IllegalArgumentException ( msg0 );
				}

				_sString = _sString.substr( 0, _nIndex + 1 ) + o + _sString.substring( _nIndex + 1 );
				_nSize++;
				_bAdded = true;

			} else
			{
				var msg1 : String = this + ".add() has been already called in this iteration";
				PixlibDebug.ERROR ( msg1 );
				throw new IllegalStateException ( msg1 );
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
			if ( !hasPrevious() )
			{
				var msg : String = this + " has no more element at '" + ( _nIndex ) +"' index.";
				PixlibDebug.ERROR ( msg );
				throw new NoSuchElementException ( msg );
			}

			_bAdded = false;
	    	_bRemoved = false;
			return _sString.substr( _nIndex-- * _nGap, _nGap );
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
		 * @throws 	<code>IllegalArgumentException</code> — The passed-in string couldn't be set due to its length
		 */
		public function set ( o : Object ) : void
		{
			if ( !_bRemoved && !_bAdded )
			{
				if ( ( o as String ).length != 1 )
				{
					var msg0 : String = this + ".add() failed, expected length 1, get '" + (o as String).length +"' length.";
					PixlibDebug.ERROR ( msg0 );
					throw new IllegalArgumentException ( msg0 );
				}

				_sString = _sString.substr( 0, _nIndex ) + o + _sString.substr( _nIndex + 1 );

			} else
			{
				var msg1 : String = this + ".add() or " + this + ".remove() have been " +
									"already called in this iteration, the set() operation cannot be done";
				PixlibDebug.ERROR ( msg1 );
				throw new IllegalStateException ( msg1 );
			}
		}
	}
}
