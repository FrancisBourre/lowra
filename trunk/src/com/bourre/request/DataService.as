package com.bourre.request
{
	import com.bourre.collection.Collection;
	
	public interface DataService
	{
		function setResult( result : Object ) : void;
		function getResult() : Object;
		function addDataServiceListener( listener : Object ) : Boolean;
		function removeDataServiceListener( listener : Object ) : Boolean;
		function getDataServiceListener() : Collection;
		function setArguments( ... rest ) : void;
		function getArguments() : Object;
		function fireResult() : void;
		function fireError() : void;
	}
}