package com.bourre.plugin
{
	import com.bourre.events.EventChannel;
	import flexunit.framework.TestCase;
	import com.bourre.model.ModelLocator
	import com.bourre.view.ViewLocator
	public class AbstractPluginTest extends TestCase
	{
		private var _oPlug : AbstractPlugin
		private var _oChanel : EventChannel
		
		public override function setUp() : void
		{
			
			trace('coucou')
			this._oChanel = new MockEventChannel();
			ChannelExpert.getInstance().registerChannel(_oChanel);
			this._oPlug =  new MockPlugin();
		}
		
		
		public function testConstructor() : void
		{
			assertNotNull("failed to construct new mockPlugin", this._oPlug);
			
			assertEquals("failed to create mockPlugin with the good channel", this._oChanel,this._oPlug.getChannel())
			
			assertNotNull("failed to construct new mockEventChannel", this._oChanel);
		}
		
		public function testGetMVC() : void
		{
			var _oPlug2 : AbstractPlugin = new MockPlugin()
			
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
		
		
		//diffusion des event
		
		//enregistrement des canaux automatique aprés la création 
		
		
	}
}

	import com.bourre.plugin.IPlugin;
	import com.bourre.plugin.AbstractPlugin;
	import com.bourre.model.ModelLocator;
	import com.bourre.view.ViewLocator;
	import com.bourre.plugin.PluginListener;
	import com.bourre.events.EventChannel;
	import flash.events.Event;

internal class MockPlugin extends AbstractPlugin
{
	function  MockPlugin()
	{
		super()
	}
	
}

internal class MockPluginListener implements PluginListener
{
	public function onInitPlugin( e : Event ) : void
	{
		
	}
	
	public function onDestroyPlugin( e : Event ) : void
	{
		
	}
}

internal class MockEventChannel extends EventChannel
{
	function MockEventChannel()
	{
		super("myChannel")
	}
}