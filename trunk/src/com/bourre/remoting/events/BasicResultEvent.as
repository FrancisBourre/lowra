package com.bourre.remoting.events 
{
	import com.bourre.events.BasicEvent;
	import com.bourre.remoting.ServiceMethod;		

	/**
	 * @author romain
	 * @author Axel Aigret
	 */
	public class BasicResultEvent extends BasicEvent {
		
		public static const onResultEVENT : String = "onResult";
		
		private var _oResult : *;
		private var _oServiceMethod : ServiceMethod;
		
		public function BasicResultEvent(  result : *, sServiceMethodName : ServiceMethod ) 
		{
			super( BasicResultEvent.onResultEVENT );
			
			_oResult = result;
			_oServiceMethod = sServiceMethodName;
		}
		
		public function getResult() : *
		{
			return _oResult;
		}
		
		// TODO: know which type of function name we want for callback of methodcallby service
		// we can use onResult + functionname onResultlogin onResultgetListName / or on + functionname
		public function redirectType() : void
		{
			if (_oServiceMethod is ServiceMethod) setType( _oServiceMethod.toString());
		}
		
		public function getServiceMethode() : ServiceMethod
		{
			return _oServiceMethod;
		}
	
		
	}
}
