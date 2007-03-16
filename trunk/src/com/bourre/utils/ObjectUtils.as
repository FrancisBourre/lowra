package com.bourre.utils
{
	import com.bourre.error.IllegalArgumentException;
	import flash.display.DisplayObject;
	import flash.net.registerClassAlias;
	import flash.utils.*;

	public class ObjectUtils
	{
		public function ObjectUtils( access : PrivateConstructorAccess )
		{
			
		}
		
		public static function clone( source : Object ) : Object 
		{
			if ( source is DisplayObject ) throw new IllegalArgumentException( "" );
			
			var qualifiedClassName : String = getQualifiedClassName( source );
			var aliasName : String = qualifiedClassName.split( "::" )[1];
        	if ( aliasName ) registerClassAlias( aliasName, (getDefinitionByName( qualifiedClassName ) as Class) );
			var ba : ByteArray = new ByteArray();
			ba.writeObject( source );
			ba.position = 0;
			return( ba.readObject() );
		}
	}
}

internal class PrivateConstructorAccess {}