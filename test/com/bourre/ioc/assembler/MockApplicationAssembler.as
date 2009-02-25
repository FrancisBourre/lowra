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

		public function buildLoader( 				ID 							: String, 
											url 						: URLRequest, 
											startCallback 				: String 	= null,
											nameCallback 				: String 	= null, 
											loadCallback 				: String 	= null, 
											progressCallback 			: String 	= null, 
											timeoutCallback 			: String 	= null, 
											errorCallback 				: String 	= null, 
											initCallback 				: String 	= null, 
											parsedCallback 				: String 	= null, 
											objectsBuiltCallback		: String 	= null, 
											channelsAssignedCallback	: String 	= null, 
											methodsCallCallback 		: String 	= null, 
											completeCallback 			: String 	= null	) 		: void
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
		
		public function buildChannelListener( id : String, channelName : String, args : Array = null ) : void
		{
			//
		}
		
		public function registerID(ID : String) : Boolean
		{
			return null;
		}
		
		public function buildRoot(ID : String) : void
		{
		}
		
		public function buildResource(id : String, url : URLRequest, type : String = null, deserializer : String = null) : void
		{
		}
	}
}