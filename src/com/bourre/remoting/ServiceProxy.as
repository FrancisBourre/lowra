package com.bourre.remoting
{
	import flash.net.URLRequest;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * @author romain
	 */
	public class ServiceProxy
		 extends AbstractServiceProxy
	{

		public function ServiceProxy ( oURL : URLRequest , sServiceName : String )
		{
			super( oURL , sServiceName );
		}
		
		// TODO : what we do with ServiceResponder in this case
		public function __resolve( sServiceMethodName : ServiceMethod, o : ServiceResponder ) : Function 
		{
			var connection : RemotingConnection = getRemotingConnection();
			var aFullServiceName  : Array = [ getFullyQualifiedMethodName( sServiceMethodName  ) ];
			return function () : * { return getRemotingConnection().call.apply( connection, aFullServiceName.concat(arguments) ); };
		}
		
		
		
	
	}
}



