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
	import com.bourre.collection.Iterator;
	import com.bourre.error.UnimplementedVirtualMethodException;
	import com.bourre.log.PixlibDebug;
	import com.bourre.log.PixlibStringifier;
	
	import flash.events.Event;	

	/**
	 * <code>AbstractIterationCommand</code> provides a skeleton
	 * for concret <code>IterationCommand</code> implementations.
	 * <p>
	 * <code>IterationCommands</code> are not fully stateless as they
	 * provide to the <code>LoopCommand</code> which own them the iterator
	 * onto which they will work.
	 * </p><p>
	 * For informations and examples on the behavior of loop commands see the 
	 * <a href="../../../../docs/howto/howto-loopcommands.html">How to use LoopCommand
	 * and IterationCommand</a> document.
	 * </p>
	 * 
	 * @author Cédric Néhémie
	 */
	public class AbstractIterationCommand implements IterationCommand 
	{
		/**
		 * A reference to the iterator used by this command
		 */
		protected var _oIterator : Iterator;

		/**
		 * Initializes this iteration command with the passed-in 
		 * <code>Iterator</code>.
		 */
		public function AbstractIterationCommand ( i : Iterator )
		{
			_oIterator = i;
		}
		
		/**
		 * Override the <code>execute</code> virtual method
		 * to create a concret iteration command. Concret command
		 * may use the passed-in event as data source for
		 * their operation. Used with a <code>LoopCommand</code>
		 * the passed-in event is an <code>IterationEvent</code>.
		 * 
		 * @param	e	event object that will be used as data source by the command 
		 * @throws 	<code>UnimplementedVirtualMethodException</code> — Concret
		 * 			command doesn't override the <code>execute</code> method
		 */
		public function execute( e : Event = null ) : void
		{
			var msg : String = this + ".execute() must be implemented in concrete class.";
			PixlibDebug.ERROR( msg );
			throw( new UnimplementedVirtualMethodException( msg ) );
		}
		
		/**
		 * Returns the iterator composed by this command.
		 * 
		 * @return the iterator composed by this command
		 */
		public function iterator () : Iterator
		{
			return _oIterator;
		}
		
		/**
		 * Defines which iterator is composed by this command
		 * 
		 * @param	i iterator instance to be used by this command
		 */
		public function setIterator ( i : Iterator ) : void
		{
			_oIterator = i;
		}
	
		/**
		 * Returns the string representation of this object.
		 * 
		 * @return	the string representation of this object
		 */
		public function toString() : String 
		{
			return PixlibStringifier.stringify( this );
		}
	}
}
