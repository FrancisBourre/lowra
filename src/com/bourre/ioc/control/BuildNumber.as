package com.bourre.ioc.control
{
	import com.bourre.log.*;
		
	public class BuildNumber 
		implements IBuilder
	{
	
		public function build ( type : String = null, 
								args : Array = null, 
								factory : String = null, 
								singleton : String = null, 
								channel : String = null		) : *
		{
			var n : Number = NaN;
			if ( args != null && args.length > 0 ) n = Number( ( args[0] ).toString() );
			if ( isNaN(n) ) PixlibDebug.FATAL( this + ".build(" + n + ") failed." );
			return n;
		}

		public function toString() : String 
		{
			return PixlibStringifier.stringify( this );
		}
	}
}