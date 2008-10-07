package com.bourre.remoting.interfaces
{
	import com.bourre.remoting.events.BasicFaultEvent;
	import com.bourre.remoting.events.BasicResultEvent;		

	/**
	 * 
	 * @author romain
	 */
	public interface ServiceProxyListener
	{
		function onResult( e : BasicResultEvent ) : void;
		function onFault( e : BasicFaultEvent ) : void;
	}
}
