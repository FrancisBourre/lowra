package com.bourre.collection 
{
	import com.bourre.error.UnsupportedOperationException;	
	import com.bourre.collection.Iterator;
	import com.bourre.error.NoSuchElementException;	

	/**
	 * @author Cédric Néhémie
	 */
	public class XMLListIterator implements Iterator 
	{
		private var list : XMLList;
		private var length : Number;
		private var index : Number;

		public function XMLListIterator ( list : XMLList )
		{
			this.list = list;
			this.length = list.length();
			index = -1;
		}

		public function hasNext () : Boolean
		{
			return index + 1 < length;
		}
		
		public function next () : *
		{
			if( !hasNext() )
				throw new NoSuchElementException ( this + " has no more elements at " + ( index + 1 ) );
			
			return list[ ++index ];
		}
		
		public function remove () : void
		{
			throw new UnsupportedOperationException( "remove is not currently supported by the XMLListIterator" );
		}
	}
}
