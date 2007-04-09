package com.bourre.ioc.parser
{
	import flexunit.framework.TestCase;
	import com.bourre.ioc.assembler.*;
	import com.bourre.error.IllegalArgumentException;

	public class ObjectParserTest 
		extends TestCase
		implements ApplicationAssembler
	{
		private var _oParser : ObjectParser;
		private var _aResult : Array;
		private var _aChannelListener : Array;

		public override function setUp():void
		{
			_oParser = new ObjectParser( this );
			_aResult = new Array();
			_aChannelListener = new Array();
		}
		
		public function testParseOneString() : void
		{
			var xml : XML = 
			<beans>
				<gateway id="gateway" value="http://www.google.com/flashservices/gateway.php"/>
			</beans>;
			
			_oParser.parse( xml );
			
			assertEquals( "unexpected instances count", _aResult.length, 1 );
			//
			var o : Object = _aResult[ 0 ];
			assertEquals( "unexpected id", o.id, "gateway" );
			assertEquals( "unexpected args length", o.args.length, 1 );

			var arg : Object = o.args[ 0 ];
			assertEquals( "unexpected type", arg.type, ContextTypeList.STRING );
			assertEquals( "unexpected value", arg.value, "http://www.google.com/flashservices/gateway.php" );
		}
		
		public function testParseMoreString() : void
		{
			var xml : XML = 
			<beans>
				<gateway id="gateway" value="http://www.google.com/flashservices/gateway.php"/>
				<gateway id="gateway2" type="String" value="http://www.google.com/flashservices/gateway2.php"/>
			</beans>;
			
			_oParser.parse( xml );
			
			assertEquals( "unexpected instances count", _aResult.length, 2 );
			//
			var o0 : Object = _aResult[ 0 ];
			assertEquals( "unexpected id", o0.id, "gateway" );
			assertEquals( "unexpected args length", o0.args.length, 1 );

			var arg0 : Object = o0.args[ 0 ];
			assertEquals( "unexpected type", arg0.type, ContextTypeList.STRING );
			assertEquals( "unexpected value", arg0.value, "http://www.google.com/flashservices/gateway.php" );
			//
			var o1 : Object = _aResult[ 1 ];
			assertEquals( "unexpected id", o1.id, "gateway2" );
			assertEquals( "unexpected args length", o1.args.length, 1 );

			var arg1 : Object = o1.args[ 0 ];
			assertEquals( "unexpected type", arg1.type, ContextTypeList.STRING );
			assertEquals( "unexpected value", arg1.value, "http://www.google.com/flashservices/gateway2.php" );
		}
		
		public function testParseOneUint() : void
		{
			var xml : XML = 
			<beans>
				<value id="age" value="13" type="uint"/>
			</beans>;
			
			_oParser.parse( xml );
			
			assertEquals( "unexpected instances count", _aResult.length, 1 );
			//
			var o : Object = _aResult[ 0 ];
			assertEquals( "unexpected id", o.id, "age" );
			assertEquals( "unexpected args length", o.args.length, 1 );

			var arg : Object = o.args[ 0 ];
			assertEquals( "unexpected type", arg.type, ContextTypeList.UINT );
			assertEquals( "unexpected value", arg.value, "13" );
		}
		
		public function testParseMorePrimitives() : void
		{
			var xml : XML = 
			<beans>
				<value id="age" value="36" type="uint"/>
				<value id="stage" value="-2" type="int"/>
				<value id="name" value="Francis Bourre"/>
				<value id="distance" value="137.54" type="Number"/>
			</beans>;
			
			_oParser.parse( xml );
			
			assertEquals( "unexpected instances count", _aResult.length, 4 );
			//
			var o0 : Object = _aResult[ 0 ];
			assertEquals( "unexpected id", o0.id, "age" );
			assertEquals( "unexpected args length", o0.args.length, 1 );

			var arg0 : Object = o0.args[ 0 ];
			assertEquals( "unexpected type", arg0.type, ContextTypeList.UINT );
			assertEquals( "unexpected value", arg0.value, "36" );
			//
			var o1 : Object = _aResult[ 1 ];
			assertEquals( "unexpected id", o1.id, "stage" );
			assertEquals( "unexpected args length", o1.args.length, 1 );

			var arg1 : Object = o1.args[ 0 ];
			assertEquals( "unexpected type", arg1.type, ContextTypeList.INT );
			assertEquals( "unexpected value", arg1.value, "-2" );
			
			var o2 : Object = _aResult[ 2 ];
			assertEquals( "unexpected id", o2.id, "name" );
			assertEquals( "unexpected args length", o2.args.length, 1 );

			var arg2 : Object = o2.args[ 0 ];
			assertEquals( "unexpected type", arg2.type, ContextTypeList.STRING );
			assertEquals( "unexpected value", arg2.value, "Francis Bourre" );
			//
			var o3 : Object = _aResult[ 3 ];
			assertEquals( "unexpected id", o3.id, "distance" );
			assertEquals( "unexpected args length", o3.args.length, 1 );

			var arg3 : Object = o3.args[ 0 ];
			assertEquals( "unexpected type", arg3.type, ContextTypeList.NUMBER );
			assertEquals( "unexpected value", arg3.value, "137.54" );
		}
		
		public function testParseInstancesWithChannels() : void
		{
			var xml : XML = 
			<beans>
				<object id="instance" type="com.test.TestClass">
					<listen channel="channelA" />
					<listen channel="channelB" />
				</object>
				<object id="list" type="Array">
					<listen channel="channelC" />
				</object>
			</beans>;
			
			_oParser.parse( xml );
			
			assertEquals( "unexpected instances count", _aResult.length, 2 );
			//
			var o : Object = _aResult[ 0 ];
			assertEquals( "unexpected id", o.id, "instance" );
			assertEquals( "unexpected args length", o.args.length, 1 );

			var arg : Object = o.args[ 0 ];
			assertEquals( "unexpected type", arg.type, "com.test.TestClass" );
			assertEquals( "unexpected infos length", o.args.length, 1 );
			//
			var o1 : Object = _aResult[ 1 ];
			assertEquals( "unexpected id", o1.id, "list" );
			assertEquals( "unexpected args length", o1.args.length, 1 );

			var arg1 : Object = o1.args[ 0 ];
			assertEquals( "unexpected type", arg1.type, ContextTypeList.ARRAY );
			assertEquals( "unexpected infos length", o.args.length, 1 );
			
			assertEquals( "unexpected channel listeners count", _aChannelListener.length, 3 );
			//
			var listener0 : Object = _aChannelListener[ 0 ];
			assertEquals( "unexpected id", listener0.id, "instance" );
			assertEquals( "unexpected channel name", listener0.channelName, "channelA" );
			//
			var listener1 : Object = _aChannelListener[ 1 ];
			assertEquals( "unexpected id", listener1.id, "instance" );
			assertEquals( "unexpected channel name", listener1.channelName, "channelB" );
			//
			var listener2 : Object = _aChannelListener[ 2 ];
			assertEquals( "unexpected id", listener2.id, "list" );
			assertEquals( "unexpected channel name", listener2.channelName, "channelC" );
		}
		
		//
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
										singleton 	: String 	= null, 
										channelName : String 	= null 	) : void
		{
			_aResult.push( {id:id, type:type, args:args, factory:factory, singleton:singleton, channelName:channelName} );
		}
		
		public function buildMethodCall( id : String, methodCallName : String, args : Array = null ) : void
		{
			//
		}
		
		public function buildChannelListener( id : String, channelName : String ) : void
		{
			_aChannelListener.push( {id:id, channelName:channelName} );
		}
	}
}