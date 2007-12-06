
package com.bourre.structures {
	import com.bourre.collection.Collection;
	import com.bourre.collection.Iterator;
	import com.bourre.collection.TypedArray;
	import com.bourre.collection.TypedContainer;
	import com.bourre.error.NullPointerException;
	import com.bourre.error.UnsupportedOperationException;
	import com.bourre.log.PixlibDebug;
	import com.bourre.log.PixlibStringifier;	

	/** 
	 * A <code>Grid</code> is basically a two dimensionnal data structure based on the <code>Collection</code>
	 * interface.
	 * 
	 * <p>By default a <code>Grid</code> object is an untyped collection that allow duplicate 
	 * and <code>null</code> elements. You can set your own default value instead
	 * of <code>null</code> by passing it to the grid constructor.</p>
	 * 
	 * <p>Its also possible to restrict the type of grid elements in the constructor.</p>
	 * 
	 * <p>The <code>Grid</code> class don't support all the methods of the <code>Collection</code>
	 * interface. Here the list of the unsupported methods : 
	 * <ul>
	 * 	<li><code>add</code></li>
	 * 	<li><code>addAll</code></li>
	 * 	<li><code>isEmpty</code></li>
	 * </ul></p>
	 * 
	 * <p>Instead of using the methods above there are several specific methods to insert data in the
	 * grid : 
	 * <ul>
	 * 	<li><code>setVal</code> : Use it to insert value in the grid</li>
	 * 	<li><code>setContent</code> : Use it to set the grid with the passed-in array.</li>
	 * 	<li><code>fill</code> : Use it to fill the grid with the same value in all cells.</li>
	 * </ul></p>
	 * 
	 * @author	Cédric Néhémie 
	 * @version 1.0
	 */
	public class Grid 
		implements Collection, TypedContainer
	{
	
		protected var _vSize : Point;
		protected var _aContent : Array;
		protected var _oDefaultValue : Object;
		protected var _cType : Class;
		
		/**
		 * Create a new grid of size <code>x * y</code>.
		 * 
		 * <p>If <code>a</code> is set, and if it have the same size that the grid, 
		 * it's used to fill the collection at creation.</p>
		 * 
		 * <p>If <code>dV</code> is set, all <code>null</code> elements in the grid
		 * will be replaced by <code>dV</code> value.</p>
		 * 
		 * @param	x	Width of the grid.
		 * @param	y	Height of the grid.
		 * @param	a	An array to fill the grid with.
		 * @param 	dV 	The default value for null elements.
		 * @throws	ArgumentError	Invalid size passed in Grid constructor.
		 */
		public function Grid ( x : uint = 1, 
							   y : uint = 1, 
							   a : Array = null, 
							   dV : Object = null, 
							   t : Class = null )
		{
			if( isNaN ( x ) || isNaN ( y ) )
			{
				PixlibDebug.ERROR( "Invalid size in Grid constructor : [" + x + ", " + y + "]" );
				throw new ArgumentError ( "Invalid size in Grid constructor : [" + x + ", " + y + "]" );
			}
			
			_vSize = new Point ( x, y );
			_oDefaultValue = dV;
			_cType = t != null ? t : Object;
			
			initContent();
			 
			if( a != null )
			{
				setContent ( a );
			}
			else if( _oDefaultValue != null )
			{
				fill( _oDefaultValue );
			}
		}
		
		/**
		 * Return the <code>String</code> representation of the object.
		 * 
		 * @return <code>String</code> representation of the object.
		 */
		public function toString () : String
		{
			return PixlibStringifier.stringify( this ) + " [" + _vSize.x + ", " + _vSize.y + "]";
		}
		
		/*
		 * Collection interface API implementation
		 */
		
		/**
		 * Returns <code>true</code> if this collection contains the specified
	     * element.
	     *
	     * @param 	o 	element whose presence in this collection is to be tested.
	     * @return 	<code>true</code> if this collection contains the specified
	     *         	element
		 */
		public function contains( o : Object ) : Boolean
		{
			var i : Iterator = iterator();
			
			while( i.hasNext() )
			{
				if( i.next() === o )
					return true;
			}
			return false;
		}
		
		/**
		 * Returns an array containing all of the elements in this collection. 
		 * The grid guarantees that the order of its elements is the one
	     * returned by its iterator.
	     * 
	     * @return 	an array containing all of the elements in this collection
		 */
		public function toArray() : Array
		{
			var a : Array = [];
			var i : Iterator = iterator();
			
			while ( i.hasNext() ) a.push( i.next() );
			
			return a;
		}
		
		/**
		 * A <code>Grid</code> object is considered as empty if and only if all its cells
		 * contains <code>null</code> or the default value for the current <code>Grid</code>.
		 * 
		 * @return 	<code>true</code> if the grid is empty, either <code>false</code>.
		 */
		public function isEmpty() : Boolean
		{
			var b : Boolean = false;
			var i : Iterator = iterator();
			
			while ( i.hasNext() )
			{
				b = ( i.next() != _oDefaultValue ) || b;
			}
			return !b;
		}
		
		/**
		 * Removes all instance of the specified element from this
	     * collection, if this collection contains one or more such
	     * elements.  
	     * 
	     * <p>Returns <code>true</code> if this collection contained the specified
	     * element (or equivalently, if this collection changed as a result of the
	     * call).</p>
	     * 
	     * <p>Returns <code>false</code> if this collection don't changed as result
	     * of the call, or if you trying to remove the default value for the grid.</p>
	     * 
	     * @param 	o	 element to be removed from this collection, if present.
	     * @return 	<code>true</code> if this collection changed as a result of the call
		 */
		public function remove( o : Object ) : Boolean
		{
			if( o === _oDefaultValue ) 
				return false;
			
			var i : Iterator = iterator ();
			var b : Boolean = false;
			
			while( i.hasNext() )
			{
				var e : Object = i.next ();
				if( e === o )
				{
					i.remove();
					b = true;
				}
			}
			if( !b ) 
			{
				PixlibDebug.ERROR( o + " can't be found in " + this + ".remove()" );
			}
			return b;
		}
				
		/**
		 * Removes all of the elements from this collection.
	     * This collection will not be empty after this method.
	     * 
	     * <p>If a default value have been defined for the grid
	     * then all cells of the grid contains that value.</p>
		 */
		public function clear() : void
		{
			fill ( _oDefaultValue );
		}
		
		/**
		 * Returns an iterator over the elements in this collection. Iterations
		 * are performed in the following order : columns first, rows after. 
		 * 
		 * <p>Result for a 2x2 grid : 
		 * <ul>
		 * 	<li>Cell 0, 0</li>
		 *  <li>Cell 1, 0</li>
		 * 	<li>Cell 0, 1</li>
		 * 	<li>Cell 1, 1</li>
		 * </ul></p>
	     * 
	     * @return 	an <code>Iterator</code> over the elements in this collection.
		 */
		public function iterator() : Iterator
		{
			return new _GridIterator( this );
		}
		
		/** 
		 * Removes all this collection's elements that are also contained in the
	     * specified collection.  After this call returns, this collection will 
	     * contain no elements in common with the specified collection.
	     * 
	     * <p>Value corresponding to the default value of the current grid is ignored
	     * by <code>removeAll</code>.</p>
	     *
	     * @param 	c elements to be removed from this collection.
	     * @return 	<code>true</code> if this collection changed as a result of the call
	     * @throws 	NullPointerException if the specified collection is <code>null</code>.
	     * @see 	#remove(Object)
	     * @see 	#contains(Object)
		 */
		public function removeAll( c : Collection ) : Boolean
		{
			if( c == null ) 
			{
				PixlibDebug.ERROR( "The passed-in collection is null in " + this + ".removeAll()" );
				throw new NullPointerException ( "The passed-in collection is null in " + this + ".removeAll()" );
			}
			
			var b : Boolean = false;
			var i : Iterator = c.iterator();
			while( i.hasNext() )
			{
				var o : Object = i.next();
				if( o != _oDefaultValue )	b = remove( o ) || b;
			} 
			return b;
		}
		
		/**
		 * Returns <code>true</code> if this collection contains all of the elements
	     * in the specified collection.
	     *
	     * @param  c collection to be checked for containment in this collection.
	     * @return <tt>true</tt> if this collection contains all of the elements
	     *	       in the specified collection
	     * @throws NullPointerException if the specified collection is <code>null</code>.
	     * @see    #contains(Object)
		 */
		public function containsAll( c : Collection ) : Boolean
		{
			if( c == null ) 
			{
				PixlibDebug.ERROR( "The passed-in collection is null in " + this + ".containsAll()" );
				throw new NullPointerException ( "The passed-in collection is null in " + this + ".containsAll()" );
			}
			
			var i : Iterator = c.iterator();
			while( i.hasNext() ) if( !contains( i.next() ) ) return false;
			return true;
		}
		
		/**
		 * The <code>addAll</code> method is unsupported by the <code>Grid</code> class.
		 * 
		 * @return 	<code>Boolean</code>
		 * @throw 	UnsupportedOperationException The addAll method of the Collection interface is unsupported by the Grid Class
		 */
		public function addAll( c : Collection ) : Boolean
		{
			PixlibDebug.ERROR( this + ".addAll() method is unsupported." );
			throw new UnsupportedOperationException ( "The addAll method of the Collection interface is unsupported by the Grid class" );
			return false;
		}
		
		/**
		 * Retains only the elements in this collection that are contained in the
	     * specified collection (optional operation).  In other words, removes from
	     * this collection all of its elements that are not contained in the
	     * specified collection.
	     *
	     * @param 	c 	elements to be retained in this collection.
	     * @return 	<tt>true</tt> if this collection changed as a result of the
	     *         	call
	     * @throws 	NullPointerException if the specified collection is <code>null</code>.
	     * @see 	#remove(Object)
	     * @see 	#contains(Object)
		 */
		public function retainAll( c : Collection ) : Boolean
		{
			if( c == null ) 
			{
				PixlibDebug.ERROR( "The passed-in collection is null in " + this + ".retainAll()" );
				throw new NullPointerException ( "The passed-in collection is null in " + this + ".retainAll()" );
			}
			
			var b : Boolean = false;
			var i : Iterator = iterator();
			
			while( i.hasNext() )
			{
				var o : Object = i.next();	
				if ( o != _oDefaultValue && !(c.contains( o )) ) b = remove( o ) || b;
			}
			return b;
			
		}
		
		/**
		 * The <code>add</code> method is unsupported by the <code>Grid</code> class.
		 * 
		 * @return 	<code>Boolean</code>
		 * @throw 	UnsupportedOperationException The add method of the Collection interface is unsupported by the Grid Class
		 */
		public function add( o : Object ) : Boolean
		{
			PixlibDebug.ERROR( this + ".add() method is unsupported." );
			throw new UnsupportedOperationException ( "The add method of the Collection interface is unsupported by the Grid class" );
			return false;
		}
		
		/**
	     * Returns the number of elements this collection can contains.
	     * 
	     * @return the number of elements this collection can contains.
	     */
		public function size() : uint
		{
			return _vSize.x * _vSize.y;
		}
		
		/*
		 * Grid specific API
		 */
		
		/**
		 * Verify if the passed-in object can be inserted in the
		 * current <code>Grid</code>.
		 * 
		 * @param	o	Object to verify
		 * @return 	<code>true</code> if the object can be inserted in
		 * the <code>Grid</code>, either <code>false</code>.
		 */
		public function isType( o : * ) : Boolean
	    {
	    	return ( o is _cType || o == null );
	    }
	    
	    /**
	     * Return the current type allowed in the <code>Grid</code>
	     * 
	     * @return <code>Class</code> used to type checking.
	     */
	    public function getType () : Class
	    {
	    	return _cType;
	    }
	    
		/**
		 * @private
		 */
		protected function initContent() : void 
		{
			_aContent  = new Array( _vSize.x );
			for ( var x : Number = 0; x < _vSize.x; x++ ) 
				_aContent[ x ] = new TypedArray( _cType, _vSize.y );
		}
		
		/**
		 * Fill the current grid with the passed-in value.
		 *
		 * <p>If the passed-in value is a "real" object (not a primitive) then
		 * all cells contains a reference to the same object.</p>
		 *  
		 * @param	o	Value used to fill the grid.
		 */
		public function fill ( o : Object ) : void
		{
			var i : Iterator = iterator ();
			
			while ( i.hasNext() )
			{
				i.next();
				
				setVal ( i as _GridIterator, o );
			}
		}
		
		/**
		 * Remove the value locate at the passed-in coordinate.
		 * 
		 * <p>If the grid changed after the call the function returns
		 * <code>true</code>. If the passed-in <code>Point</code> isn't
		 * a valid coordinate for this grid the function failed and return
		 * <code>false</code>.</p>
		 * 
		 * <p>If a default value is set, the cell contains that value instead
		 * of <code>null</code> after the call.</p>
		 * 
		 * @param	p	Position of the value to remove.
		 * @return 	<code>true</code> if the grid changed as result of the call.
		 */
		public function removeAt ( p : Point ) : Boolean
		{			
			return setVal ( p, _oDefaultValue );			
		}
		
		/**
		 * Check if a <code>Point</code> object is a valid coordinate
		 * in the current grid.
		 * 
		 * @param	p	<code>Point</code> object to check.
		 * @return 	<code>true</code> if passed-in <code>Point</code> is a valid
		 * 			coordinate for the current grid.
		 */
		public function isGridCoords ( p : Point ) : Boolean
		{
			return ( p.x >= 0 && p.x < _vSize.x && p.y >= 0 && p.y < _vSize.y );
		}
		
		/**
		 * Returns the size of the grid as <code>Point</code>.
		 * 
		 * <p>The returned <code>Point</code> is a copy 
		 * of the internal one.</p>
		 * 
		 * @return 	the dimensions of the grid as <code>Point</code>.
		 */
		public function getSize () : Point
		{
			return _vSize.clone(); 
		}
		
		/**
		 * Return a <code>Point</code> witch is the corresponding
		 * position of the passed-in value.
		 * 
		 * @param 	id	An integer to convert in a two dimension location.
		 * @return 	<code>Point</code> corresponding location.
		 */
		public function getCoordinates ( id : Number ) : Point
		{
			var nY : Number = Math.floor( id / _vSize.x );
			return new Point( id - ( nY * _vSize.x ), nY );
		}
		
		/**
		 * Return a value of the grid with it's position.
		 * 
		 * @param 	p	Coordinates <code>Point</code> in the grid.
		 * @return  Value stored at the coorespoding location.
		 */
		public function getVal ( p : Point ) : Object
		{
			if( !isGridCoords ( p ) )
			{
				PixlibDebug.ERROR( p + " is not a valid coordinates in " + this );
				return null;
			}
			return _aContent [ p.x ][ p.y ];
		}
			
		/**
		 * Defines value of grid cell defining by passed-in <code>Point</code> 
	 	 * coordinate.
	 	 * 
	 	 * <p>The call return <code>true</code> only if the <code>Grid</code>
	 	 * changed as results of the call.</p>
		 * 
		 * @param 	p	Cell <code>Point</code> position.
		 * @param 	o	Value to store in the grid.
		 * @return  <code>true</code> if the <code>Grid</code> changed as results of the call.
		 */
		public function setVal ( p : Point, o : Object ) : Boolean
		{
			if( !isGridCoords ( p ) )
			{
				PixlibDebug.ERROR( p + " is not a valid coordinates in " + this );
				return false;
			}
			if( o === _aContent [ p.x ][ p.y ])
			{
				return false;
			}
			
			if( o == null && _oDefaultValue != null ) 
				o = _oDefaultValue;
			
			
			_aContent [ p.x ][ p.y ] = o;
			return true;
		}
		
		/**
		 * Fill the content with an array of witch length is equal to
		 * the grid <code>size()</code>.
		 * 
		 * <p>The call return <code>true</code> only if the <code>Grid</code>
	 	 * changed as results of the call.</p>
		 * 
		 * @param 	a	An <code>Array</code> to fill the <code>Grid</code>.
		 * @return 	<code>true</code> if the <code>Grid</code> changed as results of the call.
		 */
		public function setContent ( a : Array ) : Boolean
		{
			if( a.length != size () )
			{
				PixlibDebug.ERROR( "Passed-in array doesn't match " + this + ".size()");
				return false;
			}
			var l : Number = a.length;
			var b : Boolean = false;
			while (--l-(-1))
			{
				var p : Point = getCoordinates ( l );
				b = setVal ( p, a[ l ] ) || b;
			}
			
			return true;
		}
	}
}

import com.bourre.collection.Iterator;
import com.bourre.structures.Grid;
import com.bourre.structures.Point;

internal class _GridIterator extends Point
	implements Iterator
{
	
	private var _nIndex : Number;
	private var _nLength : Number;
	private var _oGrid : Grid;	
	
	public function _GridIterator ( g : Grid )
	{
		_oGrid = g;
		_nIndex = -1;
		_nLength = _oGrid.size();
	}
	
	public function hasNext() : Boolean
	{
		return ( _nIndex + 1 ) < _nLength;
	}
 	public function next() : *
 	{
 		reset( _oGrid.getCoordinates( ++_nIndex ) );
		return _oGrid.getVal( this );
 	}
    public function remove() : void
    {
    	_oGrid.removeAt( this );
    }
}