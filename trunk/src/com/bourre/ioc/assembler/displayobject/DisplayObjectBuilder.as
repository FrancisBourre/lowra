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
package com.bourre.ioc.assembler.displayobject 
{
	import com.bourre.commands.Command;
	import com.bourre.events.ValueObject;
	
	import flash.display.DisplayObjectContainer;
	import flash.net.URLRequest;	

	/**
	 * All Display object builder must implement this interface.
	 * 
	 * @author Francis Bourre
	 * 
	 * @see DefaultDisplayObjectBuilder
	 */
	public interface DisplayObjectBuilder extends Command
	{
		/**
		 * Returns root target.
		 */
		function getRootTarget() : DisplayObjectContainer;
		
		/**
		 * Sets the root target for display list creation.
		 */
		function setRootTarget( target : DisplayObjectContainer ) : void;
		
		/**
		 * Retreives and returns correct url using <code>request</code> base url 
		 * and the possible <code>prefix</code> to insert.
		 * 
		 * <p>Use IoC url manager to build correct url link.<br />
		 * See documentation annexes for more informations about url engine.</p>
		 * 
		 * @return	The correct url using <code>request</code> base url 
		 * and the possible <code>prefix</code> to insert.
		 */
		function getURLRequest( request : URLRequest, prefix : String = null ) : URLRequest;
		
		/**
		 * Builds a display loader using passed-in <code>ValueObject</code> 
		 * configuration object.
		 * 
		 * @param	o	<code>ValueObject</code> containing building parameters
		 */
		function buildDisplayLoader( o : ValueObject ) : void;		
		/**
		 * Builds a DLL object using passed-in <code>ValueObject</code> 
		 * configuration object.
		 * 
		 * @param	o	<code>ValueObject</code> containing building parameters
		 */
		function buildDLL( o : ValueObject ) : void;
		
		/**
		 * Builds a Resource object using passed-in <code>ValueObject</code> 
		 * configuration object.
		 * 
		 * @param	o	<code>ValueObject</code> containing building parameters
		 */
		function buildResource( o : ValueObject ) : void;
		
		/**
		 * Builds a Display object using passed-in <code>ValueObject</code> 
		 * configuration object.
		 * 
		 * @param	o	<code>ValueObject</code> containing building parameters
		 */
		function buildDisplayObject( o : ValueObject ) : void;
		
		/**
		 * Adds the passed-in listener as listener for all events dispatched
		 * by this builder. The function returns <code>true</code>
		 * if the listener have been added at the end of the call. If the
		 * listener is already registered in this event broadcaster the function
		 * returns <code>false</code>.
		 * 
		 * @param	listener	the listener object to add as builder listener.
		 * @return	<code>true</code> if the listener have been added during this call
		 * @throws 	<code>IllegalArgumentException</code> — If the passed-in listener
		 * 			listener doesn't match the listener type supported by this event
		 * 			broadcaster
		 * @throws 	<code>IllegalArgumentException</code> — If the passed-in listener
		 * 			is a function
		 */
		function addListener( listener : DisplayObjectBuilderListener ) : Boolean;
		
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
		function removeListener( listener : DisplayObjectBuilderListener ) : Boolean;
		
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
		function addEventListener( type : String, listener : Object, ... rest ) : Boolean;
		
		/**
		 * Removes the passed-in listener for listening the specified event. The
		 * listener could be either an object or a function.
		 * 
		 * @param	type		name of the event for which unregister the listener
		 * @param	listener	object or function to be unregistered
		 * @return	<code>true</code> if the listener have been successfully removed
		 * 			as listener for the passed-in event
		 */
		function removeEventListener( type : String, listener : Object ) : Boolean;		
		/**
		 * Sets the <code>Anti cache system</code> to <code>true</code> 
		 * or <code>false</code>
		 * 
		 * @param	b	<code>true</code> to enable anticache.
		 */		function setAntiCache( b : Boolean) : void;
		
		/**
		 * Returns <code>true</code> if <code>Anti cache system</code> is 
		 * activated for loading process.
		 */
		function isAntiCache() : Boolean;
		
		/**
		 * Returns all elements queue size.
		 */
		function size() : uint;	}}