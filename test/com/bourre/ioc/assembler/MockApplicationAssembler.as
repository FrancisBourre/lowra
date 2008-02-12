package com.bourre.ioc.assembler
{
	import flash.net.URLRequest;	
	
	public class MockApplicationAssembler 
		implements ApplicationAssembler
	{
		public function buildLoader (	ID 							: String, 
										url 						: URLRequest, 
										progressCallback 			: String 	= null, 
										nameCallback 				: String 	= null, 
										timeoutCallback 			: String 	= null, 
										parsedCallback 				: String 	= null, 
										methodsCallCallback 		: String 	= null, 
										objectsBuiltCallback		: String 	= null, 
										channelsAssignedCallback	: String 	= null, 
										initCallback 				: String 	= null	) : void
		{
			//
		}

		public function buildEmptyDisplayObject( 	ID : String,
													parentID : String,
													isVisible : Boolean,
													type : String ) : void
		{
			
		}

		public function buildDisplayObject( ID 			: String,
											url : URLRequest,
											parentID 	: String, 
											isVisible 	: Boolean, 
											type : String ) : void
		{
			//
		}

		public function buildDLL( url : String ) : void
		{
			//
		}

		public function buildProperty( 	ownerID : String, 
										name 	: String = null, 
										value 	: String = null, 
										type 	: String = null, 
										ref 	: String = null, 
										method 	: String = null	) : void
		{
			//
		}

		public function buildObject( 	id 			: String, 
										type 		: String 	= null, 
										args 		: Array 	= null, 
										factory 	: String 	= null, 
										singleton 	: String 	= null ) : void
		{
			//
		}
		
		public function buildMethodCall( id : String, methodCallName : String, args : Array = null ) : void
		{
			//
		}
		
		public function buildChannelListener( id : String, channelName : String ) : void
		{
			//
		}
	}
}