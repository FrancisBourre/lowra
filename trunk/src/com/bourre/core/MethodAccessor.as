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
	import com.bourre.error.NoSuchMethodException;	
	import com.bourre.log.PixlibDebug;
	import com.bourre.log.PixlibStringifier;
	import com.bourre.error.NullPointerException;
	import com.bourre.error.ClassCastException;	

	public class MethodAccessor implements Accessor
	{
		private var _o : Object;
		
		private var _sp : String;
		private var _gp : String;
		
		private var _sf : Function;
		private var _gf : Function;
		
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
		
		public function getTarget() : Object
		{
			return _o;
		}
		
		public function getGetterHelper() : String
		{
			return _gp;
		}
		public function getSetterHelper() : String
		{
			return _sp;
		}
		
		public function toString () : String
		{
			return PixlibStringifier.stringify( this );
		}
	}
}