package com.bourre.load.strategy
{
	import com.bourre.load.AbstractLoader;
	import com.bourre.load.Loader;

	public interface LoadStrategy
	{
		function load( url : String ) : void;
		function getBytesLoaded() : uint;
		function getBytesTotal() : uint;
		function setOwner( owner : Loader ) : void;
		function release() : void;
	}
}