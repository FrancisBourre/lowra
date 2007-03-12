package com.bourre.collection
{
	public interface ITypedContainer
	{
		function isType ( o : * ) : Boolean;
		function getType () : Class;
	}
}