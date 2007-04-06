package com.bourre.utils
{
	import com.bourre.error.IllegalArgumentException;
	import flash.display.DisplayObject;
	import flash.net.registerClassAlias;
	import flash.utils.*;
	import com.bourre.log.PixlibDebug;

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

		public static function evalFromTarget( target : Object, toEval : String ) : Object 
		{
			var a : Array = toEval.split( "." );
			var l : int = a.length;

			for ( var i : int = 0; i < l; i++ )
			{
				var p : String = a[ i ];
				if ( target.hasOwnProperty( p ) )
				{
					target = target[ p ];

				} else
				{
					PixlibDebug.ERROR( "ObjectUtils.evalFromTarget(" + target + ", " + toEval + ")" );
					return null;
				}
			}

			return target;
		}
	}
}

internal class PrivateConstructorAccess {}