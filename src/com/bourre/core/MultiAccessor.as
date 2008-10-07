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
	import com.bourre.log.PixlibStringifier;			

	/**
	 * The <code>MultiAccessor</code> provides read and write access 
	 * to the specified methods and properties of a single object. 
	 * 
	 * @author 	Cédric Néhémie
	 */
	public class MultiAccessor implements AccessorComposer
	{
		private var _o : Object;
		private var _aGet : Array;
		private var _aSet : Array;
		private var _a : Array;
		
		/**
		 * Creates a new <code>MethodAccessor</code> instance which
		 * allow access to the specified <code>getter</code> and
		 * <code>setter</code> methods of the passed-in object.
		 * 
		 * @param	o		object onto which access methods
		 * @param	setters	names of the setter methods or properties on the object
		 * @param	getters	names of the getter methods on the object, use only
		 * 					for function members
		 * @throws 	<code>NullPointerException</code> — Can't create an accessors
		 * 			on a null object
		 * @throws 	<code>NoSuchMethodException</code> — There is no setter method
		 * 			of the specified name
		 * @throws 	<code>NoSuchMethodException</code> — There is no getter method
		 * 			of the specified name
		 */
		public function MultiAccessor ( t : Object, setters : Array, getters : Array = null ) 
		{
			_a = new Array();
			_o = t;
			_aSet = setters;
			_aGet = getters;
			
			var l : Number = setters.length;
			var isMultiTarget : Boolean = t is Array;
			
			for ( var i : Number = 0; i < l; i++ ) 
			{
				_a.push( AccessorFactory.getAccessor( isMultiTarget ? _o[ i ] : _o , _aSet[ i ], _aGet != null ? _aGet[ i ] : null ) );
			}
		}
	
		/**
		 * Returns an array of all values returned by the specified
		 * properties and methods of the object.
		 * 
		 * @return	current values returned by the target getter methods
		 * @throws 	<code>ClassCastException</code> — A getter method
		 * 			doesn't return a number.
		 */
		public function getValue():Array
		{
			var l : Number = _a.length;
			var a : Array = new Array();
			while ( --l -(-1) ) a[ l ] = ( _a[ l ] as Accessor ).getValue();
			return a;
		}
		
		/**
		 * Sets the new values for the properties and methods handled
		 * by the specified setter methods and properties defined
		 * during the creation of this instance.
		 * 
		 * @param	value	the new values for the target setter methods
		 * 					and properties
		 * @throws 	<code>ClassCastException</code> — A target setter 
		 * 			methods doesn't accept number as argument.
		 */
		public function setValue( values : Array ) : void
		{
			var l : Number = _a.length;
			while ( --l -(-1) ) ( _a[ l ] as Accessor ).setValue( values[ l ] );
		}
		
		/**
		 * @inheritDoc
		 */
		public function getTarget() : Object
		{
			return _o;
		}
		
		/**
		 * @inheritDoc
		 */
		public function getGetterHelper():Array
		{
			return _aGet;
		}
		
		/**
		 * @inheritDoc
		 */
		public function getSetterHelper():Array
		{
			return _aSet;
		}
		
		/**
		 * Returns the string representation of this object.
		 * 
		 * @return	the string representation of this object
		 */
		public function toString () : String
		{
			return PixlibStringifier.stringify( this );
		}
	}
}