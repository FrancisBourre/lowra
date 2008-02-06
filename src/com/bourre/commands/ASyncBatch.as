package com.bourre.commands 
{
	import com.bourre.commands.AbstractSyncCommand;
	import com.bourre.commands.MacroCommand;

	import flash.events.Event;
	
	import com.bourre.plugin.Plugin;	

	/**
	 * @author Cédric Néhémie
	 */
	public class ASyncBatch extends AbstractSyncCommand implements MacroCommand, ASyncCommandListener
	{
		/**
		 * Contains all commands currently in this macro command
		 */
		protected var _aCommands : Array;
		protected var _nIndex : Number;
		protected var _eEvent : Event;
		protected var _oLastCommand : ASyncCommand;

		public function ASyncBatch ()
		{
			_aCommands = new Array();
		}
		
		/**
		 * @inheritDoc
		 */
		override public function setOwner ( owner : Plugin ) : void
		{
			super.setOwner( owner );
			
			var l : Number = _aCommands.length;
			var c : AbstractCommand;
			while( --l -(-1 ) )
			{
				if( ( c = _aCommands[ l ]  as AbstractCommand ) != null )
					c.setOwner( owner );
			}
		}
		
		public function addCommand (command : Command) : Boolean
		{
			if( !isRunning() )
			{
				if( command == null ) return false;
				
				if( command is AbstractCommand )
					( command as AbstractCommand).setOwner( getOwner() );
					
				var l : Number = _aCommands.length;
				return (l != _aCommands.push( command ) );
			}
			return false;
		}
		
		public function removeCommand (command : Command) : Boolean
		{
			if( !isRunning() )
			{
				var id : Number = _aCommands.indexOf( command ); 
	
				if ( id == -1 ) return false;
				
				while ( ( id = _aCommands.indexOf( command ) ) != -1 )
				{
					_aCommands.splice( id, 1 );
				}
				return true;
			}
			return false;
		}
		
		override public function execute (e : Event = null) : void
		{
			_eEvent = e;
			_nIndex = -1;
			_bIsRunning = true;
			
			if( _hasNext() )
				_next().execute( _eEvent );
		}

		public function onCommandEnd ( e : Event ) : void
		{
			if( _hasNext() )
			{
				_next().execute( _eEvent );
			}
			else
			{
				_bIsRunning = false;
				fireCommandEndEvent();
			}
		}
		
		protected function _next () : ASyncCommand
		{
			if( _oLastCommand )
				_oLastCommand.removeASyncCommandListener( this );
			
			_oLastCommand = _aCommands.shift( ) as ASyncCommand;
			
			_oLastCommand.addASyncCommandListener( this );
			
			return _oLastCommand;
		}

		protected function _hasNext () : Boolean
		{
			return _nIndex + 1 < _aCommands.length;
		}
	}
}
