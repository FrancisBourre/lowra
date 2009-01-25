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
package com.bourre.core
{
	/**
	 * The <code>AccessorComposer</code> interface defines common
	 * rules to create abstract access to properties or methods
	 * of an object. That interface allow multi-tweens to get
	 * and set both properties and methods of an object in a
	 * transparent way. 
	 * <p>
	 * An <code>AccessorComposer</code> could access as many properties
	 * or getter/setter pair of methods as needed. <code>Accessor</code>
	 * instance are composed by a <code>AccessorComposer</code> instance
	 * according to passed-in parameters. 
	 * </p><p>
	 * In order to the accessor to get or set value with methods, an accessor
	 * must know both getter and setter methods name. If one of these information
	 * is not available, the accessor must throw an exception in order to prevent
	 * the tween to work on unavailable data.
	 * </p><p>
	 * Note : Of course, only public members of the target object could be accessed
	 * by an accessor instance.
	 * </p>
	 * 
	 * @author	Cédric Néhémie
	 * @see		Accessor
	 * @see		com.bourre.transitions.AbstractTween
	 */
	public interface AccessorComposer
	{
		/**
		 * Retreives the values from all target members acceeded
		 * by this accessor. If the type of the data stored by a
		 * member is not a number type, the call must fail with
		 * an exception.
		 * 
		 * @return	array of values stored by each properties/methods
		 * @throws 	<code>ClassCastException</code> — A property or a method
		 * 			doesn't	store a number.
		 */
		function getValue() : Array;
		
		/**
		 * Defines the new values for all targets properties and methods.
		 * If the type of the data stored by this object in one of this
		 * properties or methods is not a number, the call must fail with
		 * an exception.
		 * 
		 * @param	value	new numeric values for the target properties
		 * 					and methods
		 * @throws 	<code>ClassCastException</code> — a target properties
		 * 			or method doesn't store a number.
		 */
		function setValue( values : Array ) : void;
		
		/**
		 * Returns the target object onto which this accessor
		 * operate.
		 * 
		 * @return	the object onto which this accessor operate
		 */
		function getTarget() : Object;
		
		/**
		 * Returns the string name of all getters access used
		 * by this accessor to retreive data from its target
		 * object.
		 * 
		 * @return	the string name of all getters access used
		 * 			by this accessor
		 */
		function getGetterHelper() : Array;
		
		/**
		 * Returns the string name of all setters access used
		 * by this accessor to defines new data to its target
		 * object.
		 * 
		 * @return	the string name of all setters access used
		 * 			by this accessor
		 */
		function getSetterHelper() : Array
	}
}