package com.bourre.ioc.control
{
	public class BuildObject 
		implements IBuilder
	{
		
		public function build ( type : String = null, 
								args : Array = null, 
								factory : String = null, 
								singleton : String = null, 
								channel : String = null		) : *
		{
			return {};
		}

		public function toString() : String 
		{
			return PixlibStringifier.stringify( this );
		}
	}
}