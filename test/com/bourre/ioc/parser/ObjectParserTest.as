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
		private var _aProperty : Array;
		private var _aMethod : Array;
		
		public override function setUp():void
		{
			_oParser = new ObjectParser( this );
			_aResult = new Array();
			_aChannelListener = new Array();
			_aProperty = new Array();
			_aMethod = new Array();
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
			assertEquals( "unexpected o.args length", o.args.length, 0 );

			//
			var o1 : Object = _aResult[ 1 ];
			assertEquals( "unexpected id", o1.id, "list" );
			assertEquals( "unexpected o1.args length", o1.args.length, 0 );
			
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

		public function testParseInstancesWithProperties() : void
		{
			var xml : XML = 
			<beans>
				<object id="instance" type="com.test.TestClass">
					<property name="x" value="12" type="int" ref="ref0" method="do"/>
					<property name="y" value="21" type="uint" ref="ref1" method="act"/>
				</object>
			</beans>;
			
			_oParser.parse( xml );
			
			assertEquals( "unexpected instances count", _aProperty.length, 2 );

			var x : Object = _aProperty[ 0 ];
			assertEquals( "", x.id, "instance" );
			assertEquals( "", x.name, "x" );
			assertEquals( "", x.value, "12" );
			assertEquals( "", x.type, "int" );
			assertEquals( "", x.ref, "ref0" );
			assertEquals( "", x.method, "do" );

			var y : Object = _aProperty[ 1 ];
			assertEquals( "", y.id, "instance" );
			assertEquals( "", y.name, "y" );
			assertEquals( "", y.value, "21" );
			assertEquals( "", y.type, "uint" );
			assertEquals( "", y.ref, "ref1" );
			assertEquals( "", y.method, "act" );
		}

		public function testParseInstancesWithMethods() : void
		{
			var xml : XML = 
			<beans>
				<object id="instance" type="com.test.TestClass">
					<method-call name="setPosition">
						<argument value="12" type="int"/>
						<argument value="21" type="uint"/>
					</method-call>
					<method-call name="setCallback">
						<argument ref="ref0"/>
						<argument ref="ref1" method="do"/>
					</method-call>
				</object>
			</beans>;

			_oParser.parse( xml );

			assertEquals( "unexpected instances count", _aMethod.length, 2 );

			var m0 : Object = _aMethod[ 0 ];
			assertEquals( "", m0.id, "instance" );
			assertEquals( "", m0.methodCallName, "setPosition" );
			var a0 : Array = m0.args;
			assertEquals( "unexpected args count", a0.length, 2 );
			assertEquals( "", a0[0].value, "12" );
			assertEquals( "", a0[0].type, "int" );
			assertEquals( "", a0[1].value, "21" );
			assertEquals( "", a0[1].type, "uint" );

			var m1 : Object = _aMethod[ 1 ];
			assertEquals( "", m1.id, "instance" );
			assertEquals( "", m1.methodCallName, "setCallback" );
			var a1 : Array = m1.args;
			assertEquals( "unexpected args count", a0.length, 2 );
			assertEquals( "", a1[0].ref, "ref0" );
			assertEquals( "", a1[1].ref, "ref1" );
			assertEquals( "", a1[1].method, "do" );
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
			
		}

		public function buildDisplayObject( ID 			: String,
											parentID 	: String, 
											url 		: String,
											isVisible 	: Boolean, 
											type : String ) : void
		{
			//
		}

		public function buildProperty( 	id 		: String, 
										name 	: String = null, 
										value 	: String = null, 
										type 	: String = null, 
										ref 	: String = null, 
										method 	: String = null	) : void
		{
			_aProperty.push( {id:id, name:name, value:value, type:type, ref:ref, method:method} );
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
			_aMethod.push( {id:id, methodCallName:methodCallName, args:args} );
		}

		public function buildChannelListener( id : String, channelName : String ) : void
		{
			_aChannelListener.push( {id:id, channelName:channelName} );
		}
	}
}