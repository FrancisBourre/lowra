package com.bourre.ioc.control
{
	public class MockSingleton
	{
		public var isCreate : Boolean;
		private static var instance : MockSingleton;
		
		public function MockSingleton(arg1 : *)
		{
			isCreate = (arg1 == "create");
		}
		
		public static function getInstance() : MockSingleton
		{
			return instance ? instance : instance = new MockSingleton("create");
		}
	}
	
}