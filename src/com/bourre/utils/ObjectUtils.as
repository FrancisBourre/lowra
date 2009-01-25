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
	import com.bourre.error.IllegalArgumentException;
	import com.bourre.error.NoSuchElementException;
	import com.bourre.error.PrivateConstructorException;
	import com.bourre.log.PixlibDebug;
	
	import flash.display.DisplayObject;
	import flash.net.registerClassAlias;
	import flash.utils.ByteArray;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;	

	/**
	 * Set of object utilities functions.
	 * 
	 * @author	Francis Bourre	 * @author	Cédric Néhémie
	 */
	public class ObjectUtils
	{
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------

		/**
		 * Clone the content of an array
		 * 
		 * @param   a	The array to clone
		 * @return  a   new array cloned
		 */
		public static function clone ( source : Object ) : Object 
		{
			if(source === null) return null ;
			if ( source is DisplayObject ) throw new IllegalArgumentException( "" );
			if ( source.hasOwnProperty( "clone" ) && source.clone is Function) return source.clone();
			if ( source is Array) return ObjectUtils.cloneArray(source as Array) ;

			var qualifiedClassName : String = getQualifiedClassName( source );
			var aliasName : String = qualifiedClassName.split( "::" )[1];
        	if ( aliasName ) registerClassAlias( aliasName, (getDefinitionByName( qualifiedClassName ) as Class) );
			var ba : ByteArray = new ByteArray();
			ba.writeObject( source );
			ba.position = 0;
			return( ba.readObject() );
		}
		
		 /**
		 * Clone the content of an array
		 * 
		 * @param   a	The array to clone
		 * @return  a   new array cloned
		 */
		public static function cloneArray( a : Array ) : Array
		{
			var newArray : Array = new Array() ;
			for each( var o : Object in a)
			{
				if(o is Array)
					newArray.push( ObjectUtils.cloneArray(o as Array) ) ;
				else
				{
					if(o.hasOwnProperty( "clone" ) && o.clone is Function)
						newArray.push( o.clone() ) ;
					else
						newArray.push( ObjectUtils.clone(o) ) ;
				}
			}
			
			return newArray ;
		}

		 /**
		 * <p>Permit to access value like in as2</p>
		 * 
		 * <b>sample:</b>
		 * <p>
		 * var btnLaunch : DisplayObject = evalFromTarget( this , "mcHeader.btnLaunch") as DisplayObject;
		 * </p>
		 * 
		 * @param   target the root path of the first element write in the string <p>in the example mcHeader is a child of this</p>
		 * @param   toEval the path of the element to retrieve
		 * @return  null if object not find , else the object pointed by <b>toEval</b>
		 */
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
					var msg : String = "ObjectUtils.evalFromTarget(" + target + ", " + toEval + ") failed.";
					PixlibDebug.ERROR( msg );
					throw new NoSuchElementException( msg );
				}
			}

			return target;
		}
		
		//--------------------------------------------------------------------
		// Private implementation
		//--------------------------------------------------------------------
		
		/** @private */		
		function ObjectUtils( access : ConstructorAccess )
		{
			if ( !(access is ConstructorAccess) ) throw new PrivateConstructorException();
		}
	}
}

internal class ConstructorAccess {}