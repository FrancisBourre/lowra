package com.bourre.collection 
{
	import com.bourre.collection.Iterator;
	import com.bourre.error.IllegalStateException;
	import com.bourre.error.NoSuchElementException;		

	/**
	 * @author Cedric Nehemie
	 */
	public class StringIterator implements Iterator 
	{
		protected var _sString : String;
		protected var _nSize : Number;
		protected var _nIndex : Number;
		protected var _bRemoved : Boolean;

		public function StringIterator ( s : String ) 
		{
			_sString = s;
			_nSize = _sString.length;
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
			return _sString.substr( ++_nIndex, 1 );
		}
		
		public function remove () : void
		{
			if( !_bRemoved )
			{
				_sString.slice( _nIndex--, 1 );
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
