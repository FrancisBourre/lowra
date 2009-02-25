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
	import com.bourre.error.PrivateConstructorException;
	import com.bourre.events.EventChannel;
	import com.bourre.log.PixlibStringifier;
	import com.bourre.model.AbstractModel;
	import com.bourre.model.ModelLocator;
	import com.bourre.view.AbstractView;
	import com.bourre.view.ViewLocator;
	
	import flash.events.Event;	

	/**
	 * The NullPlugin class defines a default plugin to use if none is defined 
	 * current application.
	 * 
	 * <p>Can be used to allow Front controller, locators and event channel 
	 * concept on non IoC application.
	 * 
	 * @author 	Francis Bourre
	 */
	final public class NullPlugin implements Plugin
	{
		private static var _oI : NullPlugin = null;

		private var _channel : NullPluginChannel;
		
		/**
		 * @private
		 */
		function NullPlugin ( access : ConstructorAccess )
		{
			if ( !(access is ConstructorAccess) ) throw new PrivateConstructorException();
			
			_channel = new NullPluginChannel();
		}
		
		/**
		 * Returns singleton instance of <code>NullPlugin</code> class.
		 * 
		 * @return The singleton instance of <code>NullPlugin</code> class.
		 */
		public static function getInstance() : NullPlugin
		{
			if ( !(NullPlugin._oI is NullPlugin) ) NullPlugin._oI = new NullPlugin( new ConstructorAccess() );
			return NullPlugin._oI;
		}
		
		/**
		 * @private
		 */
		public function fireOnInitPlugin() : void
		{
			
		}
		
		/**
		 * @private
		 */
		public function fireOnReleasePlugin() : void
		{
			
		}
		
		/**
		 * @inheritDoc
		 */
		public function fireExternalEvent( e : Event, channel : EventChannel ) : void
		{
			
		}
		
		/**
		 * @inheritDoc
		 */
		public function firePublicEvent( e : Event ) : void
		{
			
		}
	
		/**
		 * @inheritDoc
		 */
		public function firePrivateEvent( e : Event ) : void
		{
			
		}
		
		/**
		 * @inheritDoc
		 */
		public function getChannel() : EventChannel
		{
			return _channel;
		}

		public function getLogger() : PluginDebug
		{
			return PluginDebug.getInstance( this );
		}

		/**
		 * @inheritDoc
		 */
		public function getModel( key : String ) : AbstractModel
		{
			return ModelLocator.getInstance( this ).getModel( key );
		}
		
		/**
		 * @inheritDoc
		 */
		public function getView( key : String ) : AbstractView
		{
			return ViewLocator.getInstance( this ).getView( key );
		}				public function isModelRegistered( key : String ) : Boolean		{
			return ModelLocator.getInstance( this ).isRegistered( key );
		}		
		/**
		 * @inheritDoc
		 */		public function isViewRegistered( key : String ) : Boolean		{
			return ViewLocator.getInstance( this ).isRegistered( key );
		}
		
		/**
		 * @inheritDoc
		 */
		public function onApplicationInit( ) : void
		{
			fireOnInitPlugin();
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
internal class ConstructorAccess 
{
}

import com.bourre.events.EventChannel;

internal class NullPluginChannel extends EventChannel{}