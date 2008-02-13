package com.bourre.ioc.assembler
{
	import flash.net.URLRequest;
	
	import com.bourre.ioc.assembler.displayobject.DisplayObjectBuilder;		

	public class MockApplicationAssembler 
		implements ApplicationAssembler
	{
		public function setDisplayObjectBuilder( 	displayObjectExpert 		: DisplayObjectBuilder ) 	: void
		{
			
		}

		public function getDisplayObjectBuilder() : DisplayObjectBuilder
		{
			return null;
		}

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

		public function buildDisplayObject( ID 							: String,
											parentID 					: String, 
											url 						: URLRequest= null,
											isVisible 					: Boolean	= true,
											type 						: String	= null	) : void
		{
			//
		}

		public function buildDLL( url : URLRequest ) : void
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