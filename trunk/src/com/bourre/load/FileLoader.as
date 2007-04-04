package com.bourre.load
{
	import com.bourre.load.strategy.LoadStrategy;
	import com.bourre.load.strategy.URLLoadStrategy;
	
	public class FileLoader extends AbstractLoader
	{
		public function FileLoader(url : String = null)
		{
			super(abstractLoaderConstructorAccess,  new URLLoadStrategy());
		}
	}
}