package com.bourre.plugin 
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
	import flash.events.Event;
	
	import com.bourre.events.EventChannel;
	import com.bourre.log.PixlibStringifier;
	import com.bourre.model.AbstractModel;
	import com.bourre.model.ModelLocator;
	import com.bourre.view.AbstractView;
	import com.bourre.view.ViewLocator;		
	final public class NullPlugin 
		implements Plugin
	{
		private static var _oI : NullPlugin = null;

		private var _channel : NullPluginChannel;

		public function NullPlugin ( access : PrivateConstructorAccess )
		{
			_channel = new NullPluginChannel();
		}

		public static function getInstance() : NullPlugin
		{
			if ( !(NullPlugin._oI is NullPlugin) ) NullPlugin._oI = new NullPlugin( new PrivateConstructorAccess() );
			return NullPlugin._oI;
		}

		public function fireOnInitPlugin() : void
		{
			
		}

		public function fireOnReleasePlugin() : void
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
			return _channel;
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

		public function getModel( key : String ) : AbstractModel
		{
			return ModelLocator.getInstance( this ).getModel( key );
		}
		
		public function getView( key : String ) : AbstractView
		{
			return ViewLocator.getInstance( this ).getView( key );
		}
	}
}

internal class PrivateConstructorAccess 
{
}

import com.bourre.events.EventChannel;

internal class NullPluginChannel extends EventChannel{}