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
	import com.bourre.collection.HashMap;
	import com.bourre.error.IllegalArgumentException;
	import com.bourre.log.PixlibDebug;
	import com.bourre.utils.ClassUtils;	

	public class TypedFactoryLocator 
		extends AbstractLocator
	{
		public function TypedFactoryLocator( type : Class )
		{
			super( type );
		}

		override public function register ( key : String, o : Object ) : Boolean
		{
			var msg : String;

			if ( !( o is Class ) )
			{
				msg = this + ".register(" + key + ") fails, '" + o + "' value isn't a Class." ;
				PixlibDebug.ERROR( msg ) ;
				throw( new IllegalArgumentException( msg ) );
			}

			var clazz : Class = o as Class;

			if ( !( isRegistered( key ) ) )
			{
				if ( ClassUtils.inherit( clazz, getType() ))
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

		public function build( key : String ) : Object
		{
			var clazz : Class = locate( key ) as Class;
			return new clazz( );
		}
	}
}
