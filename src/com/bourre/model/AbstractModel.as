package com.bourre.model
{

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
	
	/**
	 * @author Francis Bourre
	 * @version 1.0
	 */
	
	import com.bourre.events.EventBroadcaster;
	import com.bourre.log.PixlibStringifier;
	import flash.events.Event;
	import com.bourre.plugin.IPlugin;
	import com.bourre.plugin.PluginDebug;
	import com.bourre.plugin.NullPlugin;
	import com.bourre.events.StringEvent;
	
	public class AbstractModel 
	{
		protected var abstractModelConstructorAccess : AbstractModelConstructorAccess = new AbstractModelConstructorAccess();
		
		public static const onInitEVENT : String = "onInit";
		
		private var _oEB : EventBroadcaster;
		private var _sName : String;
		private var _owner : IPlugin;
		
		public function AbstractModel(  access : AbstractModelConstructorAccess, owner : IPlugin = null, name : String = null ) 
		{
			_oEB = new EventBroadcaster( this );
			
			if ( owner ) setOwner( owner );
			if ( name ) setName( name );
		}
		
		protected function onInit() : void
		{
			notifyChanged( new StringEvent( AbstractModel.onInitEVENT, getName() ) );
		}
		
		public function setName( name : String ) : void
		{
			var ml : ModelLocator = ModelLocator.getInstance( getOwner() );
			
			if ( !( ml.isRegistered( name ) ) )
			{
				if ( ml.isRegistered( getName() ) ) ml.unregisterModel( getName() );
				if ( ml.registerModel( name, this ) ) _sName = name;
				
			} else
			{
				getLogger().error( this + ".setName() failed. '" + name + "' is already registered in ModelLocator." );
			}
		}
		
		public function getOwner() : IPlugin
		{
			return _owner;
		}
		
		public function setOwner( owner : IPlugin ) : void
		{
			_owner = owner ? owner : NullPlugin.getInstance();
		}
		
		public function getLogger() : PluginDebug
		{
			return PluginDebug.getInstance( getOwner() );
		}
		
		public function notifyChanged( e : Event ) : void
		{
			_getBroadcaster().broadcastEvent( e );
		}
		
		public function getName() : String
		{
			return _sName;
		}
		
		public function release() : void
		{
			_getBroadcaster().removeAllListeners();
			ModelLocator.getInstance( getOwner() ).unregisterModel( getName() );
			_sName = null;
		}
	
		public function addListener( oL : Object ) : void
		{
			_getBroadcaster().addListener(oL);
		}
		
		public function removeListener( oL : Object ) : void
		{
			_getBroadcaster().removeListener( oL );
		}
		
		public function addEventListener( e : String, oL : Object , f : Function ) : void
		{
			_getBroadcaster().addEventListener.apply( _getBroadcaster(), arguments );
		}
		
		public function removeEventListener( e : String,  oL : Object ) : void
		{
			_getBroadcaster().removeEventListener( e,  oL );
		}
		
		//
		private function _getBroadcaster() : EventBroadcaster
		{
			return _oEB;
		}
		
		private function _firePrivateEvent( e : Event ) : void
		{
			getOwner().firePrivateEvent( e );
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

internal class AbstractModelConstructorAccess {}