package com.bourre.collection 
{
	import com.bourre.collection.Iterator;
	import com.bourre.error.IllegalStateException;
	import com.bourre.error.NoSuchElementException;	

	/**
	 * @author Cedric Nehemie
	 */
	public class ArrayIterator implements Iterator 
	{
	    protected var _aArray : Array;
	    protected var _nSize : Number;
	    protected var _nIndex : Number;
	    protected var _bRemoved : Boolean;

		public function ArrayIterator ( a : Array )
	    {
	        _aArray = a;
	        _nSize = a.length;
	        _nIndex = -1;
			_bRemoved = false;
		}
	
	    public function hasNext () : Boolean
	    {
	        return ( _nIndex + 1 < _nSize );
	    }
	   
	    public function next () : *
	    {
	    	if( !hasNext() )
				throw new NoSuchElementException ( this + " has no more elements at " + ( _nIndex + 1 ) );
			
	    	_bRemoved = false;
	        return _aArray[ ++_nIndex ];
	    }
		
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
				throw new IllegalStateException ( this + ".remove() have been already called" );
			}
		}
	}
}
