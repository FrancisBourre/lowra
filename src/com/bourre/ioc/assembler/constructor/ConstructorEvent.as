package com.bourre.ioc.assembler.constructor
{
	import com.bourre.events.BasicEvent;
	
	public class ConstructorEvent extends BasicEvent
	{
		public static var onBuildConstructorEVENT : String = "onBuildConstructor";
		private var _oConstructor : Constructor;
		
		public function ConstructorEvent( constructor : Constructor ) 
		{
			super( ConstructorEvent.onBuildConstructorEVENT );
			
			_oConstructor = constructor;
		}
		
		
		public function getConstructor() : Constructor
		{
			return _oConstructor;
		}
		
		/**
		 * Returns the string representation of this instance.
		 * @return the string representation of this instance
		 */
		public function toString() : String 
		{
			return PixlibStringifier.stringify( this );
		}
		
	}
}