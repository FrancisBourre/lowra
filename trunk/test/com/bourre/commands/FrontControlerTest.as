package com.bourre.commands
{
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	import com.bourre.events.EventBroadcaster;
	import com.bourre.plugin.NullPlugin;
	import com.bourre.plugin.Plugin;
	
	import flexunit.framework.TestCase;		

	public class FrontControlerTest extends TestCase
	{
		private var _oFC : FrontController;
		private var _oFCOwner : FrontController;
		private var _oPlugin : Plugin;
		public var isExecuted : Boolean;
		public var commandOwner : Plugin;
		
		override public function setUp() : void
		{
			this._oFC = new FrontController();
			this._oPlugin = new MockPlugin();
			this._oFCOwner = new FrontController(_oPlugin);
			
			this.isExecuted = false;
			this.commandOwner= null;
			MockCommand.testclass=this;
		}
		
		public function testConstructor() : void
		{
			/*assertNotNull("Failed to construct a new Front controller", _oFC)
			assertNotNull("Failed to construct a new Front controller with a pugin", _oFCOwner)*/
		}
		
		
		public function testGetOwner() : void
		{
			assertEquals("Failed to getOwner", NullPlugin.getInstance(), _oFC.getOwner());
			
			assertEquals("Failed to getOwner", _oPlugin, _oFCOwner.getOwner());
			
		}
		
//		public function testGetBroadcaster() : void
//		{
//			
//			assertEquals("Failed to get broadcaster ",EventBroadcaster.getInstance(), _oFC.getBroadcaster());
//
//			assertNotNull("Failed to get broadcaster ", _oFCOwner.getBroadcaster());
//		}
		
		public function testRunCommand() : void
		{
			var evt : Event = new Event("anEvent");
			_oFC.pushCommandClass("anEvent", MockCommand);
			_oFC.handleEvent (evt);
			assertTrue("Failed to execute a command", this.isExecuted);
			assertEquals("Failed to get good command owner",  NullPlugin.getInstance(), this.commandOwner);
		}
		
		public function testRunCommandWithOwner() : void
		{
			 var evt : Event = new Event("anEvent");
			_oFCOwner.pushCommandClass("anEvent", MockCommand);
			_oFCOwner.handleEvent (evt);
			assertTrue("Failed to execute a command", this.isExecuted);
			assertEquals("Failed to get good command owner", _oPlugin, this.commandOwner);
		}
		
		public function testRunCommandWithEmptyFC() : void
		{
			var evt : Event = new Event("anEvent");
			var errorOccure : Boolean = false;
			try
			{
				_oFC.handleEvent (evt);
			}
			catch(e : Event)
			{
				errorOccure = true;
			}
			assertFalse("Failed to handle event with an empty Front controler", errorOccure);
		}
		
		public function testRemove() : void
		{
			 var evt : Event = new Event("anEvent");
			_oFCOwner.pushCommandClass("anEvent", MockCommand);
			_oFCOwner.remove("anEvent");
			
			var errorOccure : Boolean = false;
			try
			{
				_oFC.handleEvent (evt);
				
			}catch(e : Event)
			{
				errorOccure = true;
			}
			assertFalse("Failed to handle event with an empty Front controler after remove", errorOccure);
			assertFalse("Failed to execute a command", this.isExecuted);
			assertNull("Failed to get good command owner", this.commandOwner);
			
		}
		
		public function testRunDelegate() : void
		{
			var o : Object = {};
			var e : Event = new Event( "onTest" );
			_oFC.pushCommandInstance( "onTest", new Delegate( onTestRunDelegate, o ) );
			EventBroadcaster.getInstance().broadcastEvent( e );
			assertEquals( "", 5, o.n );
			assertStrictlyEquals( "", e, o.e );
		}

		public function onTestRunDelegate( e : Event, o : Object ) : void
		{
			o.e = e;
			o.n = 5;
		}

		public function testAdd() : void
		{
			var d : Dictionary = new Dictionary();
			d["anEvent"] = MockCommand;

			_oFC.add( d );
			_oFC.handleEvent ( new Event("anEvent") );

			assertTrue( "Failed to execute a command", this.isExecuted );
			assertEquals( "Failed to get good command owner",  NullPlugin.getInstance(), this.commandOwner );
		}
	}
}

import flash.events.Event;

import com.bourre.commands.AbstractCommand;
import com.bourre.commands.FrontControlerTest;
import com.bourre.events.EventChannel;
import com.bourre.model.ModelLocator;
import com.bourre.plugin.Plugin;
import com.bourre.plugin.PluginDebug;
import com.bourre.view.ViewLocator;

internal class MockCommand extends AbstractCommand
{
	public static var testclass : FrontControlerTest;
	
	override public function execute( e : Event= null ) : void 
	{
		testclass.isExecuted = true;
		testclass.commandOwner = this.getOwner();
	}
}

internal class MockPlugin implements Plugin
{
		public function  fireOnInitPlugin() : void
		{}
		
		public function  fireOnReleasePlugin() : void
		{}
		
		public function fireExternalEvent( e : Event, channel : EventChannel ) : void
		{}
		
		public function firePublicEvent( e : Event ) : void
		{}
		
		public function firePrivateEvent( e : Event ) : void
		{}
		
		public function getChannel() : EventChannel
		{
			return new AChannel();
		}
		
		public function getLogger() : PluginDebug
		{
			return  PluginDebug.getInstance();
		}

		public function getModelLocator() : ModelLocator
		{
			return ModelLocator.getInstance();
		}
		
		public function getViewLocator() : ViewLocator
		{
			return ViewLocator.getInstance();
		}
}

internal  class AChannel extends EventChannel
{
	function AChannel()
	{
	}
}


