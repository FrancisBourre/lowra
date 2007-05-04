package com.bourre.ioc.assembler.displayobject
{
	import com.bourre.events.BasicEvent;
	import flash.display.DisplayObjectContainer;
	import com.bourre.log.PixlibStringifier ;

	public class DisplayObjectEvent extends BasicEvent
	{
		public static var onBuildDisplayObjectEVENT : String = "onBuildDisplayObject" ;
	
		private var _mc : DisplayObjectContainer;
		
		public function DisplayObjectEvent( mc : DisplayObjectContainer ) 
		{
			super( DisplayObjectEvent.onBuildDisplayObjectEVENT, mc );
			
			_mc = mc;
		}
		
		public function getDisplayObject() : DisplayObjectContainer
		{
			return _mc;
		}
		
		/**
		 * Returns the string representation of this instance.
		 * @return the string representation of this instance
		 */
		public override function toString() : String 
		{
			return PixlibStringifier.stringify( this );
		}
	}
}