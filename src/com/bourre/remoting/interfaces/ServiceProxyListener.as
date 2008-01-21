package com.bourre.remoting.interfaces
{
	import com.bourre.remoting.events.BasicResultEvent;	
	import com.bourre.remoting.events.BasicFaultEvent;	
	
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
