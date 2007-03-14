package com.bourre.collection
{
	public interface TypedContainer
	{
		function isType ( o : * ) : Boolean;
		function getType () : Class;
	}
}