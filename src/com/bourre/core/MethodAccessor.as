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
	import com.bourre.error.NoSuchMethodException;
	import com.bourre.error.NullPointerException;
	import com.bourre.log.PixlibDebug;
	import com.bourre.log.PixlibStringifier;	

	/**
	 * The <code>MethodAccessor</code> provides read and write access 
	 * to the specified method of an object. 
	 * 
	 * @author 	Cédric Néhémie
	 */
	public class MethodAccessor implements Accessor
	{
		private var _o : Object;
		private var _sp : String;
		private var _gp : String;
		private var _sf : Function;
		private var _gf : Function;
		
		/**
		 * Creates a new <code>MethodAccessor</code> instance which
		 * allow access to the specified <code>getter</code> and
		 * <code>setter</code> methods of the passed-in object.
		 * 
		 * @param	o		object onto which access methods
		 * @param	setter	name of the setter method on the object
		 * @param	getter	name of the getter method on the object
		 * @throws 	<code>NullPointerException</code> — Can't create an accessor
		 * 			on a null object		 * @throws 	<code>NoSuchMethodException</code> — There is no setter method
		 * 			of the specified name		 * @throws 	<code>NoSuchMethodException</code> — There is no getter method
		 * 			of the specified name
		 */
		public function MethodAccessor ( o : Object, setter : String, getter : String  )
		{
			var msg : String;
			if( o == null )
			{
				msg = "Can't create an accessor on a null object";
				PixlibDebug.ERROR( msg );
				throw new NullPointerException ( msg );
			}
			else if( !o.hasOwnProperty( setter ) ) 
			{
				msg = o + " doesn't own any setter method called '" + setter + "'";
				PixlibDebug.ERROR( msg );
				throw new NoSuchMethodException( msg );

			}
			else if( !o.hasOwnProperty( getter ) ) 
			{
				msg = o + " doesn't own any getter method called '" + getter + "'";
				PixlibDebug.ERROR( msg );
				throw new NoSuchMethodException( msg );
			}	
			_o = o;
			
			_sp = setter;
			_gp = getter;
			
			_sf = _o[ _sp ];
			_gf = _o[ _gp ];
		}
		
		/**
		 * Returns the numeric value returned by the getter method specified
		 * during the creation of the object.
		 * 
		 * @return	current value returned by the target getter method
		 * @throws 	<code>ClassCastException</code> — The target getter 
		 * 			method doesn't return a number.
		 */
		public function getValue():Number
		{
			var n : Number = _gf();
			
			if( isNaN ( n ) ) 
			{
				var msg : String =  _o + "." + _gp + "() doesn't return a number";
				PixlibDebug.ERROR( msg );				
				throw new ClassCastException ( msg );
			}
			
			return n;
		}	
		
		/**
		 * Sets the new value for the property handled by the
		 * specified setter method defined during the creation
		 * of this instance.
		 * 
		 * @param	value	the new value for the target setter method
		 * @throws 	<code>ClassCastException</code> — The target setter 
		 * 			method doesn't accept number as argument.
		 */
		public function setValue( value : Number ) : void
		{
			try
			{
				_sf( value );
			}
			catch ( e : Error )
			{
				var msg : String =  _o + "." + _sp + "() doesn't accept a number as argument";
				PixlibDebug.ERROR( msg );
				
				throw new ClassCastException ( msg );
			}
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
			return _gp;
		}
		
		/**
		 * @inheritDoc
		 */
		public function getSetterHelper() : String
		{
			return _sp;
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