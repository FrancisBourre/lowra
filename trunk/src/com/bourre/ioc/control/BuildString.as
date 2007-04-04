package com.bourre.ioc.control
{
	public class BuildString
		implements IBuilder
	{
		import com.bourre.log.*;

		public function build ( type : String = null, 
								args : Array = null, 
								factory : String = null, 
								singleton : String = null, 
								channel : String = null		) : *
		{
			var value : String;
			if ( args != null && args.length > 0 ) value = ( args[0] ).toString();
			if ( value.length <= 0 ) PixlibDebug.WARN( this + ".build(" + value + ") returns empty String." );
			return value;
		}

		public function toString() : String 
		{
			return PixlibStringifier.stringify( this );
		}
	}
}