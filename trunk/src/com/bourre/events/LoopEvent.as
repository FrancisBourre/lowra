package com.bourre.events 
{
	import com.bourre.events.BasicEvent;
	
	/**
	 * @author Cédric Néhémie
	 */
	public class LoopEvent extends BasicEvent 
	{
		protected var _nIndex : Number;
		
		public function LoopEvent (sType : String, oTarget : Object = null, index : Number = 0)
		{
			super( sType, oTarget );
			_nIndex = index;
		}
		
		public function getIndex () : Number
		{
			return _nIndex;
		}
	}
}
