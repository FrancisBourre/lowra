package com.bourre.utils
{
	import flash.utils.describeType;
	import flash.utils.getQualifiedClassName;
	import com.bourre.collection.Collection;
	import com.bourre.collection.Iterator;
	
	public class ClassUtils
	{
		/**
		 * Use the <code>isImplemented</code> function to check if a virtual method of an abstract
		 * class is really implemented by children classes.
		 * 
		 * @param 	o	A reference to <code>this</code> in the abstract class constructor.	
		 * @param 	f	The name of the virtual method.	
		 * @return 	<code>true</code> if the method is implemented
		 * 			by the child class, either <code>false</code>
		 */
		public static function isImplemented ( o : Object, f : String ) : Boolean
		{
			var x : XML = describeType( o );
			var declaredBy : String = x..method.(@name == f).@declaredBy;
			return ( declaredBy == getQualifiedClassName( o ) );
			
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
		public static function isImplementedAll ( o : Object, c : Collection ) : Boolean
		{
			var i : Iterator = c.iterator();
			
			while ( i.hasNext() )
			{
				if( !isImplemented ( o, i.next() ) )
					return false;
			}
			return true;
		} 
	}
}