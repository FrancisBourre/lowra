package com.bourre.ioc.control
{
	public class BuildArray
		implements IBuilder
	{
		import com.bourre.log.*;

		public function build ( type : String = null, 
								args : Array = null, 
								factory : String = null, 
								singleton : String = null, 
								channel : String = null		) : *
		{
			var a : Array = args.concat();
			if ( a.length <= 0 ) PixlibDebug.WARN( this + ".build(" + args + ") returns an empty Array." );
		
			return a;
		}

		public function toString() : String 
		{
			return PixlibStringifier.stringify( this );
		}
	}
}