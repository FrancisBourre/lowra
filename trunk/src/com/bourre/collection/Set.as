package com.bourre.collection
{
	import com.bourre.error.*;
	import com.bourre.utils.ObjectUtils;
	import com.bourre.log.PixlibDebug;
	import com.bourre.log.PixlibStringifier;
	
/**
 * A collection that contains no duplicate elements.  More formally, sets
 * contain no pair of elements <code>e1</code> and <code>e2</code> such that
 * <code>e1.equals(e2)</code>, and at most one null element.  As implied by
 * its name, this interface models the mathematical <i>set</i> abstraction.<p>
 *
 * The <tt>Set</tt> interface places additional stipulations, beyond those
 * inherited from the <tt>Collection</tt> interface, on the contracts of all
 * constructors and on the contracts of the <tt>add</tt>, <tt>equals</tt> and
 * <tt>hashCode</tt> methods.  Declarations for other inherited methods are
 * also included here for convenience.  (The specifications accompanying these
 * declarations have been tailored to the <tt>Set</tt> interface, but they do
 * not contain any additional stipulations.)<p>
 *
 * The additional stipulation on constructors is, not surprisingly,
 * that all constructors must create a set that contains no duplicate elements
 * (as defined above).<p>
 *
 * Note: Great care must be exercised if mutable objects are used as set
 * elements.  The behavior of a set is not specified if the value of an object
 * is changed in a manner that affects equals comparisons while the object is
 * an element in the set.  A special case of this prohibition is that it is
 * not permissible for a set to contain itself as an element.
 *
 * <p>Some set implementations have restrictions on the elements that
 * they may contain.  For example, some implementations prohibit null elements,
 * and some have restrictions on the types of their elements.  Attempting to
 * add an ineligible element throws an unchecked exception, typically
 * <tt>NullPointerException</tt> or <tt>ClassCastException</tt>.  Attempting
 * to query the presence of an ineligible element may throw an exception,
 * or it may simply return false; some implementations will exhibit the former
 * behavior and some will exhibit the latter.  More generally, attempting an
 * operation on an ineligible element whose completion would not result in
 * the insertion of an ineligible element into the set may throw an
 * exception or it may succeed, at the option of the implementation.
 * Such exceptions are marked as "optional" in the specification for this
 * interface. 
 *
 * <p>This interface is a member of the 
 * <a href="{@docRoot}/../guide/collections/index.html">
 * Java Collections Framework</a>.
 *
 * @author  Olympe Dignat
 * @version 1.0
 * @see Collection
 */
	
	public class Set 
		implements Collection, TypedContainer
	{
		private var _aSet : TypedArray;

		public function Set (type : Class = null)
		{
			this._aSet = new TypedArray( type );
		}
		
  	/**
     * Adds the specified element to this set if it is not already present
     * (optional operation).  More formally, adds the specified element,
     * <code>o</code>, to this set if this set contains no element
     * <code>e</code> such that <code>(o==null ? e==null :
     * o.equals(e))</code>.  If this set already contains the specified
     * element, the call leaves this set unchanged and returns <tt>false</tt>.
     * In combination with the restriction on constructors, this ensures that
     * sets never contain duplicate elements.<p>
     *
     * The stipulation above does not imply that sets must accept all
     * elements; sets may refuse to add any particular element, including
     * <tt>null</tt>, and throwing an exception, as described in the
     * specification for <tt>Collection.add</tt>.  Individual set
     * implementations should clearly document any restrictions on the the
     * elements that they may contain.
     *
     * @param o element to be added to this set.
     * @return <tt>true</tt> if this set did not already contain the specified
     *         element.
	 *
     * @throws IllegalArgumentException if some aspect of the specified element
     *         prevents it from being added to this set.
     */
		public function add( o : Object) : Boolean
		{
			if(isValidObject(o))
			{
				_aSet.splice( _aSet.length, 0, o );
				return true ;
			}else
			{
				return false ;
			}				
		}

		 /**
		 * Adds an element at the specified index to this set if it's not
		 * already present and if the specified index is valid. 
		 * 
		 * @param index index where the element is going to be added
		 * @param o element to add
		 * @return <tt>true</tt> if the set changed
		 * 
		 * @throws IndexOutOfBoundsException if index isn't valid
		 * @throws IllegalArgumentException if the element's type isn't as expected
		 */
		public function addAt(index:uint, o:Object) : Boolean
		{
			isValidIndex ( index );
			if (isValidObject(o))
			{
				_aSet.splice( index, 0, o );
				return true ;
			}
			else
				return false ;
		}

  	 /**
     * Adds all of the elements in the specified collection to this set if
     * they're not already present (optional operation).  If the specified
     * collection is also a set, the <tt>addAll</tt> operation effectively
     * modifies this set so that its value is the <i>union</i> of the two
     * sets.  The behavior of this operation is unspecified if the specified
     * collection is modified while the operation is in progress.
     *
     * @param c collection whose elements are to be added to this set.
     * @return <tt>true</tt> if this set changed as a result of the call.
     * 
     * @throws IllegalArgumentException if some aspect of some element of the
     *		  specified collection prevents it from being added to this
     *		  set.
     * @see #add(Object)
     */
		public function addAll(c:Collection):Boolean
		{
			var modified : Boolean = false;
			if (isValidCollection( c ))
			{
				var iter : Iterator = c.iterator();

				while(iter.hasNext())
				{
					modified = add( iter.next() ) || modified;
				}
			}
			return modified;
		}

	 /**
     * Removes the specified element from this set if it is present (optional
     * operation).  More formally, removes an element <code>e</code> such that
     * <code>(o==null ?  e==null : o.equals(e))</code>, if the set contains
     * such an element.  Returns <tt>true</tt> if the set contained the
     * specified element (or equivalently, if the set changed as a result of
     * the call).  (The set will not contain the specified element once the
     * call returns.)
     *
     * @param o object to be removed from this set, if present.
     * @return true if the set contained the specified element.
     */
		public function remove( o : Object ) : Boolean
		{
			var fromIndex : int = 0;
			var find :Boolean = false;

			if (contains(o))
			{
				_aSet.splice( _aSet.indexOf(o), 1 );
				find = true ;
			}
			return find ;
		}
		
		/**
		 * Removes the element at the specified position in this <code>Set</code>.
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
			_aSet.splice( index, 1 );
			return true;			
		}

	 /**
     * Removes from this set all of its elements that are contained in the
     * specified collection (optional operation).  If the specified
     * collection is also a set, this operation effectively modifies this
     * set so that its value is the <i>asymmetric set difference</i> of
     * the two sets.
     *
     * @param  c collection that defines which elements will be removed from
     *           this set.
     * @return <tt>true</tt> if this set changed as a result of the call.
     * 
     * @throws NullPointerException if the specified collection is
     *           <tt>null</tt>.
     * @see    #remove(Object)
     */
		public function removeAll( c : Collection ) : Boolean
		{
			var find :Boolean = false;
			if (isValidCollection( c ))
			{
				var iter : Iterator = c.iterator();
				while( iter.hasNext() ) find = remove( iter.next() ) || find;
			}
			return find;
		}

	 /**
     * Retains only the elements in this set that are contained in the
     * specified collection (optional operation).  In other words, removes
     * from this set all of its elements that are not contained in the
     * specified collection.  If the specified collection is also a set, this
     * operation effectively modifies this set so that its value is the
     * <i>intersection</i> of the two sets.
     *
     * @param c collection that defines which elements this set will retain.
     * @return <tt>true</tt> if this collection changed as a result of the
     *         call.
     * @throws NullPointerException if the specified collection is
     *           <tt>null</tt>.
     * @see #remove(Object)
     */
		public function retainAll(c:Collection):Boolean
		{
			var b : Boolean = false;
			
			if (isValidCollection( c ))
			{
				var i : Iterator = iterator();
				
				while( i.hasNext() )
				{
					var o : Object = i.next();	
					if ( !( c.contains( o ) ) ) b = remove( o ) || b;
				}
			}
			return b;
		}

	  /**
     * Returns <tt>true</tt> if this set contains the specified element.  More
     * formally, returns <tt>true</tt> if and only if this set contains an
     * element <code>e</code> such that <code>(o==null ? e==null :
     * o.equals(e))</code>.
     *
     * @param o element whose presence in this set is to be tested.
     * @return <tt>true</tt> if this set contains the specified element.
     * @throws ClassCastException if the type of the specified element
     * 	       is incompatible with this set (optional).
     */
		public function contains(o:Object):Boolean
		{
			if (isValidType(o))
				return _aSet.indexOf(o) != -1;
			else
				return false ;
		}

 	 /**
     * Returns <tt>true</tt> if this set contains all of the elements of the
     * specified collection.  If the specified collection is also a set, this
     * method returns <tt>true</tt> if it is a <i>subset</i> of this set.
     *
     * @param  c collection to be checked for containment in this set.
     * @return <tt>true</tt> if this set contains all of the elements of the
     * 	       specified collection.
     * @throws NullPointerException if the specified collection is
     *         <tt>null</tt>.
     * @see    #contains(Object)
     */
		public function containsAll(c:Collection):Boolean
		{
			var b:Boolean = true ;
			
			if (isValidCollection( c ))
			{
				var iter : Iterator = c.iterator()
				
				while( iter.hasNext() )
				{
					var ok:Boolean = contains( iter.next() ) ;
					if( ok == false ) 
					{
						b = false;
					}
				}
			}else
			{
				b = false ;
			}

			return b;
		}
		
	 /**
     * Compares the specified object with this set for equality.  Returns
     * <tt>true</tt> if the specified object is also a set, the two sets
     * have the same size, and every member of the specified set is
     * contained in this set (or equivalently, every member of this set is
     * contained in the specified set).  This definition ensures that the
     * equals method works properly across different implementations of the
     * set interface.
     *
     * @param o Object to be compared for equality with this set.
     * @return <tt>true</tt> if the specified Object is equal to this set.
     */
		public function equals (o:Object):Boolean
		{
			if (o is Set)
			{
				var _set : Set = o as Set;
				if (_set.size() == size())
				{
					return containsAll(_set) ;
				}
				else
					return false ;
			}
			else
				return false ;
		}
	
		 /**
		 * Return the index of the object in this set
		 * @param o the object to find
		 * @return int
		 */
		public function indexOf( o : Object ) : int
		{
			return _aSet.indexOf(o);
		}

	 /**
     * Removes all of the elements from this set (optional operation).
     * This set will be empty after this call returns (unless it throws an
     * exception).
     */
		public function clear():void
		{
			_aSet.splice( 0, size() );
		}

  	/**
     * Returns an iterator over the elements in this set.  The elements are
     * returned in no particular order (unless this set is an instance of some
     * class that provides a guarantee).
     *
     * @return an iterator over the elements in this set.
     */
		public function iterator():Iterator
		{
			return new SetIterator(this);
		}

   /**
     * Returns the number of elements in this set (its cardinality).  If this
     * set contains more than <tt>Integer.MAX_VALUE</tt> elements, returns
     * <tt>Integer.MAX_VALUE</tt>.
     *
     * @return the number of elements in this set (its cardinality).
     */
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
		
 		 /**
		 * Test an index which must be inferior to the size of the set 
		 * @param index the uint value to test
		 * @throw IndexOutOfBoundsException
		 */
		public function isValidIndex ( index : uint ) : void
		{
			if( index >= size() )
			{
				PixlibDebug.ERROR( index + " is not a valid index for the current Set("+ size() +")" );
				throw new IndexOutOfBoundsException ( index + " is not a valid index for the current Set("+ size() +")");
			}
		}

		 /**
		 * Test a collection which must not be null, and which type of elements matches
		 * @return boolean <tt>true</tt> if the collection is valid
		 * @throw NullPointerException
		 * @throw IllegalArgumentException
		 */
		public function isValidCollection ( c : Collection ) : Boolean
		{
			if( c == null ) 
			{
				PixlibDebug.ERROR( "The passed-in collection is null in " + this + ".containsAll()" );
				throw new NullPointerException ( "The passed-in collection is null in " + this + ".containsAll()" );
			}
			else
			{
				var ok:Boolean = true ;
				var iter : Iterator = c.iterator();
				var test:Boolean ;
				while (iter.hasNext())
				{
					test = isValidType(iter.next()) ;
					if (test== false) 
					{
						ok = false ;
					}
				}
				return ok ;
			}
		}
		
		 /**
		 * Test is an object is valid (well-typed, not already present in the set)
		 * @return boolean <tt>true</true> if the object is valid
		 * @throw IllegalArgumentException
		 */
		public function isValidObject (o:Object):Boolean
		{				
			if (isValidType(o))
			{
				return ( _aSet.indexOf(o)==-1 );
			}
			else 
				return false ;
		}
		
		 /**
		 * Test if the Set is typed, and if it is, test if the type of 
		 * the object matches
		 * @return boolean
		 * @throw IllegalArgumentException
		 */
		public function isValidType(o:Object):Boolean
		{
			if (getType() != null)
			{
				if (isType(o))
					return true ;
				else
					throw new IllegalArgumentException("wrong type in "+toString()) ;
			}
			else
				return true ;
		}

   	/**
     * Returns <tt>true</tt> if this set contains no elements.
     *
     * @return <tt>true</tt> if this set contains no elements.
     */
		public function isEmpty():Boolean
		{
			return size() == 0;
		}

		 /**
		 * Test if the object has the same type as the set
		 * @return boolean
		 */
		public function isType( o : * ) : Boolean
		{
			return _aSet.isType( o );
		}

		 /**
		 * Return the type of the set
		 * @return Class
		 */
		public function getType() : Class
		{
			return _aSet.getType();
		}

 	/**
     * Returns an array containing all of the elements in this set.
     * Obeys the general contract of the <tt>Collection.toArray</tt> method.
     *
     * @return an array containing all of the elements in this set.
     */
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
    	_c.remove( _a[_nIndex--] );
    	_a = _c.toArray();
    	_nLastIndex--;
    }
    public function add ( o : Object ) : void
    {
    	_c.add( o );
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