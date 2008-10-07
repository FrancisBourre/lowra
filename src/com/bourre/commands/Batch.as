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
	import com.bourre.plugin.Plugin;
	
	import flash.events.Event;		

	/**
	 * <code>Batch</code> object encapsulate a set of <code>Commands</code>
	 * to execute at the same time.
	 * <p>
	 * Batch is a first-in first-out stack (FIFO) where commands
	 * are executed in the order they were registered.
	 * </p><p>
	 * When an event is passed to the <code>execute</code> method
	 * it will be relayed to the sub-commands.
	 * </p>
	 * 
	 * @author 	Cédric Néhémie
	 */
	public class Batch extends AbstractCommand implements MacroCommand
	{
		/**
		 * Contains all commands currently in this macro command
		 */
		protected var _aCommands : Array;

		/**
         * Takes all elements of an Array and pass them one by one as arguments
         * to a method of an object.
         * It's exactly the same concept as batch processing in audio or video
         * software, when you choose to run the same actions on a group of files.
         * <p>
         * Basical example which sets _alpha value to .4 and scale to 50
         * on all MovieClips nested in the Array :
         * </p>
         * @example
         * <listing>
         * import com.bourre.commands.*;
         *
         * function changeAlpha( mc : MovieClip, a : Number, s : Number )
         * {
         *      mc._alpha = a;
         *      mc._xscale = mc._yscale = s;
         * }
         *
         * Batch.process( changeAlpha, [mc0, mc1, mc2], .4, 50 );
         * </listing>
         *
         * @param	f		function to run.
         * @param	a		array of parameters.
         * @param 	args	additionnal parameters to concat with the passed-in
         * 					arguments array
         */
		public static function process ( f : Function, a : Array, ...args ) : void
		{
			var l : Number = a.length;
			for( var i : int; i < l; i++ ) f.apply( null, (args.length > 0 ) ? [a[i]].concat( args ) : [a[i]] );
		}

		/**
		 * Batch object don't accept any arguments in the constructor.
		 */
		public function Batch ()
		{
			_aCommands = new Array();
		}

		/**
		 * Adds a command in the batch stack.
		 * <p>
		 * If the passed-in command have been added the
		 * function return <code>true</code>.
		 * </p><p>
		 * There is no limitation on the number of references
		 * of the same command witch the batch can contain.
		 * </p>
		 * @param 	command	a <code>Command</code> to add at the end
		 * 					of the current Batch
		 * @return 	<code>true</code> if the command could have been added,
		 * 		   	either <code>false</code>
		 */
		public function addCommand( command : Command ) : Boolean
		{
			if( command == null ) return false;
			
			if( command is AbstractCommand )
				( command as AbstractCommand).setOwner( getOwner() );
				
			var l : Number = _aCommands.length;
			return (l != _aCommands.push( command ) );
		}
		
		/**
		 * @inheritDoc
		 */
		override public function setOwner ( owner : Plugin ) : void
		{
			super.setOwner( owner );
			
			var l : Number = _aCommands.length;
			var c : AbstractCommand;
			while( --l -(-1 ) )
			{
				if( ( c = _aCommands[ l ]  as AbstractCommand ) != null )
					c.setOwner( owner );
			}
		}

		/**
		 * Removes all references to the passed-in command.
		 * <p>
		 * If the command have been found and removed
		 * from the <code>Batch</code> the function return
		 * <code>true</code>.
		 * </p> 
		 * @param	command command object to be removed
		 * @return 	<code>true</code> if the command have been 
		 * 		   	successfully removed.
		 */
		public function removeCommand( command : Command ) : Boolean
		{
			var id : Number = _aCommands.indexOf( command ); 

			if ( id == -1 ) return false;
			
			while ( ( id = _aCommands.indexOf( command ) ) != -1 )
			{
				_aCommands.splice( id, 1 );
			}
			return true;
		}

		/**
		 * Returns <code>true</code> if the passed-in command is stored
		 * in this batch.
		 * 
		 * @param	command command object to look at
		 * @return	<code>true</code> if the passed-in command is stored
		 * 		   	in the <code>Batch</code>
		 */
		public function contains ( command : Command ) : Boolean
		{
			return _aCommands.indexOf( command ) != -1;
		}

		/**
		 * Executes the whole set of commands in the order they were
		 * registered.
		 * <p>
		 * If an event is passed to the function, it will be relayed
		 * to the sub-commands <code>execute</code> method.
		 * </p>
		 * @param	e	event object to relay to the sub-commands. 
		 */
		override public function execute( e : Event = null ) : void
		{
			var l : Number = _aCommands.length;

			if( l == 0 ) return;

			for( var i : Number = 0; i<l; i++ ) 
			{
				( _aCommands[ i ] as Command ).execute( e );
			}
		}

		/**
		 * Removes all commands stored in the batch stack.
		 */
		public function removeAll () : void
		{
			_aCommands = new Array();
		}

		/**
		 * Returns the number of commands stored in this batch.
		 * 
		 * @return	the number of commands stored in this batch
		 */
		public function size () : uint
		{
			return _aCommands.length;		
		}
	}
}
