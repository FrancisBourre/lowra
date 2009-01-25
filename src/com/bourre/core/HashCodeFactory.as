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
	import flash.utils.Dictionary;	

	/**
	 * The <code>HashCodeFactory</code> class provides convenient methods
	 * to emulate the behavior of the Java&trade; <code>Object.hashcode()</code>
	 * method. The hashcode factory provides an unique identifier for any
	 * instance in an application.
	 * <p>
	 * However, there is a major difference between the Java&trade; behavior
	 * and the Flash&trade; behavior. In Java&trade; the hashcode method
	 * will return the same value for two different instance of the same
	 * class which have the same properties value, in Flash&trade; the 
	 * hashcode factory will return a different identifier for all instances
	 * even if their properties are equals.
	 * </p>
	 * 
	 * @author Francis Bourre
	 */
	public class HashCodeFactory
	{
		
		static private var _nKEY : Number = 0;
		
		/**
		 * A hash map which store the generated keys for each object for which
		 * an identifier was generated. Objects are stored as weak reference
		 * so they will be collected as any other object which has no hashcode
		 * identifier.
		 */
		static protected const _oHashTable : Dictionary = new Dictionary( true );
		
		/**
		 * Returns the hashcode key associated to the passed-in object.
		 * If the objects has not yet a hashcode, the function will generate
		 * one and then register the object with its hashcode.
		 * 
		 * @param	o	object for which get the hashcode key
		 * @return	the string hashcode for the passed-in object
		 */
		static public function getKey ( o : * ) : String
		{
			if( !hasKey ( o ) )
				_oHashTable[ o ] = getNextKey ();
			
			return _oHashTable[ o ] as String;
		}
		
		/**
		 * Returns <code>true</code> if the passed-in object already
		 * have a hashcode key.
		 * 
		 * @param	o	object for which verify the presence of a hashcode key	
		 * @return	<code>true</code> if the passed-in object already
		 * 			have a hashcode key
		 */
		static public function hasKey ( o : * ) : Boolean
		{
			return _oHashTable[ o ] != null;
		}
		
		/**
		 * Returns the next unique identifier, two consecutives
		 * call to the <code>getNextKey</code> will generate two
		 * different keys. To get the next key without changing 
		 * the next call result use the <code>previewNextKey</code>
		 * method.
		 * 
		 * @return	the next unique identifier
		 * @see		#previewNextKey()
		 */
		static public function getNextKey () : String
		{
			return "KEY" + _nKEY++;
		}
		
		/**
		 * Returns the next key the <code>getNextKey</code>
		 * will return, without causing the <code>getNextKey</code>
		 * method returning a different key. Calling several times
		 * the <code>previewNextKey</code> method will never affect
		 * the next call of the <code>getNextKey</code> method.
		 * 
		 * @return	a preview of the next unique identifier
		 */
		static public function previewNextKey () : String
		{
			return "KEY" + _nKEY;
		}
	}
}