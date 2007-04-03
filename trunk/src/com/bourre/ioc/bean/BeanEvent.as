package com.bourre.ioc.bean
{
	import com.bourre.events.BasicEvent;
	import com.bourre.log.*;

	public class BeanEvent 
		extends BasicEvent
	{
		private var _sID	: String ;
		private var _oBean 	: Object ;
		
		public function BeanEvent( type : String, id : String, bean : Object )
		{
			super( type, bean );
			_sID = id;
			_oBean = bean;
		}
		
		public function getID() : String
		{
			return _sID ;
		}
		
		public function getBean() : Object
		{
			return _oBean ;
		}
		
		public override function toString():String
		{
			return PixlibStringifier.stringify( this );
		}
		
	}
}