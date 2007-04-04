package com.bourre.ioc.control
{
	import com.bourre.log.*;

	public class BuildNull 
		implements IBuilder
	{

		public function build ( type : String = null, 
								args : Array = null, 
								factory : String = null, 
								singleton : String = null, 
								channel : String = null		) : *
		{
			return null;
		}

		public function toString() : String 
		{
			return PixlibStringifier.stringify( this );
		}
	}
}