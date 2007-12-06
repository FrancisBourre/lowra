package com.bourre.collection {
	import com.bourre.error.*;
	import com.bourre.log.PixlibDebug;
	import com.bourre.log.PixlibStringifier;	
	/**
	 * The Stack class represents a last-in-first-out (LIFO) stack
	 * of objects. The usual push and pop operations are provided,
	 * as well as a method to peek at the top item on the stack,
	 * a method to test for whether the stack is empty, and a method
	 * to search the stack for an item and discover how far it is
	 * from the top.
	 * 
	 * <p>When a stack is first created, it contains no items.</p>
	 * 
	 * @author Romain Flacher
	 * @author Cédric Néhémie
	 * @version 1.0
	 * @see List
	 * @example Using a <code>Stack</code>
	 * <listing>var os : Stack = new Stack ( Number );
	 * os.push(20)
	 * os.push("20"); // throw an error because "20" isn't a Number
	 * </listing>
	 */
	
	public class Stack implements List, TypedContainer
	{
		private var _aStack : TypedArray;
		
		/**
		 * Create an empty Stack.
		 * 
		 * <p>You can pass the type for stack elements as argument
		 * of the constructor.</p>
		 * 
		 * @param type A Class instance used as type for elements
		 */
		public function Stack (type : Class = null, content : Array = null )
		{
			this._aStack = new TypedArray( type );
			
			if( content )
			{
				var l : Number = content.length;
				
				for( var i : Number = 0; i < l ; i++ )
				{
					add ( content[ i ] );
				}
			}
		}
		
		/**
		 * Appends the specified element to the end of this Stack.
		 * 
		 * @param o element to be appended to this Stack
		 * @return true (as per the general contract of Collection.add).
		 * @see	push
		 * @throws ClassCastException if the class of the specified
		 * 		   element prevents it from being added to this list.
		 */
		public function add( o : Object ) : Boolean
		{
			push(o);
			return true;
		}
		
		/**
		 * Inserts the specified element at the specified position
		 * in this Stack. Shifts the element currently at that
		 * position (if any) and any subsequent elements to the
		 * right (adds one to their indices).
		 * 
		 * @param index index at which the specified element is to be inserted.
		 * @param o element to be inserted.
		 * @throws IndexOutOfBoundsException index is out of range
		 * 		   (index < 0 || index > size()).
		 * @throws ClassCastException if the class of the specified
		 * 		   element prevents it from being added to this list.
		 */
		public function addAt(index:uint, o:Object) : void
		{
			isValidIndex ( index );
			_aStack.splice( index, 0, o );
		} 
		
		/**
		 * Appends all of the elements in the specified Collection
		 * to the end of this <code>Stack</code>, in the order that they are
		 * returned by the specified Collection's Iterator. 
		 * The behavior of this operation is undefined if the
		 * specified Collection is modified while the operation
		 * is in progress. (This implies that the behavior of this
		 * call is undefined if the specified Collection is this
		 * <code>Stack</code>, and this <code>Stack</code> is nonempty.)
		 * 
		 * @param c elements to be inserted into this <code>Stack</code>.
		 * @return true if this <code>Stack</code> changed as a result of the call.
		 * @throws ClassCastException if the class of an element of the specified
	     * 	       collection prevents it from being added to this collection.
	     * @throws NullPointerException if the passed in collection is null.
		 */
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
		
		/**
		 * Inserts all of the elements in the specified Collection into
		 * this <code>Stack</code> at the specified position. Shifts the element
		 * currently at that position (if any) and any subsequent
		 * elements to the right (increases their indices). The new
		 * elements will appear in the <code>Stack</code> in the order that
		 * they are returned by the specified Collection's iterator.
		 * 
		 * @param index index at which to insert first element from
		 * 		  		the specified collection.
		 * @param c elements to be inserted into this <code>Stack</code>.
		 * @return true if this <code>Stack</code> changed as a result of the call.
		 * @throws IndexOutOfBoundsException index is out of range
		 * 		   (index < 0 || index > size()).
		 * @throws ClassCastException if the class of an element of the specified
	     * 	       collection prevents it from being added to this collection.
	     * @throws NullPointerException if the passed in collection is null.
		 */
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
		
		/**
		 * Remove all the reference to the passed-in object if it
		 * can be found in the current <code>Stack</code>.
		 * 
		 * @param o The object to remove
		 * @return true if the object have been removed, false otherwise.
		 */
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
		
		/**
		 * Removes the element at the specified position in this <code>Stack</code>.
		 * Shifts any subsequent elements to the right (subtracts one from
		 * their indices).
		 * 
		 * @param index index at which to remove an element from the specified collection.
		 * @return true if the object have been removed, false otherwise.
		 * @throws IndexOutOfBoundsException index is out of range
		 * 		   (index < 0 || index > size()).
		 */
		public function removeAt( index : uint ) : Boolean
		{
			isValidIndex ( index );
			_aStack.splice( index, 1 );
			return true;			
		}
		
		/**
		 * Removes from this <code>Stack</code> all of its elements that are contained
		 * in the specified Collection.
		 * 
		 * @param c a collection of elements to be removed from the <code>Stack</code>
		 * @return true if this <code>Stack</code> changed as a result of the call.
	     * @throws NullPointerException if the passed in collection is null.
		 */
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
		
		/**
		 * Retains only the elements in this <code>Stack</code> that are contained
		 * in the specified Collection. In other words, removes from
		 * this <code>Stack</code> all of its elements that are not contained in
		 * the specified Collection.
		 * 
		 * @param c a collection of elements to be retained in this
		 *          <code>Stack</code> (all other elements are removed)
		 * @return true if this <code>Stack</code> changed as a result of the call.
		 * @throws NullPointerException if the passed in collection is null.
		 */
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
		
		/**
		 * Tests if the specified object is a component in this <code>Stack</code>.
		 * 
		 * @param o an object.
		 * @return true if and only if the specified object is the same
		 *         as a component in this <code>Stack</code>, as determined by the
		 *         equals operator; false otherwise.
		 */
		public function contains(o:Object):Boolean
		{
			return _aStack.indexOf(o) != -1;
		}
	
		/**
		 * Returns true if this <code>Stack</code> contains all of the elements
		 * in the specified Collection.
		 * 
		 * @param c a collection whose elements will be tested for
		 *          containment in this <code>Stack</code>
		 * @return true if this <code>Stack</code> contains all of the elements
		 *         in the specified collection.
		 * @throws NullPointerException if the passed in collection is null.
		 */
		public function containsAll(c:Collection):Boolean
		{
			isValidCollection( c );
			
			var iter : Iterator = c.iterator();
			
			while( iter.hasNext() )
			{
				if( !contains( iter.next() ) ) return false;
			}
			return true;
		}
		
		/**
		 * Searches for the first occurence of the given argument.
		 * 
		 * @param o an object
		 * @return the index of the first occurrence of the object argument
		 * 		   in this <code>Stack</code>, that is, the smallest value k such that 
		 *         elem.equals(elementData[k]) && (k >= index) is true; 
		 *         returns -1 if the object is not found.
		 */
		public function search(o : Object ) : int
		{
			return _aStack.indexOf(o);
		}		
		
		/**
		 * Searches for the first occurence of the given argument.
		 * 
		 * @param o an object
		 * @return the index of the first occurrence of the object argument
		 * 		   in this <code>Stack</code>, that is, the smallest value k such that 
		 *         elem.equals(elementData[k]) && (k >= index) is true; 
		 *         returns -1 if the object is not found.
		 */
		public function indexOf( o : Object ) : int
		{
			return _aStack.indexOf(o);
		}
		
		/**
		 * Returns the index of the last occurrence of the specified
		 * object in this <code>Stack</code>.
		 * 
		 * @param o the desired component.
		 * @return the index of the last occurrence of the specified
		 *         object in this <code>Stack</code>, that is, the largest value
		 *         k such that elem.equals(elementData[k]) is true;
		 *         returns -1 if the object is not found.
		 */
		public function lastIndexOf( o : Object ) : int
		{
			return _aStack.lastIndexOf(o);
		}
		
		/**
		 * Removes all of the elements from this <code>Stack</code>. 
		 * The <code>Stack</code> will be empty after this call returns
		 * (unless it throws an exception).
		 */
		public function clear():void
		{
			_aStack.splice( 0, size() );
		}
		
		/**
		 * Returns an iterator over the elements in this list
		 * in proper sequence.
		 * 
		 * This implementation returns a straightforward implementation
		 * of the iterator interface.
		 * 
		 * @return an iterator over the elements in this list in proper sequence.
		 */
		public function iterator():Iterator
		{
			return new StackIterator(this);
		}
		
		/**
		 * Returns a list iterator of the elements in this list
		 * (in proper sequence), starting at the specified position
		 * in the list. The specified index indicates the first
		 * element that would be returned by an initial call to
		 * the next method. An initial call to the previous method
		 * would return the element with the specified index minus one.
		 * 
		 * This implementation returns a straightforward implementation
		 * of the ListIterator interface that extends the implementation
		 * of the Iterator interface returned by the iterator() method.
		 * The ListIterator implementation relies on the backing list's
		 * get(int), set(int, Object), add(int, Object) and remove(int)
		 * methods.
		 * 
		 * @param index index of the first element to be returned from
		 *        the list iterator (by a call to the next method).
		 * @return a list iterator of the elements in this list (in proper sequence),
		 *         starting at the specified position in the list.
		 * @throws IndexOutOfBoundsException index is out of range
		 * 		   (index < 0 || index > size()).
		 */
		public function listIterator( index : uint = 0 ) : ListIterator
		{
			isValidIndex ( index );
			
			return new StackIterator ( this, index );
		}

		/**
		 * Returns the number of components in this <code>Stack</code>.
		 * 
		 * @return the number of components in this <code>Stack</code>.
		 */
		public function size():uint
		{
			return _aStack.length;
		}
	    
	    /**
	     * Returns the element at the specified position in this <code>Stack</code>.
	     * 
	     * @param index index of element to return.
	     * @return object at the specified index
	     * @throws IndexOutOfBoundsException index is out of range
		 * 		   (index < 0 || index > size()).
	     */
	    public function get ( index : uint ) : Object
		{
			isValidIndex ( index );
			return _aStack[ index ];
		}
		
		/**
		 * Replaces the element at the specified position
		 * in this <code>Stack</code> with the specified element.
		 * 
		 * @param index index of element to replace.
		 * @param o element to be stored at the specified position.
		 * @return the element previously at the specified position.
		 * @throws IndexOutOfBoundsException index is out of range
		 * 		   (index < 0 || index > size()).
		 * @throws ClassCastException if the class of an element of the specified
	     * 	       collection prevents it from being added to this collection.
		 */
		public function set ( index : uint, o : Object ) : Object
		{
			isValidIndex ( index );
			return _aStack.splice( index, 1, o )[0];
		}
	    
		/**
		 * Looks at the object at the top of this stack
		 * without removing it from the stack.
		 * 
		 * @return the object at the top of this stack
		 * 		   (the last item of the object).
		 */
		public function peek() :Object
		{
			return _aStack[ size() - 1 ];
		}
	    
		/**
		 * Removes the object at the top of this stack and returns
		 * that object as the value of this function.
		 * 
		 * @return The object at the top of this stack
		 * 		   (the last item of the <code>Stack</code> object).
		 */
		public function pop() : Object
		{
			return _aStack.pop();
		}
	    
		/**
		 * Pushes an item onto the top of this stack. 
		 * This has exactly the same effect as:
		 * 
 		 * <listing>add(item)</listing>
		 * @param item the item to be pushed onto this stack..
		 * @return the item argument.
		 * 
		 */
		public function push (item : Object) : Object
		{
			_aStack.push(item);
			return item;
		}
		
		
	    /**
	     * Returns a view of the portion of this List between fromIndex,
	     * inclusive, and toIndex, exclusive. (If fromIndex and ToIndex
	     * are equal, the returned List is empty.) 
	     * 
	     * @param fromIndex low endpoint (inclusive) of the subList.
	     * @param toIndex high endpoint (exclusive) of the subList.
	     * @return a view of the specified range within this List.
	     * @throws IndexOutOfBoundsException fromIndex or toIndex are
	     * 		   out of range (index < 0 || index > size()).
	     */
	    public function subList( fromIndex:uint, toIndex:uint ) : List
		{
			isValidIndex( fromIndex );
			isValidIndex( toIndex );
			
			var l : List = new Stack( _aStack.getType() );
			for(var i : Number = fromIndex;i < toIndex;i++)
			{
				l.add( _aStack[ i ] );
			}
			return l;
		}
		
		/**
		 * Tests if the passed-in index is valid for the current <code>Stack</code>.
		 * If not a IndexOutOfBoundsException is thrown.
		 * 
		 * @param index index to verify
		 * @throws IndexOutOfBoundsException index is out of range
		 * 		   (index < 0 || index > size()).
		 */
		public function isValidIndex ( index : uint ) : void
		{
			if( index >= size() )
			{
				PixlibDebug.ERROR( index + " is not a valid index for the current Stack("+ size() +")" );
				throw new IndexOutOfBoundsException ( index + " is not a valid index for the current Stack("+ size() +")");
			}
		}
		
		/**
		 * Tests if the passed-in collection is a valid collection
		 * for internal operation such addAll, retainsAll or removeAll
		 * methods.
		 * 
		 * @param c collection to verify
		 * @throws NullPointerException if the passed in collection is null.
		 */
		public function isValidCollection ( c : Collection ) : void
		{
			if( c == null ) 
			{
				PixlibDebug.ERROR( "The passed-in collection is null in " + this + ".containsAll()" );
				throw new NullPointerException ( "The passed-in collection is null in " + this + ".containsAll()" );
			}
		}
		
		/**
		 * Tests if this stack is empty.
		 * 
		 * @return true if and only if this stack contains no items, false otherwise.
		 */
		public function isEmpty():Boolean
		{
			return size() == 0;
		}
		
		/**
		 * Verify if the passed-in object can be inserted in the
		 * current <code>Stack</code>.
		 * 
		 * @param	o	Object to verify
		 * @return 	<code>true</code> if the object can be inserted in
		 * the <code>Stack</code>, either <code>false</code>.
		 */
		public function isType( o : * ) : Boolean
		{
			return _aStack.isType( o );
		}
		
		/**
	     * Return the current type allowed in the <code>Stack</code>
	     * 
	     * @return <code>Class</code> used to type checking.
	     */
		public function getType() : Class
		{
			return _aStack.getType();
		}
		
		/**
		 * Returns an array containing all of the elements
		 * in this Stack in the correct order. 
		 * 
		 * @return an array containing all of the elements in this collection.
		 */
		public function toArray() : Array
		{
			return _aStack.toArray();
		}
		
		/**
		 * Returns the string representation of the object.
		 * 
		 * @return the string representation of the object.
		 */
		public function toString () : String
		{
			return PixlibStringifier.stringify( this );
		}
	}
}
import com.bourre.collection.ListIterator;
import com.bourre.collection.Stack;
internal class StackIterator 
	implements ListIterator
{
	private var _c : Stack;
	private var _nIndex : int;
	private var _nLastIndex : int;
	private var _a : Array;
	
	public function StackIterator( c : Stack, index : uint = 0 )
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