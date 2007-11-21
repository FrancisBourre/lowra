package com.bourre.collection 
{	
	import com.bourre.error.UnsupportedOperationException;	
	import com.bourre.collection.Iterator;
	import com.bourre.error.IllegalStateException;
	import com.bourre.error.NoSuchElementException;		

	/**
	 * @author Cedric Nehemie
	 */
	public class ObjectIterator implements Iterator 
	{
	    protected var _oObject : Object;
	    protected var _aKeys : Array;
		protected var _nSize : Number;
		protected var _nIndex : Number;
	    protected var _bRemoved : Boolean;
		
		public function ObjectIterator ( o : Object )
		{
			_oObject = o;
			_aKeys = new Array();
			
			for( var k : String in _oObject ) { _aKeys.push( k ); }
			
			_nIndex = -1;
			_nSize = _aKeys.length;
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
			return _oObject[ _aKeys[ ++_nIndex ] ];
		}
		
		public function remove () : void
		{
			if( !_bRemoved )
			{
				if( delete _oObject[ _aKeys[ _nIndex ] ] )
				{
					_nIndex--;
					_bRemoved = true;
				}
				else
				{
					throw new UnsupportedOperationException( this + ".remove() can't delete " + _oObject + "." + _aKeys[ _nIndex ] );
				}
			}
			else
			{
				throw new IllegalStateException ( this + ".remove() have been already called" );
			}
		}
	}
}
