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
	import com.bourre.error.NoSuchFieldException;
	import com.bourre.error.NoSuchMethodException;
	import com.bourre.error.NullPointerException;
	import com.bourre.log.PixlibDebug;	

	/**
	 * A factory for <code>Accessor</code> and <code>AccessorComposer</code> creation.
	 * With the <code>AccessorFactory</code>, you don't have to know if you attempt to
	 * access to a property or to a method. The <i>creational</i> methods of the factory
	 * will return the corresponding concret accessor.
	 * 
	 * @author	Cédric Néhémie
	 * @see		Accessor
	 * @see		AccessorComposer
	 */
	public class AccessorFactory 
	{		
		/**
		 * Returns an accessor object for the passed-in property or methods of the
		 * specified target object. The concret type of the accessor cannot be
		 * known before the call, as for any other factories.
		 * <p>
		 * In the case of accessing to method member, the <code>setter</code> and 
		 * <code>getter</code> arguments must be set.
		 * </p>
		 * @param	t		the object onto which access member(s)
		 * @param	setter	name of the setter property on the target
		 * @param	getter	name of the getter property on the target, used
		 * 					only if the setter property is a function
		 * @return	a concret <code>Accessor</code> to the specified member(s)
		 * @throws 	<code>NullPointerException</code> — The passed-in target is
		 * 			<code>null</code>
		 * @throws 	<code>NoSuchFieldException</code> — The target object doesn't
		 * 			own any field named as <i>setter</i>
		 * @throws 	<code>NoSuchMethodException</code> — There'is no <i>getter</i>
		 * 			method to associate with the corresponding <i>setter</i>
		 */
		static public function getAccessor( t : Object , setter : String, getter : String = null ) : Accessor
		{
			var msg : String;
			
			if( !t )
			{
				msg = t + " isn't a valid target for an accessor.";
				PixlibDebug.ERROR( msg );
				throw new NullPointerException( msg );
			}
				
			if( !t.hasOwnProperty( setter ) )
			{
				msg = t + " doesn't own any properties named " + setter;
				PixlibDebug.ERROR( msg );
				throw new NoSuchFieldException( msg );
			}
			else if( t[ setter ] is Function )
			{
				if( !t.hasOwnProperty( getter ) )
				{
					msg = t + " doesn't own any getter method named " + getter;
					PixlibDebug.ERROR( msg );
					throw new NoSuchMethodException( msg );
				}
				return new MethodAccessor ( t, setter, getter );
			}
			else
			{
				return new PropertyAccessor ( t, setter );
			}	
		}
		
		/**
		 * Returns an accessor object for the passed-in properties or methods of the
		 * specified target object. The concret type of the accessor cannot be
		 * known before the call, as for any other factories.
		 * <p>
		 * In the case of accessing to method member, the <code>setter</code> and 
		 * <code>getter</code> arguments must be set.
		 * </p>
		 * @param	t		the object onto which access member(s)
		 * @param	setter	array of setter member's name
		 * @param	getter	array of getter member's name, when mixing properties
		 * 					and methods, the same order must be conservated in the
		 * 					two arrays
		 * @return	a concret <code>AccessorComposer</code> to the specified member(s)
		 * @throws 	<code>NullPointerException</code> — The passed-in target is
		 * 			<code>null</code>
		 * @throws 	<code>NoSuchFieldException</code> — The target object doesn't
		 * 			own any field named as <i>setter</i>
		 * @throws 	<code>NoSuchMethodException</code> — There'is no <i>getter</i>
		 * 			method to associate with the corresponding <i>setter</i>
		 * @example	The orders of the parameters must be equivalent both in the setter
		 * array and in the getter array. When mixing properties and methods, the
		 * getter name of a properties is <code>null</code>, as the properties may generally
		 * provides read and write access to it.
		 * <listing>AccessorFactory.getMultiAccessor ( 
		 * 			anObject,
		 * 			[ "someProperty", "getSomething", "getAnotherThing" ],
		 * 			[ null, 		  "setSomething", "setAnotherThing" ]
		 * );</listing>
		 */
		static public function getMultiAccessor ( t : Object, setter : Array, getter : Array = null) : AccessorComposer
		{
			if( !t )
			{
				var msg : String = t + " isn't a valid target for an accessor."; 
				PixlibDebug.ERROR( msg );
				throw new NullPointerException( msg );
			}
			return new MultiAccessor ( t, setter, getter );
		}
	}
}