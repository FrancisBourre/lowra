package com.bourre.commands
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

	import com.bourre.log.*;
	import com.bourre.plugin.*;

	import flash.events.Event;
	import com.bourre.model.ModelLocator;
	import com.bourre.view.ViewLocator;
	//import com.bourre.model.ModelLocator;
	//import com.bourre.view.ViewLocator;

	public class AbstractCommand 
		implements Command
	{
		protected var abstractCommandConstructorAccess : AbstractCommandConstructorAccess = new AbstractCommandConstructorAccess();
		protected var _owner : IPlugin;

		public function AbstractCommand( access : AbstractCommandConstructorAccess ) 
		{

		}

		public function execute( e : Event = null ) : void 
		{
			getLogger().error( this + ".execute() must be implemented in concrete class." );
		}

		public function getOwner() : IPlugin
		{
			return _owner;
		}
		
		public function setOwner( owner : IPlugin ) : void
		{
			_owner = owner;
		}
		
		public function getLogger() : PluginDebug
		{
			return PluginDebug.getInstance( getOwner() );
		}

		public function getModelLocator() : ModelLocator
		{
			return getOwner().getModelLocator();
		}
		
		public function getViewLocator() : ViewLocator
		{
			return getOwner().getViewLocator();
		}


		/**
		 * Returns the string representation of this instance.
		 * @return the string representation of this instance
		 */
		public function toString() : String 
		{
			return PixlibStringifier.stringify( this );
		}
		
		//
		protected function _firePrivateEvent( e : Event ) : void
		{
			getOwner().firePrivateEvent( e );
		}
	}
}

internal class AbstractCommandConstructorAccess {}