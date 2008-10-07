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
	import com.bourre.error.ClassCastException;
	import com.bourre.error.NoSuchFieldException;
	import com.bourre.error.NullPointerException;
	import com.bourre.log.PixlibDebug;
	import com.bourre.log.PixlibStringifier;		

	/**
	 * The <code>PropertyAccessor</code> provides read and write access 
	 * to the specified property of an object. 
	 * 
	 * @author 	Cédric Néhémie
	 */
	public class PropertyAccessor implements Accessor
	{
		private var _o : Object;
		private var _p : String;
		
		/**
		 * Creates a new <code>PropertyAccessor</code> instance which
		 * allow access to the specified property of the passed-in object.
		 * 
		 * @param	o	object onto which access methods
		 * @param	p	name of the property of the object
		 * @throws 	<code>NullPointerException</code> — Can't create an accessor
		 * 			on a null object
		 * @throws 	<code>NoSuchFieldException</code> — There is no property
		 * 			of the specified name
		 */
		public function PropertyAccessor ( o : Object, p : String )
		{
			var msg : String;
			if( o == null )
			{
				msg = "Can't create an accessor on a null object";
				PixlibDebug.ERROR( msg );
				throw new NullPointerException ( msg );
			}
			else if( !o.hasOwnProperty( p ) ) 
			{
				msg = o + " doesn't own any property called '" + p + "'";
				PixlibDebug.ERROR( msg );
				throw new NoSuchFieldException ( msg );
			}
					
			_o = o;
			_p = p;
		}
		
		/**
		 * Returns the numeric value stored in the property specified
		 * during the creation of the object.
		 * 
		 * @return	current value stored in the target property
		 * @throws 	<code>ClassCastException</code> — The target property
		 * 			doesn't store a number.
		 */
		public function getValue():Number
		{
			if( !(_o[ _p ] is Number) ) 
			{
				var msg : String =  _o + "." + _p + " doesn't store a number";
				PixlibDebug.ERROR( msg );
				throw new ClassCastException ( msg );
			}
				
			return _o[ _p ];
		}	
		
		/**
		 * Sets the new value for the property handled by this
		 * accessor defined during the creation of this instance.
		 * 
		 * @param	value	the new value for the target property
		 * @throws 	<code>ClassCastException</code> — The target property
		 * 			doesn't store a number.
		 */
		public function setValue( value : Number ) : void
		{
			if( !(_o[ _p ] is Number) ) 
			{
				var msg : String =  _o + "." + _p + " doesn't store a number";
				PixlibDebug.ERROR( msg );
				throw new ClassCastException ( msg );
			}
			
			_o[ _p ] = value ;
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
		public function getGetterHelper() : String
		{
			return _p;
		}
		/**
		 * @inheritDoc
		 */
		public function getSetterHelper() : String
		{
			return _p;
		}
		/**
		 * Returns the property's name onto which this accessor
		 * operate.
		 * 
		 * @return	the property's name onto which this accessor
		 * 			operate
		 */		
		public function getProperty() : String
		{
			return _p;
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