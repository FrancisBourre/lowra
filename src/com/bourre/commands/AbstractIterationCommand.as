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
	import flash.events.Event;
	
	import com.bourre.collection.Iterator;
	import com.bourre.commands.AbstractCommand;	

	/**
	 * @author Cédric Néhémie
	 */
	public class AbstractIterationCommand extends AbstractCommand implements IterationCommand 
	{
		protected var _oIterator : Iterator;

		public function AbstractIterationCommand ( i : Iterator )
		{
			super( );
			
			_oIterator = i;
		}
		
		override public function execute( e : Event = null ) : void
		{
		}
		
		public function abort () : void
		{
		}
		
		public function iterator () : Iterator
		{
			return _oIterator;
		}
		
		public function setIterator ( i : Iterator ) : void
		{
			_oIterator = i;
		}
		
		public function cancel () : void
		{
		}
		
		public function isCancelled () : Boolean
		{
			return false;
		}
		
		public function run () : void
		{
		}
		
		public function isRunning () : Boolean
		{
			return false;
		}
	}
}
