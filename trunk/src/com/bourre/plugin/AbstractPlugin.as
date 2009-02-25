/*
 * Copyright the original author or authors.
 * 
 * Licensed under the MOZILLA PUBLIC LICENSE, Version 1.1 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *      http://www.mozilla.org/MPL/MPL-1.1.html
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package com.bourre.plugin
{
	import com.bourre.commands.FrontController;
	import com.bourre.error.IllegalArgumentException;
	import com.bourre.events.ApplicationBroadcaster;
	import com.bourre.events.Broadcaster;
	import com.bourre.events.EventChannel;
	import com.bourre.ioc.bean.BeanFactory;
	import com.bourre.log.PixlibStringifier;
	import com.bourre.model.AbstractModel;
	import com.bourre.model.ModelLocator;
	import com.bourre.view.AbstractView;
	import com.bourre.view.ViewLocator;
	
	import flash.events.Event;	

	/**
	 *  Dispatched when plugin is initialized.
	 *  
	 *  @eventType com.bourre.plugin.PluginEvent.onInitPluginEVENT
	 */
	[Event(name="onInitPlugin", type="com.bourre.plugin.PluginEvent")]
	
	/**
	 *  Dispatched when plugin is released.
	 *  
	 *  @eventType com.bourre.plugin.PluginEvent.onReleasePluginEVENT
	 */
	[Event(name="onReleasePlugin", type="com.bourre.plugin.PluginEvent")]
	
	
	/**
	 * Abstract implementation of <code>Plugin</code>.
	 * 
	 * @author 	Francis Bourre
	 */
	public class AbstractPlugin implements Plugin
	{
		//--------------------------------------------------------------------
		// Protected properties
		//--------------------------------------------------------------------
		
		/**Public Braodcaster */
		protected var _oEBPublic 		: Broadcaster;
		
		/** Plugin FronController */
		protected var _oController 		: FrontController;
		
		/** Locator for models */
		protected var _oModelLocator 	: ModelLocator;
		
		/** Locator for views */
		protected var _oViewLocator 	: ViewLocator;
		
		
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
		
		/**
		 * Creates new <code>AbstractPlugin</code> instance.
		 */
		public function AbstractPlugin() 
		{
			_initialize();
		}
		
		/**
		 * Starts plugin initialisation.
		 * 
		 * <p>builds all locator, and event channel.</p>
		 */
		protected function _initialize() : void
		{
			_oController = new FrontController( this );
			_oModelLocator = ModelLocator.getInstance( this );
			_oViewLocator = ViewLocator.getInstance( this );

			_oEBPublic = ApplicationBroadcaster.getInstance().getChannelDispatcher( getChannel(), this );
			if( _oEBPublic ) _oEBPublic.addListener( this );
		}
		
		/**
		 * Returns plugin's FrontController.
		 */
		public function getController() : FrontController
		{
			return _oController;
		}
		
		/**
		 * Returns plugin's model locator.
		 */
		protected function getModelLocator() : ModelLocator
		{
			return _oModelLocator;
		}
		
		/**
		 * Returns plugin's view locator.
		 */
		protected function getViewLocator() : ViewLocator
		{
			return _oViewLocator;
		}
		
		/**
		 * Fires <code>onInitPlugin</code> event type.
		 * 
		 * @event onInitPlugin com.bourre.plugin.PluginEvent When plugin is initialized
		 */
		protected function fireOnInitPlugin() : void
		{
			firePublicEvent( new PluginEvent( PluginEvent.onInitPluginEVENT, this ) );
		}
		
		/**
		 * Fires <code>onReleasePlugin</code> event type.
		 * 
		 * @event onReleasePlugin com.bourre.plugin.PluginEvent When plugin is released
		 */
		protected function fireOnReleasePlugin() : void
		{
			firePublicEvent( new PluginEvent( PluginEvent.onReleasePluginEVENT, this ) );
		}
		
		/**
		 * @inheritDoc
		 */
		public function getChannel() : EventChannel
		{
			return ChannelExpert.getInstance().getChannel( this );
		}
		
		/**
		 * @inheritDoc
		 */
		public function isModelRegistered( name : String ) : Boolean
		{
			return _oModelLocator.isRegistered( name );
		}
		
		/**
		 * @inheritDoc
		 */
		public function getModel( key : String ) : AbstractModel
		{
			return _oModelLocator.getModel( key );
		}
		
		/**
		 * @inheritDoc
		 */
		public function isViewRegistered( name : String ) : Boolean
		{
			return _oViewLocator.isRegistered( name );
		}
		
		/**
		 * @inheritDoc
		 */
		public function getView( key : String ) : AbstractView
		{
			return _oViewLocator.getView( key );
		}
		
		/**
		 * @inheritDoc
		 */
		public function getLogger() : PluginDebug
		{
			return PluginDebug.getInstance( this );
		}
		
		/**
		 * @inheritDoc
		 */
		public function fireExternalEvent( e : Event, externalChannel : EventChannel ) : void
		{
			if ( externalChannel != getChannel() ) 
			{
				ApplicationBroadcaster.getInstance().broadcastEvent( e, externalChannel );
				
			} else
			{
				var msg : String = this + ".fireExternalEvent() failed, '" + externalChannel + "' is its public channel.";
				getLogger().error( msg );
				throw new IllegalArgumentException( msg );
			}
		}
		
		/**
		 * @private
		 */
		public function handleEvent ( e : Event = null ):void
		{
			
		}
		
		/**
		 * @inheritDoc
		 */
		public function firePublicEvent( e : Event ) : void
		{
			if( _oEBPublic ) ( _oEBPublic as PluginBroadcaster ).firePublicEvent( e, this );
				else getLogger().warn( this + " doesn't have public dispatcher" );
		}
		
		/**
		 * @inheritDoc
		 */
		public function firePrivateEvent( e : Event ) : void
		{
			if ( _oController.isRegistered( e.type ) ) 
			{
				_oController.handleEvent( e );

			} else
			{
				getLogger().debug( this + ".firePrivateEvent() fails to retrieve command associated with '" + e.type + "' event type." );
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function onApplicationInit( ) : void
		{
			fireOnInitPlugin();
		}
		
		/**
		 * Releases instance.
		 * 
		 * <p>All locators are releases.<br />
		 * Event controller and channel too.</p>
		 */
		public function release() : void
		{
			_oController.release();
			_oModelLocator.release( );
			_oViewLocator.release();

			var key : String = BeanFactory.getInstance().getKey( this );
			BeanFactory.getInstance().unregister( key );
			fireOnReleasePlugin();

			_oEBPublic.removeAllListeners();

			ApplicationBroadcaster.getInstance().releaseChannelDispatcher( getChannel() );
			PluginDebug.release( this );
			ChannelExpert.getInstance().releaseChannel( this );
		}
		
		/**
		 * @copy com.bourre.events.Broadcaster#addListener()
		 */
		public function addListener( listener : PluginListener ) : Boolean
		{
			if( _oEBPublic ) 
			{
				return _oEBPublic.addListener( listener );
				
			} else 
			{
				getLogger().warn( this + " doesn't have public dispatcher" );
				return false;
			}
		}
		
		/**
		 * @copy com.bourre.events.Broadcaster#removeListener()
		 */
		public function removeListener( listener : PluginListener ) : Boolean
		{
			if( _oEBPublic ) 
			{
				return _oEBPublic.removeListener( listener );

			} else 
			{
				getLogger().warn( this + " doesn't have public dispatcher" );
				return false;
			}
		}
		
		/**
		 * @copy com.bourre.events.Broadcaster#addEventListener()
		 */
		public function addEventListener( type : String, listener : Object, ... rest ) : Boolean
		{
			if( _oEBPublic ) 
			{
				return _oEBPublic.addEventListener.apply( _oEBPublic, rest.length > 0 ? [ type, listener ].concat( rest ) : [ type, listener ] );
			
			} else 
			{
				getLogger().warn( this + " doesn't have public dispatcher" );
				return false;
			}
		}
		
		/**
		 * @copy com.bourre.events.Broadcaster#removeEventListener()
		 */
		public function removeEventListener( type : String, listener : Object ) : Boolean
		{
			if( _oEBPublic ) 
			{
				return _oEBPublic.removeEventListener( type, listener );

			} else 
			{
				getLogger().warn( this + " doesn't have public dispatcher" );
				return false;
			}
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