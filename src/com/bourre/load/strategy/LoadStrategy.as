package com.bourre.load.strategy
{
	import com.bourre.load.AbstractLoader;

	public interface LoadStrategy
	{
		function load( url : String ) : void;
		function getBytesLoaded() : uint;
		function getBytesTotal() : uint;
		function setOwner( owner : AbstractLoader ) : void;
		function release() : void;
	}
}