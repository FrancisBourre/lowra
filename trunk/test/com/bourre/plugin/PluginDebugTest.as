package com.bourre.plugin
{
	import flexunit.framework.TestCase;

	public class PluginDebugTest extends TestCase
	{
		private var _opluginDebug : PluginDebug
		
		override public function setUp() : void
		{
			private var 
			_opluginDebug = PluginDebug.getInstance()
			
		}
		
		public function testGetInstance() : void
		{
			assertNotNull( "PluginDebugTest constructor returns null", _opluginDebug );
		}
		
		function public testdebug : void
		{
			
		}
		
		function public testinfo : void
		{
			
		}
		
		function public testwarn : void
		{
			
		}
		
		function public testerror : void
		{
			
		}
		
		
	}
}
