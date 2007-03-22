package com.bourre.plugin
{
	import com.bourre.commands.FrontController;
	import com.bourre.events.*;
	import com.bourre.log.PixlibStringifier;
	import com.bourre.model.ModelLocator;
	import com.bourre.view.ViewLocator;

	import flash.events.Event;

	public class AbstractPlugin
		implements IPlugin
	{
		protected var abstractPluginConstructorAccess : AbstractPluginConstructorAccess = new AbstractPluginConstructorAccess();
		
		private var _oABExternal : ApplicationBroadcaster;
		private var _oEBPublic : EventBroadcaster;
		private var _oEBPrivate : EventBroadcaster;

		private var _oController : FrontController;
		private var _oModelLocator : ModelLocator;
		private var _oViewLocator : ViewLocator;

		public static const onInitEVENT : String = "onInit";
		public static const onReleaseEVENT : String = "onRelease";

		public function AbstractPlugin( access : AbstractPluginConstructorAccess ) 
		{
			_oController = new FrontController( this );
			_oModelLocator = ModelLocator.getInstance( this );
			_oViewLocator = ViewLocator.getInstance( this );
				
			_oABExternal = ApplicationBroadcaster.getInstance();
			_oEBPublic = ApplicationBroadcaster.getInstance().getChannelDispatcher( getChannel(), this );
			_oEBPrivate = getController().getBroadcaster();
				
			_oEBPublic.addListener( this );
		}
		
		public function onInitPlugin() : void
		{
			firePublicEvent( new Event( AbstractPlugin.onInitEVENT ) );
		}
		
		public function onReleasePlugin() : void
		{
			firePublicEvent( new Event( AbstractPlugin.onReleaseEVENT ) );
		}
		
		public function getChannel() : EventChannel
		{
			return ChannelExpert.getInstance().getChannel( this );
		}
		
		public function getController() : FrontController
		{
			return _oController;
		}
		
		public function getModelLocator() : ModelLocator
		{
			return _oModelLocator;
		}
		
		public function getViewLocator() : ViewLocator
		{
			return _oViewLocator;
		}
		
		public function getLogger() : PluginDebug
		{
			return PluginDebug.getInstance( this );
		}
		
		public function fireExternalEvent( e : Event, externalChannel : EventChannel ) : void
		{
			if ( externalChannel != getChannel() ) 
			{
				_oABExternal.broadcastEvent( e, externalChannel );
				
			} else
			{
				getLogger().error( this + ".fireExternalEvent() failed, '" + externalChannel + "' is its public channel." );
			
			}
		}
		
		public function firePublicEvent( e : Event ) : void
		{
			_oEBPublic.broadcastEvent( e );
		}
		
		public function firePrivateEvent( e : Event ) : void
		{
			_oEBPrivate.broadcastEvent( e );
		}
		
		public function addListener( listener : PluginListener ) : void
		{
			_oEBPublic.addListener( listener );
		}
		
		public function removeListener( listener : PluginListener ) : void
		{
			_oEBPublic.removeListener( listener );
		}
		
		public function addEventListener( type : String, listener : Object ) : void
		{
			_oEBPublic.addEventListener.apply( _oEBPublic, arguments );
		}
		
		public function removeEventListener( type : String, listener : Object ) : void
		{
			_oEBPublic.removeEventListener( type, listener );
		}
		
		/**
		 * Returns the string representation of this instance.
		 * @return the string representation of this instance
		 */
		public function toString() : String 
		{
			return PixlibStringifier.stringify( this );
		}
	}
}

internal class AbstractPluginConstructorAccess {}