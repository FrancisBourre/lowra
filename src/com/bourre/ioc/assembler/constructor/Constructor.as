package com.bourre.ioc.assembler.constructor
{
	import com.bourre.log.PixlibStringifier ;
	
	public class Constructor
	{
		public var 		id 		: String;
		public var 		type 		: String;
		public var 		arguments : Array;
		public var 		factory 	: String;
		public var 		singleton : String;

		public function Constructor(	id : String, 
										type : String = null, 
										args : Array = null, 
										factory : String = null, 
										singleton : String = null)
		{
			this.id = id;
			this.type = type;
			this.arguments = args;
			this.factory = factory;
			this.singleton = singleton;
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

