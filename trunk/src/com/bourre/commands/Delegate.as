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
	import com.bourre.log.PixlibStringifier;
	import com.bourre.transitions.TickListener;
	
	import flash.events.Event;	

	/**
	 * The Delegate encapsulate a method call as an object. 
	 * The Delegate class provides two ways to encapsulate a method call :
	 * <ul>
	 * <li>By creating a new Delegate instance you can wrap the call into
	 * a command object.</li>	 * <li>By calling the <code>Delegate.create</code> method you can get
	 * an anonymous function which will encapsulate the call.</li>
	 * </ul>
	 * 
	 * @author	Francis Bourre
	 */
	public class Delegate 
		implements Command, TickListener
	{
		/**
		 * The method closure wrapped by this delegate
		 */
		protected var _f : Function;
		/**
		 * Array of arguments to pass to the function
		 */
		protected var _a : Array;
		/**
		 * Indicates whether the event object passed to the execute
		 * method is appended to the function arguments or not.
		 */
		protected var _bHasEventCallback : Boolean;

		/**
		 * Creates a anonymous function which will wrap the call
		 * to the passed-in function with the passed-in <code>rest</code>
		 * as arguments to the function.
		 * 
		 * @param	method	specified method to encapsulate
		 * @param	args	additionall arguments to pass to pass 
		 * 					to the method
		 * @return	an anonymous function which will wrap the call
		 * 			to the passed-in function 
		 */
		public static function create( method : Function, ... args ) : Function 
		{
			return function( ... rest ) : *
			{
				return method.apply( null, rest.length>0? (args.length>0?rest.concat(args):rest) : (args.length>0?args:null) );
			};
		}

		/**
		 * Creates a new Delegate instance which encapsulate the call
		 * to the passed-in function with the passed-in <code>rest</code>
		 * as arguments to the function.
		 * 
		 * @param	f		specified method to encapsulate
		 * @param	rest	additionall arguments to pass to pass 
		 * 					to the method
		 */
		public function Delegate( f : Function, ... rest )
		{
			_f = f;
			_a = rest;
			_bHasEventCallback = true;
		}

		/**
		 * If <code>true</code> the event passed to the execute
		 * function will not be appended to the function arguments.
		 * 
		 * @param b	<code>true</code> to bypass the event to be
		 * 			appended to the function arguments
		 */
		public function bypassEventCallback( b : Boolean ) : void
		{
			_bHasEventCallback = !b;
		}

		/**
		 * Returns the current array of arguments which will be
		 * passed to the function when called.
		 * 
		 * @return 	array of arguments which will be
		 * 			passed to the function
		 */
		public function getArguments() : Array
		{
			return _a;
		}

		/**
		 * Defines the arguments to pass to the function
		 * 
		 * @param	rest	arguments to pass to the function
		 */
		public function setArguments( ... rest ) : void
		{
			if ( rest.length > 0 ) _a = rest;
		}

		/**
		 * Defines the arguments to pass to the function
		 * 
		 * @param	a	array of arguments to pass to the function
		 */
		public function setArgumentsArray( a : Array ) : void
		{
			if ( a.length > 0 ) _a = a;
		}

		/**
		 * Appends arguments to the current function's arguments.
		 * 
		 * @param	rest	arguments to append to the function's
		 * 					arguments
		 */
		public function addArguments( ... rest ) : void
		{
			if ( rest.length > 0 ) _a = _a.concat( rest );
		}

		/**
		 * Appends arguments to the current function's arguments.
		 * 
		 * @param	a	array of arguments to append to the function's
		 * 				arguments
		 */
		public function addArgumentsArray( a : Array ) : void
		{
			if ( a.length > 0 ) _a = _a.concat( a );
		}

		/**
		 * Realizes the function call with the arguments defined
		 * in this Delegate object.
		 * <p>
		 * The receive event will be append to the arguments array
		 * except if the <code>bypassEvenCallback</code> have been
		 * called with <code>true</code> as argument.
		 * </p>
		 * @param	event	event object to append to the arguments
		 * 					array
		 */
		public function execute( event : Event = null ) : void
		{
			var a : Array = event != null && _bHasEventCallback ? [event] : [];
			_f.apply( null, ( _a.length > 0 ) ? a.concat( _a ) : ((a.length > 0 ) ? a : null) );
		}

		/**
		 * @inheritDoc
		 */
		public function onTick( e : Event = null ) : void
		{
			execute( e );
		}

		/**
		 * Allow the delegate object to be added as listener
		 * for any event type on any object which provide the
		 * <code>addEventListener</code>.
		 * 
		 * @param	e	event object dispatched with the event
		 */
		public function handleEvent( e : Event ) : void
		{
			this.execute( e );
		}

		/**
		 * Calls the function with the current array of arguments.
		 */
		public function callFunction() : *
		{
			return _f.apply( null, _a );
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
	}
}