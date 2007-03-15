package com.bourre.commands
{
	import com.bourre.events.BasicEvent;
		
	public class ASyncCommandEvent extends BasicEvent
	{
		public static const onCommandEndEVENT : String = "onCommandEnd";
		public static const onCommandTimeoutEVENT : String = "onCommandTimeout";
		
		public function ASyncCommandEvent ( sType : String, oTarget : Object = null )
		{
			super( sType, oTarget );
		}
	}
}