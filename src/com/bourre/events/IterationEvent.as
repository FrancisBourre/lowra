package com.bourre.events 
{
	import com.bourre.events.BasicEvent;
	
	/**
	 * @author Cédric Néhémie
	 */
	public class IterationEvent extends BasicEvent 
	{
		protected var _nIndex : Number;
		protected var _oValue : *;
		
		public function IterationEvent ( sType : String, 
										 oTarget : Object = null,
										 index : Number = 0,
										 value : * = null )
		{
			super( sType, oTarget );
			
			_nIndex = index;
			_oValue = value;
		}
		
		public function getIndex () : Number
		{
			return _nIndex;
		}
		
		public function getValue () : *
		{
			return _oValue;
		}
	}
}
