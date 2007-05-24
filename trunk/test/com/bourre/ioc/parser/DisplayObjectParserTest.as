package com.bourre.ioc.parser
{
	import flexunit.framework.TestCase;
	import com.bourre.ioc.assembler.*;
	import com.bourre.error.IllegalArgumentException;
	import com.bourre.log.PixlibDebug;
	import com.bourre.ioc.error.NullIDException;

	public class DisplayObjectParserTest 
		extends TestCase
		implements ApplicationAssembler
	{
		private var _oParser : DisplayObjectParser;
		private var _aEmptyDO : Array;
		private var _aDO : Array;
		private var _aProperty : Array;
		private var _aMethod : Array;
		
		public override function setUp():void
		{
			_oParser = new DisplayObjectParser( this );
			_aEmptyDO = new Array();
			_aDO = new Array();
			_aProperty = new Array();
			_aMethod = new Array();
		}

		public function testNoID() : void
		{
			var xml : XML = 
			<beans>
				<root>
					<mc />
				</root>
			</beans>;
			
			var b : Boolean = false;
			try
			{
				_oParser.parse( xml );

			} catch( e : NullIDException )
			{
				b = true;
			}
			
			assertTrue( "DisplayObjectParser.parse() didn't catch NullIDException", b );
		}
		
		public function testBuildEmptyDisplayObject() : void
		{
			var xml : XML = 
			<beans>
				<root>
					<mc id="container"/>
				</root>
			</beans>;
			
			_oParser.parse( xml );
			assertEquals( "DisplayObjectParser.parse() didn't call assembler.buildEmptyDisplayObject()", 1, _aEmptyDO.length );
			//
			var o : Object = _aEmptyDO[ 0 ];
			assertEquals( "unexpected id", "container", o.id );
			assertEquals( "unexpected parentID", "root", o.parentID );
			assertTrue( "unexpected isVisible", o.isVisible );
			assertEquals( "unexpected type", ContextTypeList.SPRITE, o.type );
		}
		
		public function testBuildDisplayObject() : void
		{
			var xml : XML = 
			<beans>
				<root>
					<mc id="test" url="http://www.tweenpix.net" visible="false" type="flash.display.MovieClip"/>
				</root>
			</beans>;
			
			_oParser.parse( xml );
			assertEquals( "DisplayObjectParser.parse() didn't call assembler.buildDisplayObject()", 1, _aDO.length );
			//
			var o : Object = _aDO[ 0 ];
			assertEquals( "unexpected id", "test", o.id );
			assertEquals( "unexpected parentID", "root", o.parentID );
			assertEquals( "unexpected url", "http://www.tweenpix.net", o.url );
			assertFalse( "unexpected isVisible", o.isVisible );
			assertEquals( "unexpected type", ContextTypeList.MOVIECLIP, o.type );
		}
		
		public function testDisplayObjectHierarchy() : void
		{
			var xml : XML = 
			<beans>
				<root>
					<mc id="container">
						<mc id="tweenpix" url="http://www.tweenpix.net" visible="false" type="flash.display.MovieClip"/>
						<mc id="osflash" url="http://www.osflash.org" visible="true" type="flash.display.Sprite">
							<mc id="google" url="http://www.google.fr"/>
						</mc>
					</mc>
				</root>
			</beans>;
			
			_oParser.parse( xml );
			assertEquals( "DisplayObjectParser.parse() didn't call assembler.buildEmptyDisplayObject()", 1, _aEmptyDO.length );
			assertEquals( "DisplayObjectParser.parse() didn't call assembler.buildDisplayObject()", 3, _aDO.length );
			
			var o : Object;
			//
			o = _aEmptyDO[ 0 ];
			assertEquals( "unexpected id", "container", o.id );
			assertEquals( "unexpected parentID", "root", o.parentID );
			assertTrue( "unexpected isVisible", o.isVisible );
			assertEquals( "unexpected type", ContextTypeList.SPRITE, o.type );
			//
			o = _aDO[ 0 ];
			assertEquals( "unexpected id", "tweenpix", o.id );
			assertEquals( "unexpected parentID", "container", o.parentID );
			assertEquals( "unexpected url", "http://www.tweenpix.net", o.url );
			assertFalse( "unexpected isVisible", o.isVisible );
			assertEquals( "unexpected type", ContextTypeList.MOVIECLIP, o.type );
			//
			o = _aDO[ 1 ];
			assertEquals( "unexpected id", "osflash", o.id );
			assertEquals( "unexpected parentID", "container", o.parentID );
			assertEquals( "unexpected url", "http://www.osflash.org", o.url );
			assertTrue( "unexpected isVisible", o.isVisible );
			assertEquals( "unexpected type", ContextTypeList.SPRITE, o.type );
			//
			o = _aDO[ 2 ];
			assertEquals( "unexpected id", "google", o.id );
			assertEquals( "unexpected parentID", "osflash", o.parentID );
			assertEquals( "unexpected url", "http://www.google.fr", o.url );
			assertTrue( "unexpected isVisible", o.isVisible );
			assertEquals( "unexpected type", ContextTypeList.SPRITE, o.type );
		}
		
		public function testProperty() : void
		{
			var xml : XML = 
			<beans>
				<root>
					<mc id="container">
						<mc id="button" url="http://www.tweenpix.net/button.swf">
							<property name="x" value="12" type="Number"/>
							<property name="y" value="57" type="Number"/>
						</mc>
					</mc>
				</root>
			</beans>;
			
			_oParser.parse( xml );
			assertEquals( "DisplayObjectParser.parse() didn't call assembler.buildEmptyDisplayObject()", 1, _aEmptyDO.length );
			assertEquals( "DisplayObjectParser.parse() didn't call assembler.buildDisplayObject()", 1, _aDO.length );
			
			var o : Object;
			//
			o = _aEmptyDO[ 0 ];
			assertEquals( "unexpected id", "container", o.id );

			//
			o = _aDO[ 0 ];
			assertEquals( "unexpected id", "button", o.id );
			assertEquals( "unexpected parentID", "container", o.parentID );
			assertEquals( "unexpected url", "http://www.tweenpix.net/button.swf", o.url );
			//
			
			assertEquals( "unexpected instances count", _aProperty.length, 2 );

			var x : Object = _aProperty[ 0 ];
			assertEquals( "", x.id, "button" );
			assertEquals( "", x.name, "x" );
			assertEquals( "", x.value, "12" );
			assertEquals( "", x.type, "Number" );

			var y : Object = _aProperty[ 1 ];
			assertEquals( "", y.id, "button" );
			assertEquals( "", y.name, "y" );
			assertEquals( "", y.value, "57" );
			assertEquals( "", y.type, "Number" );
		}
		
		public function testMethod() : void
		{
			var xml : XML = 
			<beans>
				<root>
					<mc id="container">
						<mc id="button" url="http://www.tweenpix.net/button.swf">
							<method-call name="gotoAndPlay">
								<argument value="2" type="Number"/>
							</method-call>
						</mc>
					</mc>
				</root>
			</beans>;
			
			_oParser.parse( xml );
			assertEquals( "DisplayObjectParser.parse() didn't call assembler.buildEmptyDisplayObject()", 1, _aEmptyDO.length );
			assertEquals( "DisplayObjectParser.parse() didn't call assembler.buildDisplayObject()", 1, _aDO.length );
			
			var o : Object;
			//
			o = _aEmptyDO[ 0 ];
			assertEquals( "unexpected id", "container", o.id );

			//
			o = _aDO[ 0 ];
			assertEquals( "unexpected id", "button", o.id );
			assertEquals( "unexpected parentID", "container", o.parentID );
			assertEquals( "unexpected url", "http://www.tweenpix.net/button.swf", o.url );
			//

			assertEquals( "unexpected method count", _aMethod.length, 1 );

			var m0 : Object = _aMethod[ 0 ];
			assertEquals( "", m0.id, "button" );
			assertEquals( "", m0.methodCallName, "gotoAndPlay" );
			var a0 : Array = m0.args;
			assertEquals( "unexpected args count", a0.length, 1 );
			assertEquals( "", a0[0].value, "2" );
			assertEquals( "", a0[0].type, "Number" );
		}

		//
		public function buildDLL( url : String ) : void
		{
			//
		}
		
		public function buildEmptyDisplayObject( 	id : String,
													parentID : String,
													isVisible : Boolean,
													type : String ) : void
		{
			//PixlibDebug.DEBUG( "buildEmptyDisplayObject(" + id + ", " + parentID + ", " + isVisible + ", " + type + ")" );
			_aEmptyDO.push( {id:id, parentID:parentID, isVisible:isVisible, type:type} );
			
		}

		public function buildDisplayObject( id 			: String,
											parentID 	: String, 
											url 		: String,
											isVisible 	: Boolean, 
											type : String ) : void
		{
			//PixlibDebug.DEBUG( "buildDisplayObject(" + id + ", " + parentID + ", " + url + ", " + isVisible + ", " + type + ")" );
			_aDO.push( {id:id, parentID:parentID, url:url, isVisible:isVisible, type:type} );
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
			//
		}

		public function buildMethodCall( id : String, methodCallName : String, args : Array = null ) : void
		{
			_aMethod.push( {id:id, methodCallName:methodCallName, args:args} );
		}

		public function buildChannelListener( id : String, channelName : String ) : void
		{
			//
		}
	}
}