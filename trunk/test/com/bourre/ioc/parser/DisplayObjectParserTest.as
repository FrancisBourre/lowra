package com.bourre.ioc.parser
{
	import flexunit.framework.TestCase;
	import com.bourre.ioc.assembler.*;
	import com.bourre.error.IllegalArgumentException;
	import com.bourre.log.PixlibDebug;

	public class DisplayObjectParserTest 
		extends TestCase
		implements ApplicationAssembler
	{
		private var _oParser : DisplayObjectParser;
		private var _aResult : Array;

		public override function setUp():void
		{
			_oParser = new DisplayObjectParser( this );
			_aResult = new Array();
		}

		public function testParseOneString() : void
		{
			var xml : XML = 
			<beans>
				<root>
					<mc id="container" />
				</root>
			</beans>;
			
			_oParser.parse( xml );
			
			assertEquals( "unexpected instances count", 1, _aResult.length );/*
			//
			var o : Object = _aResult[ 0 ];
			assertEquals( "unexpected id", o.id, "gateway" );
			assertEquals( "unexpected args length", o.args.length, 1 );

			var arg : Object = o.args[ 0 ];
			assertEquals( "unexpected type", arg.type, ContextTypeList.STRING );
			assertEquals( "unexpected value", arg.value, "http://www.google.com/flashservices/gateway.php" );*/
		}

		//
		public function buildDLL( url : String ) : void
		{
			//
		}
		
		public function buildEmptyDisplayObject( 	ID : String,
													parentID : String,
													isVisible : Boolean,
													type : String ) : void
		{
			PixlibDebug.DEBUG( "buildEmptyDisplayObject(" + ID + ", " + parentID + ", " + isVisible + ", " + type + ")" );
		}

		public function buildDisplayObject( ID 			: String,
											parentID 	: String, 
											url 		: String,
											isVisible 	: Boolean, 
											type : String ) : void
		{
			PixlibDebug.DEBUG( "buildDisplayObject(" + ID + ", " + parentID + ", " + url + ", " + isVisible + ", " + type + ")" );
		}

		public function buildProperty( 	id 		: String, 
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
										singleton 	: String 	= null, 
										channelName : String 	= null 	) : void
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