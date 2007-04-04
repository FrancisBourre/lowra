package com.bourre.ioc.control
{
	public interface IBuilder
	{
		function build ( 	type : String = null, 
							args : Array = null, 
							factory : String = null, 
							singleton : String = null, 
							channel : String = null		) : *
	}
}