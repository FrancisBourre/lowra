package com.bourre.utils 
{
	import flash.utils.describeType;
	import flash.utils.getQualifiedClassName;	

	/**
	 * 
	 */
	public class ClassUtils
	{		
		/**
		 * Verify that the passed-in <code>childClass</code> is a descendant of the 
		 * specified <code>parentClass</code>.
		 * 
		 * @param childClass	class to check inheritance with the ascendant class
		 * @param parentClass	class which is the ascendant
		 */
		static public function inherit( childClass : Class, parentClass : Class) : Boolean 
		{
        	var bExtends : Boolean = describeType(childClass).factory.extendsClass.(@type == getQualifiedClassName( parentClass) ).length() > 0 ;
			var bImplements : Boolean = describeType(childClass).factory.implementsInterface.(@type == getQualifiedClassName( parentClass) ).length() > 0 ;
			
			return bExtends || bImplements ;
		}
		
		/**
		 * Use the <code>isImplemented</code> function to check if a virtual method of an abstract
		 * class is really implemented by children classes.
		 * 
		 * @param 	o	A reference to <code>this</code> in the abstract class constructor.	
		 * @param 	f	The name of the virtual method.	
		 * @return 	<code>true</code> if the method is implemented
		 * 			by the child class, either <code>false</code>
		 */
		static public function isImplemented ( o : Object, classPath : String, f : String ) : Boolean
		{
			var x : XML = describeType( o );
			var declaredBy : String = x..method.(@name == f).@declaredBy;
			return ( declaredBy != classPath);
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
	}
}