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
package com.bourre.ioc.parser 
{
	import com.bourre.collection.Iterator;
	import com.bourre.events.EventBroadcaster;
	import com.bourre.log.PixlibStringifier;	
	
	/**
	 *  Dispatched when context parsing starts.
	 *  
	 *  @eventType com.bourre.ioc.parser.ContextParserEvent.onContextParsingStartEVENT
	 */
	[Event(name="onContextParsingStart", type="com.bourre.ioc.parser.ContextParserEvent")]
	
	/**
	 *  Dispatched when context parsing is finished.
	 *  
	 *  @eventType com.bourre.ioc.parser.ContextParserEvent.onContextParsingEndEVENT
	 */
	[Event(name="onContextParsingEnd", type="com.bourre.ioc.parser.ContextParserEvent")]
	
	/**
	 * IoC Context parser.
	 * 
	 * <p>When context is loaded, this class parse content to build concrete 
	 * object using xml node definition.</p>
	 * 
	 * @author romain Ecarnot
	 */
	public class ContextParser 
	{
		//--------------------------------------------------------------------
		// Protected properties
		//--------------------------------------------------------------------
				
		protected var _oEB : EventBroadcaster;
		protected var _pc : ParserCollection;
		protected var _oContext : XML;
		
		
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
		
		/**
		 * Creates instance.
		 * 
		 * @param	pc	(optional) Parsers collection to use to parse 
		 * 				IoC context file.
		 */	
		public function ContextParser( pc : ParserCollection = null ) 
		{
			_oEB = new EventBroadcaster( this, ContextParserListener );
			_pc = pc;
		}
		
		/**
		 * Parses passed-in xml definition.
		 */
		public function parse( xml : * ) : void
		{
			_oEB.broadcastEvent( new ContextParserEvent( ContextParserEvent.onContextParsingStartEVENT, this ) );

			_oContext = XML( xml );
			var context : XML = _oContext.copy();

			var i : Iterator = _pc.iterator();
			while( i.hasNext() ) ( i.next( ) as AbstractParser ).parse( context );

			_oEB.broadcastEvent( new ContextParserEvent( ContextParserEvent.onContextParsingEndEVENT, this ) );
		}
		
		/**
		 * Adds the passed-in listener as listener for all events dispatched
		 * by this instance. The function returns <code>true</code>
		 * if the listener have been added at the end of the call. If the
		 * listener is already registered in this event broadcaster the function
		 * returns <code>false</code>.
		 * <p>
		 * Note : The <code>addListener</code> function doesn't accept functions
		 * as listener, functions could only register for a single event.
		 * </p>
		 * @param	listener	the listener object to add as global listener
		 * @return	<code>true</code> if the listener have been added during this call
		 * @throws 	<code>IllegalArgumentException</code> — If the passed-in listener
		 * 			listener doesn't match the listener type supported by this event
		 * 			broadcaster
		 * @throws 	<code>IllegalArgumentException</code> — If the passed-in listener
		 * 			is a function
		 */
		public function addListener( listener : ContextParserListener ) : Boolean
		{
			return _oEB.addListener( listener );
		}
		
		/**
		 * Removes the passed-in listener object from this event
		 * broadcaster. The object is removed as listener for all
		 * events the broadcaster may dispatch.
		 * 
		 * @param	listener	the listener object to remove from
		 * 						this event broadcaster object
		 * @return	<code>true</code> if the object have been successfully
		 * 			removed from this event broadcaster
		 * @throws 	<code>IllegalArgumentException</code> — If the passed-in listener
		 * 			is a function
		 */
		public function removeListener( listener : ContextParserListener ) : Boolean
		{
			return _oEB.removeListener( listener );
		}
		
		/**
		 * Adds an event listener for the specified event type.
		 * There is two behaviors for the <code>addEventListener</code>
		 * function : 
		 * <ol>
		 * <li>The passed-in listener is an object : 
		 * The object is added as listener only for the specified event, the object must
		 * have a function with the same name than <code>type</code> or at least a
		 * <code>handleEvent</code> function.</li>
		 * <li>The passed-in listener is a function : 
		 * A <code>Delegate</code> object is created and then
		 * added as listener for the event type. There is no restriction on the name of 
		 * the function. If the <code>rest</code> is not empty, all elements in it is 
		 * used as additional arguments into the delegate object. 
		 * </ol>
		 * 
		 * @param	type		name of the event for which register the listener
		 * @param	listener	object or function which will receive this event
		 * @param	rest		additional arguments for the function listener
		 * @return	<code>true</code> if the function have been succesfully added as
		 * 			listener fot the passed-in event
		 * @throws 	<code>UnsupportedOperationException</code> — If the listener is an object
		 * 			which have neither a function with the same name than the event type nor
		 * 			a function called <code>handleEvent</code>
		 */
		public function addEventListener( type : String, listener : Object, ... rest ) : Boolean
		{
			return _oEB.addEventListener.apply( _oEB, rest.length > 0 ? [ type, listener ].concat( rest ) : [ type, listener ] );
		}
		
		/**
		 * Removes the passed-in listener for listening the specified event. The
		 * listener could be either an object or a function.
		 * 
		 * @param	type		name of the event for which unregister the listener
		 * @param	listener	object or function to be unregistered
		 * @return	<code>true</code> if the listener have been successfully removed
		 * 			as listener for the passed-in event
		 */
		public function removeEventListener( type : String, listener : Object ) : Boolean
		{
			return _oEB.removeEventListener( type, listener );
		}
		
		/**
		 * Returns string representation.
		 */
		public function toString() : String
		{
			return PixlibStringifier.stringify( this );
		}
	}
}