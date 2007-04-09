package com.bourre.ioc.parser
{
	import flexunit.framework.TestCase;
	import com.bourre.ioc.assembler.*;
	import com.bourre.error.*;

	public class AbstractParserTest 
		extends TestCase
	{
		private var _oParser : MockParser;
		private var _oAssembler : MockApplicationAssembler;

		public override function setUp():void
		{
			_oAssembler = new MockApplicationAssembler()
			_oParser = new MockParser( _oAssembler );
		}

		public function testConstructor() : void
		{
			var parser : AbstractParser = new MockParser();
			assertNotNull( "AbstractParser constructor returns null", parser );
			assertTrue( "AbstractParser constructor without arguments doesn't assign DefaultApplicationAssembler instance", parser.getAssembler() is DefaultApplicationAssembler );
		}
		
		public function testGetAssembler() : void
		{
			assertStrictlyEquals( "AbstractParser.getAssembler() returns unexpected value", _oParser.getAssembler(), _oAssembler );
		}
		
		public function testSetAssembler() : void
		{
			var assembler : ApplicationAssembler = new DefaultApplicationAssembler();
			_oParser.setAssembler( assembler );
			assertStrictlyEquals( "ObjectParser.setAssembler( assembler ) fails", _oParser.getAssembler(), assembler );
			
			var isErrorCaught : Boolean = false;
			try
			{
				_oParser.setAssembler( null );

			} catch( e : Error )
			{
				isErrorCaught = ( e is IllegalArgumentException );
			}
			
			assertTrue( "ObjectParser.setAssembler( null ) didn't throw expected Error", isErrorCaught );
			assertNotNull( "ObjectParser.setAssembler( null ) shouldn't work", _oParser.getAssembler() );
		}
	}
}