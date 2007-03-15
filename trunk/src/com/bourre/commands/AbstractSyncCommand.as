package com.bourre.commands
{
	import flash.events.Event;
	import com.bourre.log.PixlibDebug;
	import com.bourre.events.EventBroadcaster;
	import com.bourre.log.PixlibStringifier;

	/*
	 * Upgrade to IOC : 
	 *  - remove abstract protection hack and call super with constructor argument
	 *  - uncomment extends elements 
	 *  - refactor add and remove listener return
	 */

	/**
	 * 
	 * @author Cédric Néhémie
	 */
	public class AbstractSyncCommand /*extends AbstractCommand*/ implements ASyncCommand
	{	
		protected var abstractConstructorAccess : ConstructorAccess = new ConstructorAccess();
		
		
		protected var _oEB : EventBroadcaster;
		protected var _eOnCommandEnd : ASyncCommandEvent;
		
		/**
		 * 
		 * @param o
		 * @return 
		 * 
		 */
		public function AbstractSyncCommand ( o : ConstructorAccess )
		{
			_oEB = new EventBroadcaster ( this );
			_eOnCommandEnd = new ASyncCommandEvent ( ASyncCommandEvent.onCommandEndEVENT, this );
		}
		
		/**
		 * 
		 * @param listener
		 * 
		 */
		public function addASyncCommandListener( listener : ASyncCommandListener ) : void
		{
			_oEB.addEventListener( ASyncCommandEvent.onCommandEndEVENT, listener );
		}
		
		/**
		 * 
		 * @param listener
		 * 
		 */
		public function removeASyncCommandListener( listener : ASyncCommandListener ) : void
		{
			_oEB.removeEventListener( ASyncCommandEvent.onCommandEndEVENT, listener );
		}
		
		/**
		 * 
		 * 
		 */
		public function fireCommandEndEvent() : void
		{
			_oEB.broadcastEvent( _eOnCommandEnd );
		}
		
		/**
		 * 
		 * @param e
		 * 
		 */
		public /*override*/ function execute( e : Event = null) : void
		{
			fireCommandEndEvent();
		}
		
		/**
		 * 
		 * 
		 * @return the string representation of the object
		 */
		public /*override*/ function toString():String
		{
			return PixlibStringifier.stringify( this );
		}
	}
}

internal class ConstructorAccess {}