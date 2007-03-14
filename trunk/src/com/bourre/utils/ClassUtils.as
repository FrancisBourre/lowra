package com.bourre.utils
{
	import flash.utils.describeType;
	import flash.utils.getQualifiedClassName;
	
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
	}
}