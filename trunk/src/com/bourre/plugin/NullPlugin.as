package com.bourre.plugin
{
	import com.bourre.commands.FrontController;
	import com.bourre.events.EventChannel;
	import com.bourre.log.PixlibStringifier;
	import com.bourre.model.ModelLocator;
	import com.bourre.view.ViewLocator;

	import flash.events.Event;
	import com.bourre.log.PixlibDebug;

	public class NullPlugin 
		implements IPlugin
	{
		private static var _oI : NullPlugin = new NullPlugin();

		public function NullPlugin()
		{
			
		}

		public static function getInstance() : NullPlugin
		{
			if ( !(NullPlugin._oI is NullPlugin) ) NullPlugin._oI = new NullPlugin();
			return NullPlugin._oI;
		}

		public function onInitPlugin() : void
		{
			
		}

		public function onReleasePlugin() : void
		{
			
		}

		public function fireExternalEvent( e : Event, channel : EventChannel ) : void
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
			return null;
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

		public function getModelLocator() : ModelLocator
		{
			return ModelLocator.getInstance( this );
		}
		
		public function getViewLocator() : ViewLocator
		{
			return ViewLocator.getInstance( this );
		}
	}
}