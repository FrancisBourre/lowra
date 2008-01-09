package com.bourre.ioc.parser 
{
	import com.bourre.collection.Iterable;
	import com.bourre.collection.Iterator;
	import com.bourre.collection.ArrayIterator;	public class ParserCollection 
		implements Iterable
	{
		protected var _a : Array;
		
		public function ParserCollection( a : Array = null ) 
		{
			_a = a;
		}
		
		public function push( parser : AbstractParser ) : void
		{
			_a.push( parser );
		}

		public function iterator() : Iterator
		{
			return new ArrayIterator( _a );
		}
	}}