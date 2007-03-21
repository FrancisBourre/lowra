package com.bourre.commands
{
	import flexunit.framework.TestCase;
	import flexunit.framework.AssertionFailedError;
	import com.bourre.plugin.IPlugin;
	import com.bourre.events.EventChannel;
	import com.bourre.plugin.NullPlugin;
	import com.bourre.events.EventBroadcaster;
	import flash.events.Event

	public class FrontControlerTest extends TestCase
	{
		private var _oFC : FrontController
		private var _oFCOwner : FrontController
		private var _oPlugin : IPlugin
		public var isExecuted : Boolean
		public var commandOwner : IPlugin
		
		override public function setUp() : void
		{
			this._oFC = new FrontController()
			this._oPlugin = new MockPlugin()
			this._oFCOwner = new FrontController(_oPlugin)
			
			this.isExecuted = false
			this.commandOwner= null
			MockCommand.testclass=this
		}
		
		public function testConstructor() : void
		{
			assertNotNull("Failed to construct a new Front controller", _oFC)
			assertNotNull("Failed to construct a new Front controller with a pugin", _oFCOwner)
		}
		
		
		public function testGetOwner() : void
		{
			assertEquals("Failed to getOwner", NullPlugin.getInstance(), _oFC.getOwner())
			
			assertEquals("Failed to getOwner", _oPlugin, _oFCOwner.getOwner())
		
			
		}
		
		public function testGetBroadcaster() : void
		{
			
			assertEquals("Failed to get broadcaster ",EventBroadcaster.getInstance(), _oFC.getBroadcaster())

			assertNotNull("Failed to get broadcaster ", _oFCOwner.getBroadcaster())
		}
		
		public function testRunCommand() : void
		{
			var evt : Event = new Event("anEvent")
			_oFC.pushCommandClass("anEvent", MockCommand)
			_oFC.handleEvent (evt)
			assertTrue("Failed to execute a command", this.isExecuted)
			assertEquals("Failed to get good command owner",  NullPlugin.getInstance(), this.commandOwner)
		}
		
		public function testRunCommandWithOwner() : void
		{
			 var evt : Event = new Event("anEvent")
			_oFCOwner.pushCommandClass("anEvent", MockCommand)
			_oFCOwner.handleEvent (evt)
			assertTrue("Failed to execute a command", this.isExecuted)
			assertEquals("Failed to get good command owner", _oPlugin, this.commandOwner)
		}
		public function testRunCommandWithEmptyFC() : void
		{
			var evt : Event = new Event("anEvent")
			var errorOccure : Boolean = false
			try
			{
				_oFC.handleEvent (evt)
			}catch(e : Event)
			{
				errorOccure = true
			}
			assertFalse("Failed to handle event with an empty Front controler", errorOccure)
			
			
		}
		
		public function testRemove() : void
		{
			 var evt : Event = new Event("anEvent")
			_oFCOwner.pushCommandClass("anEvent", MockCommand)
			_oFCOwner.remove("anEvent")
			
			var errorOccure : Boolean = false
			try
			{
				_oFC.handleEvent (evt)
				
			}catch(e : Event)
			{
				errorOccure = true
			}
			assertFalse("Failed to handle event with an empty Front controler after remove", errorOccure)
			assertFalse("Failed to execute a command", this.isExecuted)
			assertNull("Failed to get good command owner", this.commandOwner)
			
		}

	}
	
}


import com.bourre.commands.AbstractCommand;
import flash.events.Event;
import com.bourre.plugin.IPlugin;
import com.bourre.events.EventChannel;
import com.bourre.plugin.PluginDebug;
import com.bourre.model.ModelLocator;
import com.bourre.view.ViewLocator;
import com.bourre.commands.FrontControlerTest;


internal class MockCommand extends AbstractCommand
{
	public static var testclass : FrontControlerTest
	
	public function MockCommand()
	{
		super(super.abstractCommandConstructorAccess)
	}
	
	override public function execute( e : Event= null ) : void 
	{
		testclass.isExecuted = true
		testclass.commandOwner = this.getOwner()
	}
}

internal class MockPlugin implements IPlugin
{
		public function onInitPlugin() : void
		{}
		
		public function onReleasePlugin() : void
		{}
		
		public function fireExternalEvent( e : Event, channel : String ) : void
		{}
		
		public function firePublicEvent( e : Event ) : void
		{}
		
		public function firePrivateEvent( e : Event ) : void
		{}
		
		public function getChannel() : EventChannel
		{
			return new AChannel()
		}
		
		public function getLogger() : PluginDebug
		{
			return  PluginDebug.getInstance()
		}

		public function getModelLocator() : ModelLocator
		{
			return new ModelLocator()
		}
		
		public function getViewLocator() : ViewLocator
		{
			return ViewLocator.getInstance()
		}
}

internal  class AChannel extends EventChannel
{
	function AChannel()
	{
		super(eventChannelConstructorAccess)
	}
}


