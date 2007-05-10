package com.bourre.request
{
	public interface DataService
	{
		function setResult( result : Object ) : void;
		function getResult() : Object;
		function addDataServiceListener( listener : Object ) : Boolean;
		function removeDataServiceListener( listener : Object ) : Boolean;
		function getDataServiceListener() : Collection;
		function setArguments( ... rest ) : void;
		function getArguments() : Object;
	}
}