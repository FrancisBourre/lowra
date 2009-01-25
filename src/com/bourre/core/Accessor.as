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
package  com.bourre.core
{ 
	/**
	 * The <code>Accessor</code> interface defines common rules
	 * to create abstract access to properties or methods of an 
	 * object. That interface allow tweens to get and set both
	 * properties and methods of an object in a transparent way. 
	 * <p>
	 * An <code>Accessor</code> could access to only one property or
	 * getter/setter pair of methods for an object. To access many
	 * properties/methods in one time see the <code>AccessorComposer</code>
	 * interface.
	 * </p><p>
	 * In order to the accessor to get or set value with methods, an accessor
	 * must know both getter and setter methods name. If one of these information
	 * is not available, the accessor must throw an exception in order to prevent
	 * the tween to work on unavailable data.	 * </p><p>
	 * There isn't any method to dynamically bind an accessor to a new property or
	 * a new getter/setter pair of method. You have to create a new accessor if you
	 * need to change the property you want to access.	 * </p><p>
	 * Note : Of course, only public members of the target object could be accessed
	 * by an accessor instance.
	 * </p>
	 * 
	 * @author	Cédric Néhémie
	 * @see		AccessorComposer
	 * @see		com.bourre.transitions.AbstractTween
	 */
	public interface Accessor 
	{
		/**
		 * Retreives the value from the target property.
		 * If the type of the data stored by this object is not
		 * a number type, the call must fail with an exception.
		 * 
		 * @return	current value stored in the target property
		 * @throws 	<code>ClassCastException</code> — The target property
		 * 			doesn't	store a number.
		 */
		function getValue () : Number;
		
		/**
		 * Defines the new value for the target property.
		 * If the type of the data stored by this object is not
		 * a number type, the call must fail with an exception.
		 * 
		 * @param	value	new numeric value for the target property
		 * @throws 	<code>ClassCastException</code> — The target property
		 * 			doesn't	store a number.
		 */
		function setValue( value : Number ) : void;
	
		/**
		 * Returns the target object onto which this accessor
		 * operate.
		 * 
		 * @return	the object onto which this accessor operate
		 */
		function getTarget() : Object;
		
		/**
		 * Returns the string name of the getter access used
		 * by this accessor to retreive data from its target
		 * object.
		 * 
		 * @return	the string name of the getter access used
		 * 			by this accessor
		 */
		function getGetterHelper() : String;
		
		/**
		 * Returns the string name of the setter access used
		 * by this accessor to defines new data to its target
		 * object.
		 * 
		 * @return	the string name of the setter access used
		 * 			by this accessor
		 */
		function getSetterHelper() : String
	}
}