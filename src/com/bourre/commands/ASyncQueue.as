package com.bourre.commands 
{
	import com.bourre.commands.ASyncBatch;

	import flash.events.Event;	

	/**
	 * @author Cédric Néhémie
	 */
	public class ASyncQueue extends ASyncBatch 
	{
		public function ASyncQueue ()
		{
			super( );
		}
		
		override public function onCommandEnd ( e : Event ) : void
		{
			if( _hasNext() )
			{
				_next().execute( e );
			}
			else
			{
				_bIsRunning = false;
				fireCommandEndEvent();
			}
		}
	}
}
