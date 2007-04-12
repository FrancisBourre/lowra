package com.bourre.ioc.assembler.constructor
{
	import com.bourre.log.PixlibStringifier ;
	
	public class Constructor
	{
		public var 		ID 		: String;
		public var 		Type 		: String;
		public var 		Arguments : Array;
		public var 		Factory 	: String;
		public var 		Singleton : String;
		public var 		Channel 	: String;

		
		public function Constructor(	id : String, 
										type : String, 
										args : Array, 
										factory : String, 
										singleton : String,
										channel : String ) //access:PrivateConstructorAccess)
		{
			ID = id;
			Type = type;
			Arguments = args;
			Factory = factory;
			Singleton = singleton;
			Channel = channel;
		}
		
		/**
		 * Returns the string representation of this instance.
		 * @return the string representation of this instance
		 */
		public function toString() : String 
		{
			return PixlibStringifier.stringify( this );
		}
	}
}

