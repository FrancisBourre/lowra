package com.bourre.core 
{
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

	/**
	 * @author Francis Bourre
	 * @version 1.0
	 */
	import flash.utils.Dictionary;
	import flash.utils.describeType;
	import flash.utils.getQualifiedClassName;

	import com.bourre.collection.HashMap;
	import com.bourre.collection.TypedContainer;
	import com.bourre.error.IllegalArgumentException;
	import com.bourre.error.NoSuchElementException;
	import com.bourre.log.PixlibDebug;
	import com.bourre.log.PixlibStringifier;	

	public class TypedFactoryLocator 
		implements Locator, TypedContainer
	{
		protected var _m : HashMap;
		protected var _cType : Class;

		public function TypedFactoryLocator( type : Class )
		{
			_cType = type;
			_m = new HashMap() ;
		}

		public function  locate ( key : String ) : Object
		{
			if ( isRegistered(key) )
			{
				return _m.get( key ) ;

			} else
			{
				var msg : String = this + ".locate(" + key + ") fails." ;
				PixlibDebug.ERROR( msg ) ;
				throw( new NoSuchElementException( msg ) ) ;
			}
		}

		public function isRegistered( key : String ) : Boolean
		{
			return _m.containsKey( key ) ;
		}

		public function register ( key : String, clazz : Class ) : Boolean
		{
			var msg : String;

			if ( !( isRegistered( key ) ) )
			{
				if ( classExtends( clazz ) )
				{
					_m.put( key, clazz );
					return true;

				} else
				{
					msg = this+".register(" + key + ") fails, '" + clazz + "' class doesn't extend '" + _cType + "' class.";
					PixlibDebug.ERROR( msg ) ;
					throw( new IllegalArgumentException( msg ) );
					return false ;
				}

			} else
			{
				msg = this+".register(" + key + ") fails, key is already registered." ;
				PixlibDebug.ERROR( msg ) ;
				throw( new IllegalArgumentException( msg ) );
				return false ;
			}
		}

		public function toString() : String 
		{
			var parameter : String = getType().toString();
			parameter = "<" + parameter.substr( 7, parameter.length - 8 ) + ">";
			return PixlibStringifier.stringify( this ) + parameter;
		}

		public function classExtends( extendedClass : Class ) : Boolean 
		{
        	return describeType( extendedClass ).factory.extendsClass.(@type==getQualifiedClassName( this._cType )).length() > 0;
		}

		public function add( d : Dictionary ) : void
		{
			for ( var key : * in d ) 
			{
				try
				{
					register( key, d[ key ] as Class );

				} catch( e : IllegalArgumentException )
				{
					e.message = this + ".add() fails. " + e.message;
					PixlibDebug.ERROR( e.message );
					throw( e );
				}
			}
		}

		public function build( key : String ) : Object
		{
			var clazz : Class = locate( key ) as Class;
			return new clazz( );
		}

		public function matchType( o : * ) : Boolean
		{
			return o is _cType;
		}

		public function getType() : Class
		{
			return _cType;
		}

		public function isTyped() : Boolean
		{
			return true;
		}
	}
}
