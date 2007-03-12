package com.bourre.core
{
	public interface Locator
	{
		function isRegistered( key : String ) : Boolean;
		function locate( key : String ) : Object;
	}
}