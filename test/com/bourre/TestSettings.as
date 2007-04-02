package com.bourre
{
	public class TestSettings
	{
		private static var _instance : TestSettings;
		
		[Bindable]
		public var testBinPath : String = "http://lowra.googlecode.com/svn/trunk/testBin";
		
		public function TestSettings( acess : TestSettingsConstructorAccess )
		{
		}
		
		public static function getInstance() : TestSettings
		{
			if( ! _instance )
				_instance = new TestSettings( new TestSettingsConstructorAccess() );
			return _instance;
		}
				
	}	
}

internal class TestSettingsConstructorAccess {}	