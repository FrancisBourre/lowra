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
package com.bourre.model
{
	import com.bourre.events.EventBroadcaster;
	import com.bourre.events.StringEvent;
	import com.bourre.log.PixlibStringifier;
	import com.bourre.plugin.NullPlugin;
	import com.bourre.plugin.Plugin;
	import com.bourre.plugin.PluginDebug;

	import flash.events.Event;	
	
	/**
	 *  Dispatched when the user presses the Button control.
	 *  If the <code>autoRepeat</code> property is <code>true</code>,
	 *  this event is dispatched repeatedly as long as the button stays down.
	 *
	 *  @eventType com.bourre.model.AbstractModel.onInitModelEVENT
	 */
	[Event(name="onInitModel", type="com.bourre.events.StringEvent")]
	
	/**
	 *  Dispatched when the user presses the Button control.
	 *  If the <code>autoRepeat</code> property is <code>true</code>,
	 *  this event is dispatched repeatedly as long as the button stays down.
	 *
	 *  @eventType com.bourre.model.AbstractModel.onReleaseModelEVENT
	 */
	[Event(name="onReleaseModel", type="com.bourre.events.StringEvent")]
	
	/**
	 * Abstract implementation of Model part of the MVC implementation.
	 * 
	 * @author Francis Bourre
	 */
	public class AbstractModel 
	{
		//--------------------------------------------------------------------
		// Constants
		//--------------------------------------------------------------------
		
		/**
		 * Defines the value of the <code>type</code> property of the event 
		 * object for a <code>onInitModel</code> event.
		 * 
		 * @eventType onInitModel
		 */		
		public static const onInitModelEVENT : String = "onInitModel";
		
		/**
		 * Defines the value of the <code>type</code> property of the event 
		 * object for a <code>onInitModel</code> event.
		 * 
		 * @eventType onInitModel
		 */	
		public static const onReleaseModelEVENT : String = "onReleaseModel";

		
		//--------------------------------------------------------------------
		// Protected properties
		//--------------------------------------------------------------------
		
		/** Dedicated Broadcaster for this model. */
		protected var _oEB : EventBroadcaster;
		
		/** Model identifier. */
		protected var _sName : String;
		
		/** Plugin owner. */
		protected var _owner : Plugin;

		
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
		
		/**
		 * Creates instance.
		 * 
		 * @param	owner	(optional) Plugin owner.<br />
		 * 					If <code>null</code>, use <code>NullPlugin</code>
		 * 					instance.
		 * @param	name	Model's identifier to register into model locator.
		 */		
		public function AbstractModel( owner : Plugin = null, name : String = null ) 
		{
			_oEB = new EventBroadcaster( this );
			
			setOwner( owner );
			if ( name ) setName( name );
		}

		/**
		 * Defines specific event listener type, compliant to 
		 * listen this model event broadcaster.
		 */
		public function setListenerType( type : Class ) : void
		{
			_oEB.setListenerType( type );
		}

		/** @private */
		public function handleEvent( e : Event ) : void
		{
			//
		}

		/**
		 * Broadcasts <code>onInitModel</code> event to listeners.
		 */
		protected function onInitModel() : void
		{
			notifyChanged( new StringEvent( AbstractModel.onInitModelEVENT, this, getName( ) ) );
		}

		/**
		 * Broadcasts <code>onReleaseModel</code> event to listeners.
		 */
		protected function onReleaseModel() : void
		{
			notifyChanged( new StringEvent( AbstractModel.onReleaseModelEVENT, this, getName( ) ) );
		}

		public function setName( name : String ) : void
		{
			var ml : ModelLocator = ModelLocator.getInstance( getOwner( ) );
			
			if ( !( ml.isRegistered( name ) ) )
			{
				if ( getName( ) != null && ml.isRegistered( getName( ) ) ) ml.unregister( getName( ) );
				if ( ml.register( name, this ) ) _sName = name;
			} 
			else
			{
				getLogger( ).error( this + ".setName() failed. '" + name + "' is already registered in ModelLocator." );
			}
		}

		/**
		 * Returns plugin owner.
		 */
		public function getOwner() : Plugin
		{
			return _owner;
		}

		/**
		 * Sets the plugin owner for model.
		 * 
		 * <p>if owner is <code>null</code>, use <code>NullPlugin</code> 
		 * instance.</p>
		 */
		public function setOwner( owner : Plugin ) : void
		{
			_owner = owner ? owner : NullPlugin.getInstance( );
		}

		/**
		 * Returns model logger tunnel.
		 */
		public function getLogger() : PluginDebug
		{
			return PluginDebug.getInstance( getOwner( ) );
		}

		/**
		 * @copy com.bourre.events.Broadcaster#broadcastEvent()
		 */
		public function notifyChanged( e : Event ) : void
		{
			getBroadcaster( ).broadcastEvent( e );
		}

		/**
		 * Returns model identifier.
		 */
		public function getName() : String
		{
			return _sName;
		}

		/**
		 * Releases model.
		 * 
		 * <p>
		 * <ul>
		 * 	<li>Unregisters model from model locator.</li>
		 * 	<li>Dispatched "onReleaseModel" event.</li>
		 * 	<li>Removes all event listeners.</li>
		 * </ul>
		 */
		public function release() : void
		{
			ModelLocator.getInstance( getOwner( ) ).unregister( getName( ) );
			onReleaseModel( );
			getBroadcaster( ).removeAllListeners( );
			_sName = null;
		}

		/**
		 * @copy com.bourre.events.Broadcaster#addListener()
		 */
		public function addListener( listener : ModelListener ) : Boolean
		{
			return _oEB.addListener( listener );
		}

		/**
		 * @copy com.bourre.events.Broadcaster#removeListener()
		 */
		public function removeListener( listener : ModelListener ) : Boolean
		{
			return _oEB.removeListener( listener );
		}

		/**
		 * @copy com.bourre.events.Broadcaster#addEventListener()
		 */
		public function addEventListener( type : String, listener : Object, ... rest ) : Boolean
		{
			return _oEB.addEventListener.apply( _oEB, rest.length > 0 ? [ type, listener ].concat( rest ) : [ type, listener ] );
		}

		/**
		 * @copy com.bourre.events.Broadcaster#removeEventListener()
		 */
		public function removeEventListener( type : String, listener : Object ) : Boolean
		{
			return _oEB.removeEventListener( type, listener );
		}

		/**
		 * Returns event broadcaster used by model.
		 */
		protected function getBroadcaster() : EventBroadcaster
		{
			return _oEB;
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