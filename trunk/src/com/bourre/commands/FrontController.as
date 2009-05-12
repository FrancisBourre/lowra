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
package com.bourre.commands {
	import com.bourre.core.AbstractLocator;
	import com.bourre.error.IllegalArgumentException;
	import com.bourre.error.NoSuchElementException;
	import com.bourre.events.EventBroadcaster;
	import com.bourre.plugin.NullPlugin;
	import com.bourre.plugin.Plugin;
	import com.bourre.plugin.PluginDebug;
	import com.bourre.utils.ClassUtils;

	import flash.events.Event;
	import flash.utils.Dictionary;

	/**
	 * A base class for an application specific front controller,
	 * that is able to dispatch control following particular events
	 * to appropriate command classes.
	 * <p>
	 * The Front Controller is the centralised request handling class in a
	 * LowRA plugin or application. It could be used with or without the
	 * plugin architecture or LowRA. By default all classes which will extend
	 * the <code>AbstractPlugin</code> will own an instance of the
	 * <code>FrontController</code> class.
	 * </p><p>
	 * The role of the Front Controller is to first register all the different
	 * events that it is capable of handling against worker classes, called
	 * command classes.  On hearing an application event, the Front Controller
	 * will look up its table of registered events, find the appropriate
	 * command for handling of the event, before dispatching control to the
	 * command by calling its execute() method.
	 * </p><p>
	 * When used inside a plugin the Front Controller is automatically registered
	 * as a listener of a private event broadcaster created especially for this
	 * plugin. In that way it will receive all private events dispatched in all
	 * plugin's MVC components. 
	 * </p><p>
	 * See the <a href="../../../howto/howto-commands.html">How to use
	 * the Command pattern implementations in LowRA</a> document for more details
	 * on the commands package structure.
	 * </p>
	 * 
	 * @author Francis Bourre
	 */
	public class FrontController 
		extends AbstractLocator
		implements ASyncCommandListener
	{
		/**
		 * A reference to the plugin owner of this front controller. When used 
		 * outside of the plugin architecture, this property store a reference
		 * to the global instance of the <code>NullPlugin</code> class.
		 */
		protected var _owner : Plugin;

		private var _oASyncCommands : Dictionary;

		/**
		 * Creates a new Front Controller instance for the passed-in
		 * plugin. If the plugin argument is omitted, the Front Controller
		 * is owned by the global instance of the <code>NullPlugin</code
		 * class.
		 * 
		 * @param	owner	plugin object which own the controller
		 */
		public function FrontController( owner : Plugin = null ) 
		{
			_owner = ( owner == null ) ? NullPlugin.getInstance() : owner;
			if ( owner == null ) EventBroadcaster.getInstance().addListener( this );

			super( Command, null, PluginDebug.getInstance( getOwner() ) );

			_oASyncCommands = new Dictionary();
		}

		/**
		 * Returns the owner plugin of this controller
		 * 
		 * @return 	the owner plugin of this controller
		 */
		final public function getOwner() : Plugin
		{
			return _owner;
		}

		/**
		 * @inheritDoc
		 */
		override public function register( eventName : String, o : Object ) : Boolean
		{
			try
			{
				if ( o is Class )
				{
					return pushCommandClass( eventName, o as Class );

				} else
				{
					return pushCommandInstance( eventName, o as Command );
				}

			} catch( e : Error )
			{
				getLogger().fatal( e.message );
				throw e;
			}
			
			return false;
		}

		/**
		 * Registers the passed-in command class to be triggered at each time
		 * the controller will receive an event of type <code>eventName</code>.
		 * <p>
		 * The passed-in command class must at least implement the <code>Command</code>
		 * interface. If the class doesn't inherit from <code>Command</code> the
		 * association failed and an exception is throw.
		 * </p><p>
		 * If there is already a command or a class associated with the passed-in event,
		 * the association failed and an exception is throw.
		 * </p>
		 * @param	eventName	 name of the event type with which the command
		 * 						 will be registered
		 * @param	commandClass class to associate with the passed-in event type
		 * @return	<code>true</code> if the command class have been succesfully	
		 * 			registered with the passed-in event type 
		 * @throws 	<code>IllegalArgumentException</code> — There is already
		 * 			a command or class registered with the specified key. 			
		 * @throws 	<code>IllegalArgumentException</code> — The passed-in command 
		 * 			class doesn't inherit from Command interface.
		 */
		public function pushCommandClass( eventName : String, commandClass : Class ) : Boolean
		{
			var key : String = eventName.toString();
			var msg : String;

			if ( isRegistered( key ) )
			{
				msg = "There is already a command class registered with '" + key + "' name in " + this;
				getLogger().fatal( msg );
				throw new IllegalArgumentException( msg );

			} else if( !ClassUtils.inherit( commandClass, Command ) )
			{
				msg = "The class '" + commandClass + "' doesn't inherit from Command interface in " + this;
				getLogger().fatal( msg );
				throw new IllegalArgumentException( msg );

			} else
			{
				_m.put( key, commandClass );
				return true;
			}
		}

		/**
		 * Registers the passed-in command to be triggered at each time
		 * the controller will receive an event of type <code>eventName</code>.
		 * <p>
		 * If there is already a class or a command associated with the passed-in
		 * event, the association failed and an exception is throw.
		 * </p>
		 * @param	eventName	name of the event type with which the command
		 * 						will be registered
		 * @param	command		command to associate with the passed-in event type
		 * @return	<code>true</code> if the command have been succesfully	
		 * 			registered with the passed-in event type 
		 * @throws 	<code>IllegalArgumentException</code> — There is already
		 * 			a command or class registered with the specified key. 			
		 * @throws 	<code>NullPointerException</code> — The passed-in command 
		 * 			is null
		 */
		public function pushCommandInstance( eventName : String, command : Command ) : Boolean
		{
			var key : String = eventName.toString();
			var msg : String;
			
			if ( isRegistered( key ) )
			{
				msg = "There is already a command class registered with '" + key + "' name in " + this;
				getLogger().fatal( msg );
				throw new IllegalArgumentException( msg );

			} else if( command == null )
			{
				msg = "The passed-in command is null in " + this;
				getLogger().fatal( msg );
				throw new IllegalArgumentException( msg );

			} else
			{
				_m.put( key, command );
				return true;
			}
		}

		/**
		 * Removes the class or the command registered with the
		 * passed-in event name.
		 * 
		 * @param	eventName event name for which unregister
		 * 			associated command or class
		 */
		public function remove( eventName : String ) : void
		{
			_m.remove( eventName.toString() );
		}

		/**
		 * Handles all events received by this object.
		 * For each received event the controller will look up
		 * its registered events table, if a command or
		 * a class is registered the controller proceed.
		 * <p>
		 * If the command object is an asynchronous command
		 * the instance is stored in a specific map in order
		 * to keep a reference to that command during all its
		 * execution, and prevent it to be collected by the
		 * garbage collector. The front controller will
		 * automatically remove the reference when it receive
		 * the <code>onCommandEnd</code> event from the command.
		 * </p>
		 * 
		 * @param	event event object dispatched by the
		 * 			source object
		 */
		final public function handleEvent( event : Event ) : void
		{
			var type : String = event.type.toString();
			var cmd : Command;

			try
			{
				cmd = locate( type ) as Command;

			} catch ( e : Error )
			{
				getLogger().debug( this + ".handleEvent() fails to retrieve command associated with '" + type + "' event type." );
			}

			if ( cmd != null )
			{
				if ( cmd is ASyncCommand )
				{
					_oASyncCommands[ cmd ] = true;
					( cmd as ASyncCommand ).addASyncCommandListener( this );
				}

				cmd.execute( event );
			}
		}

		/**
		 * Catch callback events from asynchronous commands thiggered
		 * by this front controller. When the controller receive an event
		 * from the command, that command is removed from the controller
		 * storage.
		 * 
		 * @param	e	event object propagated by the command
		 */
		public function onCommandEnd (e : Event) : void
		{
			delete _oASyncCommands[ e.target ];
		}

		/**
		 * Returns the command located at the specified <code>key</code>
		 * index. If there's no command registered with the passed-in key
		 * the function fail and throw an error.
		 * <p>
		 * The <code>locate</code> method will always return a <code>Command</code>
		 * instance, even if it was a class which was registered with this key.
		 * The <code>locate</code> will instanciate the command and then return it.
		 * </p> 
		 * @throws 	<code>NoSuchElementException</code> — There is no command
		 * 			registered with the passed-in key
		 */
		override public function locate( key : String ) : Object
		{
			var o : Object;

			if ( isRegistered( key ) ) 
			{
				o = _m.get( key );

			} else
			{
				var msg : String = "Can't find Command instance with '" + key + "' name in " + this;
				getLogger().fatal( msg );
				throw new NoSuchElementException( msg );
			}

			if ( o is Class )
			{
				var cmd : Command = new ( o as Class )();
				if ( cmd is AbstractCommand ) ( cmd as AbstractCommand ).setOwner( getOwner() );
				return cmd;

			} else if ( o is Command )
			{
				if ( o is AbstractCommand ) 
				{
					var acmd : AbstractCommand = ( o as AbstractCommand );
					if ( acmd.getOwner() == null ) acmd.setOwner( getOwner() );
				}

				return o;
			}

			return null;
		}

		/**
		 * Adds all key/commands associations within the passed-in
		 * <code>Dictionnary</code> in the current front controller.
		 * The errors thrown by the <code>pushCommandClass</code> and
		 * <code>pushCommandInstance</code> are also thrown in the
		 * <code>add</code> method.
		 * 
		 * @param	d	a dictionary object used to fill ths controller
		 * @throws 	<code>IllegalArgumentException</code> — There is already
		 * 			a command or class registered with a key in the dictionary. 
		 * @throws 	<code>IllegalArgumentException</code> — A command class
		 * 			in the dictionary doesn't inherit from Command interface.			
		 * @throws 	<code>NullPointerException</code> — A command in the
		 * 			dictionary is null
		 */
		override public function add( d : Dictionary ) : void
		{
			for ( var key : * in d ) 
			{
				try
				{
					var o : Object = d[ key ] as Object;

					if ( o is Class )
					{
						pushCommandClass( key, o as Class );

					} else
					{
						pushCommandInstance( key, o as Command );
					}

				} catch( e : Error )
				{
					e.message = this + ".add() fails. " + e.message;
					getLogger().error( e.message );
					throw( e );
				}
			}
		}
		
		override public function release() : void
		{
			super.release();
			_owner = null ;
		}
		
		/**
		 * Returns the string representation of this instance.
		 * @return the string representation of this instance
		 */
		override public function toString () : String
		{
			return super.toString() + ( _owner != null ? " of " + _owner : "" );
		}
	}
}