package com.bourre.plugin
{
	import com.bourre.commands.FrontController;
	import com.bourre.events.EventChannel;
	import com.bourre.log.PixlibStringifier;
	import com.bourre.model.ModelLocator;
	import com.bourre.view.ViewLocator;

	import flash.events.Event;

	public class NullPlugin 
		implements IPlugin
	{
		private var _fc : FrontController;
		private static var NULL : NullPlugin = new NullPlugin();

		public function NullPlugin()
		{
			_fc = new FrontController( this );
		}

		public static function getInstance() : NullPlugin
		{
			return NullPlugin.NULL;
		}

		public function onInitPlugin() : void
		{
			
		}

		public function onReleasePlugin() : void
		{
			
		}

		public function fireExternalEvent( e : Event, channel : String ) : void
		{
			
		}

		public function firePublicEvent( e : Event ) : void
		{
			
		}

		public function firePrivateEvent( e : Event ) : void
		{
			
		}

		public function getChannel() : EventChannel
		{
			return new NullPluginChannel;
		}
		
		public function getController() : FrontController
		{
			return _fc;
		}
		
		public function getLogger() : PluginDebug
		{
			return PluginDebug.getInstance( this );
		}

		/**
		 * Returns the string representation of this instance.
		 * @return the string representation of this instance
		 */
		public function toString() : String 
		{
			return PixlibStringifier.stringify( this );
		}
/*
		public function getModelLocator() : ModelLocator
		{
			return ModelLocator.getInstance();
		}
		
		public function getViewLocator() : ViewLocator
		{
			return ViewLocator.getInstance();
		}
*/
	}
}

import com.bourre.events.EventChannel;

internal class NullPluginChannel 
	extends EventChannel
{	
	public function NullPluginChannel()
	{
		super( abstractConstructorAccess );
	}
}