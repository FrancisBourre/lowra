package com.bourre.ioc.bean
{
	import com.bourre.events.BasicEvent;
	import com.bourre.log.*;
	//import com.bourre.core.HashCodeFactory;

	public class BeanEvent extends BasicEvent
	{
		private var _sID	: String ;
		private var _o 		: Object ;
		
		public function BeanEvent(sType : String, sID : String, o : Object)
		{
			super(sType, o) ;
			_sID = sID ;
			_o = o ;
		}
		
		public function getID():String
		{
			return _sID ;
		}
		
		public function getBean():Object
		{
			return _o ;
		}
		
		public override function toString():String
		{
			//return 'BeanEvent' + HashCodeFactory.getKey( this );
			return PixlibStringifier.stringify( this );
		}
		
	}
}