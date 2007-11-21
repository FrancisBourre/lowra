package com.bourre.commands 
{
	import com.bourre.commands.AbstractCommand;
	import com.bourre.collection.Iterable;
	import com.bourre.collection.Iterator;
	
	import flash.events.Event;

	/**
	 * @author Cédric Néhémie
	 */
	public class IterationCommand extends AbstractCommand implements Iterable 
	{
		protected var _oIterator : Iterator;

		public function IterationCommand ( i : Iterator )
		{
			super( );
			
			_oIterator = i;
		}
		override public function execute( e : Event ) : void
		{
		}
		
		public function iterator () : Iterator
		{
			return _oIterator;
		}
		
		public function setIterator ( i : Iterator ) : void
		{
			_oIterator = i;
		} 
	}
}
