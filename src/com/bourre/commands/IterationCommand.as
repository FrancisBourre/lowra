package com.bourre.commands 
{
	import com.bourre.collection.Iterable;
	
	/**
	 * @author Cédric Néhémie
	 */
	public interface IterationCommand extends Iterable, Command
	{
		function abort () : void;
	}
}
