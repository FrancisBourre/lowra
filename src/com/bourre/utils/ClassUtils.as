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
package com.bourre.utils 
{
	import com.bourre.error.PrivateConstructorException;		import flash.utils.describeType;	import flash.utils.getQualifiedClassName;	
	/**
	 * Set of class utilities functions.
	 * 
	 * @author	Cédric Néhémie
	 */
	public class ClassUtils
	{		
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
				
		/**
		 * Verify that the passed-in <code>childClass</code> is a descendant of the 
		 * specified <code>parentClass</code>.
		 * 
		 * @param childClass	class to check inheritance with the ascendant class
		 * @param parentClass	class which is the ascendant
		 */
		static public function inherit( childClass : Class, parentClass : Class) : Boolean 
		{
			var xml : XML = describeType(childClass);
			var parent : String = getQualifiedClassName(parentClass);
			return 	(xml.factory.extendsClass.@type).contains( parent ) || (xml.factory.implementsInterface.@type).contains( parent );
		}
		
		/**
		 * Use the <code>isImplemented</code> function to check if a virtual method of an abstract
		 * class is really implemented by children classes.
		 * 
		 * @param 	o	A reference to <code>this</code> in the abstract class constructor.	
		 * @param 	f	The name of the virtual method.	
		 * @return 	<code>true</code> if the method is implemented
		 * 			by the child class, either <code>false</code>
		 * @example A concret example in the class <code>AbstractTween</code> : 
		 * if( !ClassUtils.isImplementedAll( this, "com.bourre.transitions::AbstractTween", "isMotionFinished", "isReversedMotionFinished" ) )
		 * {
		 *	PixlibDebug.ERROR ( this + " have to implements virtual methods : isMotionFinished & isReversedMotionFinished " );
		 * 	throw new UnimplementedVirtualMethodException ( this + " have to implements virtual methods : isMotionFinished & isReversedMotionFinished" );
		 * {}
		 */
		static public function isImplemented ( o : Object, classPath : String, f : String ) : Boolean
		{
			var x : XML = describeType( o );
			var declaredBy : String = x..method.(@name == f).@declaredBy;
			return ( declaredBy != classPath );
		}
		
		/**
		 * Check in one time if a set of function is implemented by the subclasses.
		 * 
		 * @param 	o	A reference to <code>this</code> in the abstract class constructor.	
		 * @param 	c	A <code>Collection</code> object witch contains a list of function
		 * 				names to verify.	
		 * @return 	<code>true</code> if all the methods are implemented
		 * 			by the child class, either <code>false</code>. When
		 * 			only one method isn't implemented then the function 
		 * 			failed and return immediatly.
		 * @see		#isImplemented()
		 */
		static public function isImplementedAll ( o : Object, classPath : String, ... rest ) : Boolean
		{
			var i : Number = rest.length-1;
			var x : XML = describeType( o );
			while ( --i -(-1) )
			{
				var declaredBy : String = x..method.(@name == rest[ i ] ).@declaredBy;
				if( declaredBy == classPath ) return false;
			}
			return true;
		} 
		
		
		//--------------------------------------------------------------------
		// Private implementation
		//--------------------------------------------------------------------
		
		/** @private */
		function ClassUtils( access : ConstructorAccess ) 
		{
			if ( !(access is ConstructorAccess) ) throw new PrivateConstructorException();
		}
	}
}

internal class ConstructorAccess {}