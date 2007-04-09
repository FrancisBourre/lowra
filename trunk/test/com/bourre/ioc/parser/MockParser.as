package com.bourre.ioc.parser
{
	import com.bourre.ioc.assembler.*;
	
	public class MockParser 
		extends AbstractParser
	{
		public function MockParser( assembler : ApplicationAssembler = null )
		{
			super( assembler );
		}
		
		public override function parse( xml : * ) : void
		{
			//
		}
	}
}