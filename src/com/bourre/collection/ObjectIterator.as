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
	import com.bourre.collection.Iterator;
	import com.bourre.error.IllegalStateException;
	import com.bourre.error.NoSuchElementException;
	import com.bourre.error.UnsupportedOperationException;	

	/**
	 * The <code>ObjectIterator</code> utility provide a convenient way
	 * to iterate over properties of an object as you can do with a
	 * <code>Collection</code>.
	 * <p>
	 * Order of returned elements are not guarantee, the order is the
	 * same than the <code>for...in</code> one.
	 * </p><p>
	 * The object iterator can only iterate over the public properties
	 * of the object, as the <code>for...in</code> construct does.
	 * </p> 
	 * @author 	Cédric Néhémie
	 * @see		Iterator
	 */
	public class ObjectIterator 
		implements Iterator 
	{
	    protected var _oObject 	: Object;
	    protected var _aKeys 	: Array;
		protected var _nSize 	: Number;
		protected var _nIndex 	: Number;
	    protected var _bRemoved : Boolean;
		
		/**
		 * Creates a new object iterator over properties of
		 * the passed-in object.
		 * 
		 * @param	o	<code>Object</code> target for this iterator
		 */
		public function ObjectIterator ( o : Object )
		{
			_oObject 	= o;
			_aKeys 		= new Array();
			
			for( var k : String in _oObject ) { _aKeys.push( k ); }
			
			_nIndex 	= -1;
			_nSize 		= _aKeys.length;
			_bRemoved 	= false;
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
				var msg : String = this + " has no more elements at " + ( _nIndex + 1 );
				PixlibDebug.ERROR ( msg );
				throw new NoSuchElementException ( msg );
			}
				
			_bRemoved = false;
			return _oObject[ _aKeys[ ++_nIndex ] ];
		}
		
		/**
		 * @inheritDoc
		 */		
		public function remove () : void
		{
			if( !_bRemoved )
			{
				if( delete _oObject[ _aKeys[ _nIndex ] ] )
				{
					_nIndex--;
					_bRemoved = true;

				} else
				{
					var msg0 : String = this + ".remove() can't delete " + _oObject + "." + _aKeys[ _nIndex ];
					PixlibDebug.ERROR ( msg0 );
					throw new UnsupportedOperationException ( msg0 );
				}

			} else
			{
				var msg1 : String = this + ".remove() have been already called for this iteration";
				PixlibDebug.ERROR ( msg1 );
				throw new IllegalStateException ( msg1 );
			}
		}
	}
}
