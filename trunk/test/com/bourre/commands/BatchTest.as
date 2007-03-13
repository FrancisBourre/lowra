package com.bourre.commands
{
	import flexunit.framework.TestCase;

	public class BatchTest extends TestCase
	{
		private var _b : Batch;
		
		public function setUp () : void
		{
			_b = new Batch();
		}
		
		public function testAddCommand() : void
		{
			assertTrue ( _b + ".addCommand() failed to add" )
		}
	}
}