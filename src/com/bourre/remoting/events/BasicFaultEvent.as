package com.bourre.remoting.events {
	import com.bourre.remoting.ServiceMethod;	
	import com.bourre.events.BasicEvent;	
	
	/**
	 * @author romain
	 * @author Axel Aigret
	 */
	public class BasicFaultEvent extends BasicEvent {
		
		public static var onFaultEVENT : String = "onFault";
		
		
		
		private var _sCode 				: String;
		private var _sCorrelationId 	: String;
		private var _sDetail 			: String;
		private var _sDescription 		: String;
		
		private var _sServiceMethodName : ServiceMethod;
		
		/**
		 * @param	code
		 * @param	correlationId
		 * @param	details
		 * @param	description
		 * @param	sServiceMethodName
		 */
		public function BasicFaultEvent(code : String, 
										correlationId : String, 
										details : String, 
										description : String,
										sServiceMethodName : ServiceMethod ) 
		{
			super( BasicFaultEvent.onFaultEVENT );
			
			_sCode = code ;
			_sCorrelationId = correlationId ;
			_sDetail = details;
			_sDescription = description;
			_sServiceMethodName = sServiceMethodName;
		}
		
		public function getCode() : String
		{
			return _sCode;
		}

		public function getCorrelationId() : String
		{
			return _sCorrelationId;
		}
		
		public function getDetail() : String
		{
			return _sDetail;
		}
		
		public function getDescription() : String
		{
			return _sDescription;
		}

		public function getServiceMethodName() : ServiceMethod
		{
			return _sServiceMethodName;
		}
		
		/*public function toString() : String 
		{
			return "BasicFaultEvent code: "+getCode()+
					                "line: "+ getLine()
		}*/
		
	}
}
