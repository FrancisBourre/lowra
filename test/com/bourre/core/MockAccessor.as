package com.bourre.core
{
	public class MockAccessor
	{
		
		public var prop : Number;
		
		private var _prop : Number;
		
		public function MockAccessor () 
		{
			prop = 25;
			_prop = 250;
		}
		
		public function setProp ( n : Number ) : void
		{
			_prop = n;
		}
		public function getProp () : Number
		{
			return _prop;
		}
	}
}