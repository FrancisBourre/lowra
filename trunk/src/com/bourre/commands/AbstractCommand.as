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
package com.bourre.commands
{
	import flash.events.Event;
	
	import com.bourre.error.UnimplementedVirtualMethodException;
	import com.bourre.log.*;
	import com.bourre.model.ModelLocator;
	import com.bourre.plugin.*;
	import com.bourre.view.ViewLocator;	

	/**
	 * <code>AbstractCommand</code> provides a skeleton for commands which
	 * might work within plugin's <code>FrontController</code>. Abstract command
	 * provides methods which allow the <code>FrontController</code> to set
	 * the command owner at the command creation. Additionally the 
	 * <code>AbstractCommand</code> class provides convenient method to access
	 * all MVC components and logging tools of the plugin owner.
	 * <p>
	 * LowRA encourage the creation of stateless commands, it means
	 * that commands must realize all their process entirely in
	 * the <code>execute</code> call. The constructor of a stateless
	 * command should always be empty.
	 * </p>
	 * @author	Francis Bourre
	 */
	public class AbstractCommand implements Command
	{
		/**
		 * A reference to the plugin owner of this command.
		 */
		protected var _owner : Plugin;
		
		/**
		 * Empty constructor of a stateless command
		 */
		public function AbstractCommand() {}

		/**
		 * Override the <code>execute</code> virtual method
		 * to create a concret command. Stateless command
		 * may use the passed-in event as data source for
		 * their operation.
		 * 
		 * @param	e	event object that will be used as data source by the command 
		 * @throws 	<code>UnimplementedVirtualMethodException</code> — Concret
		 * 			command doesn't override the <code>execute</code> method
		 * @throws 	<code>UnreachableDataException</code> — Stateless command
		 * 			use the passed-in event as data source for its execution,
		 * 			so the event must provide the right data for the current
		 * 			<code>Command</code> object.
		 */
		public function execute( e : Event = null ) : void 
		{
			var msg : String = this + ".execute() must be implemented in concrete class.";
			getLogger().error( msg );
			throw( new UnimplementedVirtualMethodException( msg ) );
		}

		/**
		 * Returns a reference to the owner of this command.
		 * 
		 * @return	the plugin owner of this command
		 */
		public function getOwner() : Plugin
		{
			return _owner;
		}
		
		/**
		 * Defines the plugin owner of this command.
		 * Generally the owner is defined by the
		 * <code>FrontController</code> of a plugin when
		 * it instantiate a command.
		 * 
		 * @param	owner plugin which will own the command 
		 */		
		public function setOwner( owner : Plugin ) : void
		{
			_owner = owner;
		}
		
		/**
		 * Returns the exclusive logger object owned by the plugin.
		 * It allow this command to send logging message directly on
		 * its owner logging channel.
		 * 
		 * @return	logger associated to the owner
		 */
		public function getLogger() : PluginDebug
		{
			return PluginDebug.getInstance( getOwner() );
		}

		/**
		 * Returns a reference to the owner <code>ModelLocator</code>.
		 * It allow this command to locate any model and then manipulate
		 * it as needed.
		 * 
		 * @return	a reference to the owner model locator
		 */
		public function getModelLocator() : ModelLocator
		{
			return getOwner().getModelLocator();
		}
		
		/**
		 * Returns a reference to the owner <code>ViewLocator</code>.
		 * It allow this command to locate any view and then manipulate
		 * it as needed.
		 * 
		 * @return	a reference to the owner view locator
		 */
		public function getViewLocator() : ViewLocator
		{
			return getOwner().getViewLocator();
		}

		/**
		 * Returns the string representation of this instance.
		 * 
		 * @return the string representation of this instance
		 */
		public function toString() : String 
		{
			return PixlibStringifier.stringify( this );
		}
		
		/**
		 * Fires a private event directly on this command's owner. 
		 */
		protected function _firePrivateEvent( e : Event ) : void
		{
			getOwner().firePrivateEvent( e );
		}
	}
}