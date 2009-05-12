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
package com.bourre.core {
	import com.bourre.error.IllegalArgumentException;
	import com.bourre.log.PixlibDebug;
	import com.bourre.utils.ClassUtils;

	/**
	 * The TypedFactoryLocator locator allow to store Class resource.
	 * 
	 * @example
	 * <pre class="prettyprint">
	 * 
	 * var locator : TypedFactoryLocator = new TypedFactoryLocator( Plugin );
	 * locator.register( "abstract", AbstractPlugin ); //return true
	 * locator.register( "custom", MyPlugin ); //return true
	 * locator.register( "sprite", Sprite ); //throw IllegalArgumentException and return false
	 * </pre>
	 * 
	 * @author 	Francis Bourre
	 */
	public class TypedFactoryLocator extends AbstractLocator
	{
		/**
		 * Creates new <code>TypedFactoryLocator</code> instance.
		 * 
		 * @param	type	Class type to store in this locator.
		 */
		public function TypedFactoryLocator( type : Class )
		{
			super( type );
		}
		
		/**
		 * Registers passed-in object with identifier name to this locator.
		 * 
		 * <p>As this locator is <i>typed</i>, object to store must 
		 * extends ( or implements for interface case ), the class type of 
		 * this locator.</p>
		 * 
		 * @example
		 * <pre class="prettyprint">
		 * 
		 * var locator : TypedFactoryLocator = new TypedFactoryLocator( Plugin );
		 * locator.register( "abstract", AbstractPlugin ); //return true
		 * locator.register( "custom", MyPlugin ); //return true
		 * locator.register( "sprite", Sprite ); //throw IllegalArgumentException and return false
		 * </pre>
		 * 
		 * @param	name	Key identifier
		 * @param	o		Object to store
		 * 
		 * @return 	<code>true</code> if success
		 * 			
		 * @throws 	<code>IllegalArgumentException</code> — Key or object 
		 * 			are already defined in this locator.
		 */
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
					msg = this+".register(" + key + ") fails, '" + clazz + "' class doesn't extend '" + getType() + "' class.";
					getLogger().error( msg ) ;
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
		
		/**
		 * Builds and returns new instance using Class registered 
		 * with passed-in key in locator.
		 * 
		 * @param	key	Class registration identifier
		 * 
		 * @return	A new instance of registered Class
		 * 
		 * @throws 	<code>NoSuchElementException</code> — There is no Class 
		 * 			associated with the passed-in key
		 */
		public function build( key : String ) : Object
		{
			var clazz : Class = locate( key ) as Class;
			return new clazz( );
		}
	}
}
