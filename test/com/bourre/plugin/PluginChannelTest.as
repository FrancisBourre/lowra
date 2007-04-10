package com.bourre.plugin
{
	import flexunit.framework.TestCase;

	public class PluginChannelTest 
		extends TestCase
	{
		public function testGetInstance() : void
		{
			assertNotNull( "", PluginChannel.getInstance( "test" ) );
			assertStrictlyEquals( "", PluginChannel.getInstance( "test" ), PluginChannel.getInstance( "test" ) );
			assertFalse( "", PluginChannel.getInstance( "test" ) == PluginChannel.getInstance( "otherTest" ) );
		}
	}
}