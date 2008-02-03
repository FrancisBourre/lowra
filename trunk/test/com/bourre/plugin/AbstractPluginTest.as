package com.bourre.plugin
{
	import flash.events.Event;
	
	import com.bourre.events.ApplicationBroadcaster;
	import com.bourre.events.EventChannel;
	import com.bourre.model.ModelLocator;
	import com.bourre.view.ViewLocator;
	
	import flexunit.framework.TestCase;	

	public class AbstractPluginTest extends TestCase
	{
		private var _oPlug : MockPlugin;
		private var _oChanel : EventChannel;
		
		public override function setUp() : void
		{
			this._oChanel = new MockEventChannel();
			ChannelExpert.getInstance().registerChannel(_oChanel);
			this._oPlug =  new MockPlugin();
		}
		
		public function test_Constructor() : void
		{
			assertNotNull("failed to construct new mockPlugin", this._oPlug);
			
			assertEquals("failed to create mockPlugin with the good channel", this._oChanel,this._oPlug.getChannel())
			
			assertNotNull("failed to construct new mockEventChannel", this._oChanel);
			
		}
		
		public function test_GetMVC() : void
		{
			var _oPlug2 : AbstractPlugin = new MockPlugin()
			
			assertEquals("failed to create mockPlugin with the good channel", ApplicationBroadcaster.getInstance().NO_CHANNEL, _oPlug2.getChannel())			
			//asser that 
			assertNotNull(_oPlug+'.getController() is null', _oPlug.getController());
			assertTrue(_oPlug+'.getController() is equal to getController of another object',
				 _oPlug2.getController() != _oPlug.getController());
			
			assertNotNull(_oPlug+'.getModelLocator() is null', _oPlug.getModelLocator());
			assertTrue(_oPlug+'.getModelLocator() is equal to getModelLocator of another object',
				 _oPlug2.getModelLocator() != _oPlug.getModelLocator());
			assertTrue(_oPlug+'.getModelLocator() is equal to the global getModelLocator',
				 _oPlug2.getModelLocator() != ModelLocator.getInstance());
				 
			assertNotNull(_oPlug+'.getViewLocator() is null', _oPlug.getViewLocator());
			assertTrue(_oPlug+'.getViewLocator() is equal to getViewLocator of another object',
				 _oPlug2.getViewLocator() != _oPlug.getViewLocator());
			assertTrue(_oPlug+'.getModelLocator() is equal to the global ViewLocator',
				 _oPlug2.getViewLocator() != ViewLocator.getInstance( ));
		}
		
		public function test_fireOnInitPlugin() : void
		{
			var plugListener :MockPluginListener = new MockPluginListener()
			_oPlug.addListener(plugListener)
			_oPlug.fireOnInitPlugin()
			
			assertTrue(_oPlug+'.firePublicEvent() dont call the listener',
				 plugListener.isCAlled);
			assertEquals(_oPlug+'.firePublicEvent() dont broadcast the good event',
				PluginEvent.onInitPluginEVENT,
				plugListener.evt.type);	
		}
		
		public function test_fireOnReleasePlugin() : void
		{
			var myListener :MockPluginListener = new MockPluginListener()
			_oPlug.addListener(myListener)
			_oPlug.fireOnReleasePlugin()
			
			assertTrue(_oPlug+'.firePublicEvent() dont call the listener',
				 myListener.isCAlled);
			assertEquals(_oPlug+'.firePublicEvent() dont broadcast the good event',
				PluginEvent.onReleasePluginEVENT,
				myListener.evt.type);	
		}
		
		public function test_firePublicEvent() : void
		{
			var myListener :MockPluginListener = new MockPluginListener()
			var myEvent : Event = new Event("onMyEvent")
			
			_oPlug.addListener(myListener)
			_oPlug.firePublicEvent (myEvent)
			
			assertTrue(_oPlug+'.firePublicEvent() dont call the listener',
				 myListener.isCAlled);
			assertEquals(_oPlug+'.firePublicEvent() dont broadcast the good event',
				myEvent,
				myListener.evt);
			
			
			
			myListener = new MockPluginListener()			
			ApplicationBroadcaster.getInstance().getChannelDispatcher(_oPlug.getChannel()).addListener(myListener)
			_oPlug.firePublicEvent (myEvent)
			
			assertTrue(_oPlug+'.firePublicEvent() dont call the listener',
				 myListener.isCAlled);
			assertEquals(_oPlug+'.firePublicEvent() dont broadcast the good event',
				myEvent,
				myListener.evt);
		}
		
		public function test_removeListener() : void
		{
			var myListener :MockPluginListener = new MockPluginListener()
			var myEvent : Event = new Event("onMyEvent")
			
			_oPlug.addListener(myListener)
			_oPlug.removeListener(myListener)
			_oPlug.firePublicEvent (myEvent)
			
			assertFalse(_oPlug+'.firePublicEvent() dont call the listener',
				 myListener.isCAlled);
		}
		
		public function test_addEventListener() : void
		{
			var myListener :MockPluginListener = new MockPluginListener()
			var myEvent : Event = new Event("onMyEvent")
			
			_oPlug.addEventListener(myEvent.type, myListener)
			_oPlug.firePublicEvent (myEvent)
			
			assertTrue(_oPlug+'.firePublicEvent() dont call the listener',
				 myListener.isCAlled);

			assertEquals(_oPlug+'.firePublicEvent() dont broadcast the good event',
				myEvent,
				myListener.evt);
		}
		
		public function test_removeEventListener() : void
		{
			var myListener :MockPluginListener = new MockPluginListener()
			var myEvent : Event = new Event("onMyEvent")
			
			_oPlug.addEventListener(myEvent.type, myListener)
			_oPlug.removeEventListener(myEvent.type, myListener)
			_oPlug.firePublicEvent (myEvent)
			
			assertFalse(_oPlug+'.firePublicEvent() dont call the listener',
				 myListener.isCAlled);
		}
		
		public function test_fireExternalEvent() : void
		{
			var myListener :MockPluginListener = new MockPluginListener()
			var myEvent : Event = new Event("onMyEvent")
			var channel2 : EventChannel = new MockEventChannel();
			ChannelExpert.getInstance().registerChannel(channel2);
			var plu2 : MockPlugin = new MockPlugin()
			
			plu2.addEventListener(myEvent.type,myListener)

			_oPlug.fireExternalEvent (myEvent, channel2)
			
			assertTrue(_oPlug+'.firePublicEvent() dont call the listener',
				 myListener.isCAlled);

			assertEquals(_oPlug+'.firePublicEvent() dont broadcast the good event',
				myEvent,
				myListener.evt);
		}
		
//		public function test_firePrivateEvent() : void
//		{
//			var myListener :MockPluginListener = new MockPluginListener()
//			var myEvent : Event = new Event("onMyEvent")
//			
//		
//			_oPlug.addListener(myListener);
//			
//			_oPlug.firePrivateEvent (myEvent)
//			
//			assertTrue(_oPlug+'.firePublicEvent() dont call the listener',
//				 myListener.isCAlled);
//
//			assertEquals(_oPlug+'.firePublicEvent() dont broadcast the good event',
//				myEvent,
//				myListener.evt);
//		}
		
	}
}

import flash.events.Event;

import com.bourre.events.EventChannel;
import com.bourre.plugin.AbstractPlugin;
import com.bourre.plugin.PluginListener;	

internal class MockPlugin extends AbstractPlugin
{
	function  MockPlugin()
	{
		super()
	}
	

	
}

import com.bourre.plugin.PluginEvent;

internal class MockPluginListener 
	implements PluginListener
{
	public var isCAlled: Boolean
	public var evt : Event
	
	public function MockPluginListener()
	{
		isCAlled = false
		
	}
	
	public function onInitPlugin( e : PluginEvent ) : void
	{
		isCAlled = true
		evt=e
	}
	
	public function onReleasePlugin( e : PluginEvent ) : void
	{
		isCAlled = true
		evt=e
	}
	public function onMyEvent( e : Event ) : void
	{
		isCAlled = true
		evt=e
	}

}

internal class MockEventChannel extends EventChannel
{
	function MockEventChannel()
	{
		super("myChannel")
	}
}