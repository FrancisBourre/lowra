package com.bourre.ioc.assembler
{
	import com.bourre.ioc.assembler.property.*;
	import com.bourre.ioc.assembler.channel.ChannelListenerExpert;
	import com.bourre.ioc.assembler.constructor.ConstructorExpert;

	public class DefaultApplicationAssembler 
		implements ApplicationAssembler
	{
		public function buildDLL( url : String ) : void
		{
			//
		}
		
		public function buildEmptyDisplayObject( 	ID : String,
													parentID : String,
													depth : uint,
													isVisible : Boolean,
													type : String ) : void
		{
			
		}

		public function buildDisplayObject( ID 			: String,
											parentID 	: String, 
											url 		: String,
											depth 		: uint, 
											isVisible 	: Boolean, 
											type : String ) : void
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
			PropertyExpert.getInstance().addProperty( ownerID, name, value, type, ref, method );
		}

		public function buildObject( 	ownerID 	: String, 
										type 		: String 	= null, 
										args 		: Array 	= null, 
										factory 	: String 	= null, 
										singleton 	: String 	= null, 
										channelName : String 	= null 	) : void
		{
			if ( args != null )
			{
				var l : int = args.length;
				for ( var i : int; i < l; i++ )
				{
					var o : Object = args[ i ];
					var p : Property = new Property( o.id, o.name, o.value, o.type, o.ref, o.method );
					args[ i ] = p;
				}
			}
			
			ConstructorExpert.getInstance().addConstructor( ownerID, type, args, factory, singleton, channelName );
		}

		public function buildMethodCall( ownerID : String, methodCallName : String, args : Array = null ) : void
		{
			if ( args != null )
			{
				var l : int = args.length;
				for ( var i : int; i < l; i++ )
				{
					var o : Object = args[ i ];
					var p : Property = new Property( o.id, o.name, o.value, o.type, o.ref, o.method );
					args[ i ] = p;
				}
			}

			// MethodExpert.getInstance().addMethod( ownerID, methodCallName, args );
		}

		public function buildChannelListener( ownerID : String, channelName : String ) : void
		{
			ChannelListenerExpert.getInstance().addChannelListener( ownerID, channelName );
		}
	}
}