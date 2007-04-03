package com.bourre.collection
{
	import com.bourre.error.*;
	import com.bourre.utils.ObjectUtils;
	import com.bourre.log.PixlibDebug;
	import com.bourre.log.PixlibStringifier;
	
	public class Set 
		implements List, TypedContainer
	{
		private var _aSet : TypedArray;

		public function Set (type : Class = null)
		{
			this._aSet = new TypedArray( type );
		}
		
		public function add( o : Object) : Boolean
		{
			push(o);
			return true;
		}

		public function addAt(index:uint, o:Object) : void
		{
			isValidIndex ( index );
			_aSet.splice( index, 0, o );
		} 

		public function addAll(c:Collection):Boolean
		{
			isValidCollection( c );
			
			var iter : Iterator = c.iterator();
			var modified : Boolean = false;
			while(iter.hasNext())
			{
				modified = add( iter.next() ) || modified;
			}
			return modified;
			
		}

		public function addAllAt( index : uint, c : Collection ) : Boolean
		{
			isValidIndex ( index );
			isValidCollection( c );
			
			var i : Iterator = c.iterator();
			
			while(i.hasNext())
			{
				addAt( index++, i.next() );
			}
			
			return true;
		}

		public function remove( o : Object ) : Boolean
		{
			var fromIndex : int = 0;
			var find :Boolean = false;
			
			while( ( fromIndex = search ( o ) ) != -1 )
			{
				find = removeAt( fromIndex ) || find;
			}
			return find;
		}

		public function removeAt( index : uint ) : Boolean
		{
			isValidIndex ( index );
			_aSet.splice( index, 1 );
			return true;			
		}

		public function removeAll( c : Collection ) : Boolean
		{
			isValidCollection( c );
			
			var iter : Iterator = c.iterator();
			var find :Boolean = false;
			while( iter.hasNext() )
			{
				find = remove( iter.next() ) || find;
			}
			return find;
		}

		public function retainAll(c:Collection):Boolean
		{
			isValidCollection( c );
			
			var b : Boolean = false;
			var i : Iterator = iterator();
			
			while( i.hasNext() )
			{
				var o : Object = i.next();	
				if ( !( c.contains( o ) ) ) b = remove( o ) || b;
			}
			return b;
		}

		public function contains(o:Object):Boolean
		{
			return _aSet.indexOf(o) != -1;
		}

		public function containsAll(c:Collection):Boolean
		{
			isValidCollection( c );
			
			var iter : Iterator = c.iterator()
			
			while( iter.hasNext() )
			{
				if( !contains( iter.next() ) ) return false;
			}
			return true;
		}

		public function search(o : Object ) : int
		{
			return _aSet.indexOf(o);
		}		

		public function indexOf( o : Object ) : int
		{
			return _aSet.indexOf(o);
		}

		public function lastIndexOf( o : Object ) : int
		{
			return _aSet.lastIndexOf(o);
		}

		public function clear():void
		{
			_aSet.splice( 0, size() );
		}

		public function iterator():Iterator
		{
			return new SetIterator(this);
		}

		public function listIterator( index : uint = 0 ) : ListIterator
		{
			isValidIndex ( index );
			
			return new SetIterator ( this, index );
		}

		public function size():uint
		{
			return _aSet.length;
		}

	    public function get ( index : uint ) : Object
		{
			isValidIndex ( index );
			return _aSet[ index ];
		}

		public function set ( index : uint, o : Object ) : Object
		{
			isValidIndex ( index );
			return _aSet.splice( index, 1, o )[0];
		}

		public function peek() :Object
		{
			return _aSet[ size() - 1 ];
		}

		public function pop() : Object
		{
			return _aSet.pop()
		}

		public function push (item : Object) : Object
		{
			_aSet.push(item)
			return item;
		}

	    public function subList( fromIndex:uint, toIndex:uint ) : List
		{
			isValidIndex( fromIndex );
			isValidIndex( toIndex );
			
			var l : List = new Set( _aSet.getType() );
			for(var i : Number = fromIndex;i < toIndex;i++)
			{
				l.add( _aSet[ i ] );
			}
			return l;
		}

		public function isValidIndex ( index : uint ) : void
		{
			if( index >= size() )
			{
				PixlibDebug.ERROR( index + " is not a valid index for the current Set("+ size() +")" );
				throw new IndexOutOfBoundsException ( index + " is not a valid index for the current Set("+ size() +")");
			}
		}

		public function isValidCollection ( c : Collection ) : void
		{
			if( c == null ) 
			{
				PixlibDebug.ERROR( "The passed-in collection is null in " + this + ".containsAll()" );
				throw new NullPointerException ( "The passed-in collection is null in " + this + ".containsAll()" );
			}
		}

		public function isEmpty():Boolean
		{
			return size() == 0;
		}

		public function isType( o : * ) : Boolean
		{
			return _aSet.isType( o );
		}

		public function getType() : Class
		{
			return _aSet.getType();
		}

		public function toArray() : Array
		{
			return _aSet.toArray();
		}

		public function toString () : String
		{
			return PixlibStringifier.stringify( this );
		}
	}
}

import com.bourre.collection.Set;
import com.bourre.collection.TypedArray;
import com.bourre.collection.ListIterator;
internal class SetIterator 
	implements ListIterator
{
	private var _c : Set;
	private var _nIndex : int;
	private var _nLastIndex : int;
	private var _a : Array
	
	public function SetIterator( c : Set, index : uint = 0 )
	{
		_c = c;
		_nIndex = index - 1;
		_a = c.toArray();
		_nLastIndex = _a.length - 1;
	}
	
	public function hasNext() : Boolean
	{
		return _nIndex + 1 <= _nLastIndex;
	}
	
 	public function next() : *
 	{
 		return _a[ ++_nIndex ];
 	}
 	public function previous() : *
 	{
 		return _a[ _nIndex-- ];
 	}
 	
    public function remove() : void
    {
    	_c.removeAt( _nIndex-- );
    	_a = _c.toArray();
    	_nLastIndex--;
    }
    public function add ( o : Object ) : void
    {
    	_c.addAt( ++_nIndex, o );
    	_a = _c.toArray();
    	_nLastIndex++;
    }		
		
	public function hasPrevious () : Boolean
	{
		return _nIndex >= 0;
	}	
	
	public function nextIndex () : uint
	{
		return _nIndex + 1;
	}
	public function previousIndex () : uint
	{
		return _nIndex;
	}	
	
	public function set ( o : Object ) : void
	{
		_c.set ( _nIndex, o );
	}
}