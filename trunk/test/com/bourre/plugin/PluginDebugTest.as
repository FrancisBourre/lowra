package com.bourre.plugin
{
	import flexunit.framework.TestCase;
	import com.bourre.log.Logger;
	import com.bourre.log.LogLevel;

	public class PluginDebugTest extends TestCase
	{
		private var _oPluginDebug : PluginDebug
		private var _oLogListener : MockLogListener
		
		override public function setUp() : void
		{
			_oPluginDebug = PluginDebug.getInstance()
			_oLogListener = new MockLogListener()
			Logger.getInstance().addLogListener(_oLogListener)
		}
		
		public function testGetInstance() : void
		{
			assertNotNull( "PluginDebugTest constructor returns null", _oPluginDebug );
			assertEquals( "getChannel failed to return the good channel", NullPlugin.getInstance().getChannel(),_oPluginDebug.getChannel())
			assertEquals( "getOwner failed to return the good owner", NullPlugin.getInstance(),_oPluginDebug.getOwner())
			
		}
		
		public function  testdebug () : void
		{
			_oPluginDebug.debug(this)
			assertTrue("debug() failled listener dont called",_oLogListener.isCalled)
			assertEquals("debug() failled message event's is not good",this.toString(),_oLogListener.evt.message)
			assertEquals("debug() failled level event's is not good",LogLevel.DEBUG,_oLogListener.evt.level)
		}
		
		public function testinfo () : void
		{
			_oPluginDebug.info(this)
			assertTrue("info() failled listener dont called",_oLogListener.isCalled)
			assertEquals("info() failled message event's is not good",this.toString(),_oLogListener.evt.message)
			assertEquals("info() failled level event's is not good",LogLevel.INFO,_oLogListener.evt.level)
		}
		
		public function testwarn () : void
		{
			_oPluginDebug.warn(this)
			assertEquals("warn() failled message event's is not good",this.toString(),_oLogListener.evt.message)
			assertEquals("warn() failled level event's is not good",LogLevel.WARN,_oLogListener.evt.level)
			}
		
		public function testerror () : void
		{
			_oPluginDebug.error(this)
			assertEquals("error() failled message event's is not good",this.toString(),_oLogListener.evt.message)
			assertEquals("error() failled level event's is not good",LogLevel.ERROR,_oLogListener.evt.level)
		}
		
		
	}
}
import com.bourre.log.LogListener;
import com.bourre.log.LogEvent;
	

class MockLogListener implements LogListener
	{
		public var evt : LogEvent
		public var isCalled : Boolean
		
		public function onLog( e : LogEvent ) : void
		{
			isCalled = true
			evt = e
		}
	}
