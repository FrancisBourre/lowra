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
	
	public class WeakCollection 
		implements Collection
	{
		private var _d : Dictionary;
		
		public function WeakCollection( a : Array = null )
		{
			clear();
			
			if ( a != null )
			{
				var l : int = a.length;
				if ( l > 0 ) while( --l > -1 ) add( a[ l ] );
			}
		}
		
		public function add( o : Object ) : Boolean
		{
			if ( _d[ o ] ) 
			{
				return false;
				
			} else
			{
				_d[ o ] = true;
				return true;
			}
		}
		
		public function addAll( c : Collection ) : Boolean
		{
			var b : Boolean = false;
			var i : Iterator = c.iterator();
			while( i.hasNext() ) b = add( i.next() ) || b;
			return b;
		}
		
		public function clear() : void
		{
			_d = new Dictionary( true );
		}
		
		public function contains( o : Object ) : Boolean
		{
			return ( _d[ o ] == true );
		}
		
		public function containsAll( c : Collection ) : Boolean
		{
			var i : Iterator = c.iterator();
			while( i.hasNext() ) if ( _d[ i.next() ] != true ) return false;
			return true;
		}
		
		public function isEmpty() : Boolean
		{
			return size() == 0;
		}
		
		public function iterator() : Iterator
		{
			return new _Iterator( this );
		}
		
		public function remove( o : Object ) : Boolean
		{
			if ( _d[ o ] ) 
			{
				_d[ o ] = null;
				return true;
				
			} else
			{
				return false;
			}
		}
		
		public function removeAll( c : Collection ) : Boolean
		{
			var b : Boolean = false;
			var i : Iterator = c.iterator();
			while( i.hasNext() ) b = remove( i.next() ) || b;
			return b;
		}
		
		public function retainAll( c : Collection ) : Boolean
		{
			var b : Boolean = false;
			var i : Iterator = iterator();
			
			while( i.hasNext() )
			{
				var o : Object = i.next();
				if ( !(c.contains( o )) ) b = remove( o ) || b;
			}
			
			return b;
		}
		
		public function size() : uint
		{
			return Math.max( toArray().length, 0 );
		}
		
		public function toArray() : Array
		{
			var a : Array = new Array();
			for ( var k : Object in _d ) if ( _d[k] ) a.push( k );
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

import com.bourre.collection.*;
import flash.utils.Dictionary;

internal class _Iterator 
	implements Iterator
{
	private var _c : WeakCollection;
	private var _nIndex : int;
	private var _nLastIndex : int;
	private var _a : Array;
	
	public function _Iterator( c : WeakCollection )
	{
		_c = c;
		_nIndex = -1;
		_a = _c.toArray();
		_nLastIndex = _a.length - 1;
	}
	
	public function hasNext() : Boolean
	{
		return _nLastIndex > _nIndex;
	}
	
 	public function next() : *
 	{
 		return _a[ ++_nIndex ];
 	}
 	
    public function remove() : void
    {
    	_c.remove( _a[ _nIndex ] );
    }
}