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
	 * The AbstractPlugin class.
	 * 
	 * <p>TODO Documentation.</p>
	 * 
	 * @author 	Francis Bourre
	 */
	public class AbstractPlugin
		implements Plugin
	{
		protected var _oEBPublic 		: Broadcaster;
		protected var _oController 		: FrontController;
		protected var _oModelLocator 	: ModelLocator;
		protected var _oViewLocator 	: ViewLocator;

		public function AbstractPlugin() 
		{
			_initialize();
		}

		protected function _initialize() : void
		{
			_oController = new FrontController( this );
			_oModelLocator = ModelLocator.getInstance( this );
			_oViewLocator = ViewLocator.getInstance( this );

			_oEBPublic = ApplicationBroadcaster.getInstance().getChannelDispatcher( getChannel(), this );
			if( _oEBPublic ) _oEBPublic.addListener( this );
		}
		
		public function getController() : FrontController
		{
			return _oController;
		}
		
		protected function getModelLocator() : ModelLocator
		{
			return _oModelLocator;
		}

		protected function getViewLocator() : ViewLocator
		{
			return _oViewLocator;
		}

		protected function fireOnInitPlugin() : void
		{
			firePublicEvent( new PluginEvent( PluginEvent.onInitPluginEVENT, this ) );
		}

		protected function fireOnReleasePlugin() : void
		{
			firePublicEvent( new PluginEvent( PluginEvent.onReleasePluginEVENT, this ) );
		}

		public function getChannel() : EventChannel
		{
			return ChannelExpert.getInstance().getChannel( this );
		}
		
		public function isModelRegistered( name : String ) : Boolean
		{
			return _oModelLocator.isRegistered( name );
		}

		public function getModel( key : String ) : AbstractModel
		{
			return _oModelLocator.getModel( key );
		}
		
		public function isViewRegistered( name : String ) : Boolean
		{
			return _oViewLocator.isRegistered( name );
		}
		
		public function getView( key : String ) : AbstractView
		{
			return _oViewLocator.getView( key );
		}

		public function getLogger() : PluginDebug
		{
			return PluginDebug.getInstance( this );
		}

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

		public function handleEvent ( e : Event = null ):void
		{
			
		}

		public function firePublicEvent( e : Event ) : void
		{
			if( _oEBPublic ) ( _oEBPublic as PluginBroadcaster ).firePublicEvent( e, this );
				else getLogger().warn( this + " doesn't have public dispatcher" );
		}

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