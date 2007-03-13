package com.bourre.commands
{
	import flash.events.Event;
	import flash.utils.Dictionary;

	public class Batch implements MacroCommand
	{
		
		private var _aCommands : Array;
		
		public function Batch ()
		{
			_aCommands = new Array();
		}
		
		public function addCommand( oCommand : Command ) : Boolean
		{
			var l : Number = _aCommands.length;
			return (l != _aCommands.push( oCommand ) );
		}
		
		public function removeCommand( oCommand : Command ) : Boolean
		{
			var id : Number = _aCommands.indexOf( oCommand ); 
			
			if ( id == -1 ) return false;
			
			while ( ( id = _aCommands.indexOf( oCommand ) ) != -1 )
			{
				_aCommands.splice( id, 1 );
			}
			return true;
		}
		
		public function execute( e : Event = null ) : void
		{
			var l : Number = _aCommands.length;
			for( var i : Number = 0; i<l; i++ ) 
			{
				( _aCommands[ i ] as Command ).execute( e );
			}
		}
		
		public function removeAll () : void
		{
			_aCommands = new Array();
		}
		
		public function getLength () : int
		{
			return _aCommands.length;		
		}	
	}
}