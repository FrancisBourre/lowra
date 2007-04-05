package com.bourre.commands
{
	import com.bourre.commands.Batch 
	import flash.events.Event;
	import com.bourre.log.PixlibStringifier ;
	
	public class ReversedBatch extends Batch
	{
		
		public function ReversedBatch()
		{
			super() ;
		}
		
		public override function execute (e : Event=null) : void
		{
			var l:int = super._aCommands.length ;
			while(--l > -1) super._aCommands[l].execute(e) ;
		}
		
		public function toString():String
		{
			return PixlibStringifier.stringify(this) ;
		}
	}
}