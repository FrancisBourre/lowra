package com.bourre.core
{
	import flash.utils.Dictionary;	
	
	/**
	 * A <code>Locator</code> is an entity whose responsability is
	 * to store and retreive others entities
	 * 
	 * @author	Francis Bourre
	 */
	public interface Locator
	{
		function isRegistered( key : String ) : Boolean;
		function locate( key : String ) : Object;
		function add( d : Dictionary ) : void;
	}
}