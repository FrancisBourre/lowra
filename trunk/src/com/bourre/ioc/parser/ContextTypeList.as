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
package com.bourre.ioc.parser
{
	import com.bourre.error.PrivateConstructorException;	
	
	/**
	 * Enumeration of compliant object types which can be parsed 
	 * by default IoC engine. 
	 * 
	 * @author Francis Bourre
	 */
	public class ContextTypeList
	{
		//--------------------------------------------------------------------
		// Public properties
		//--------------------------------------------------------------------
				
		public static var DEFAULT 		: String = "Default";
		public static var STRING 		: String = "String";
		public static var NUMBER 		: String = "Number";
		public static var INT 			: String = "int";
		public static var UINT 			: String = "uint";
		public static var BOOLEAN 		: String = "Boolean";
		public static var ARRAY 		: String = "Array";
		public static var OBJECT 		: String = "Object";
		public static var INSTANCE 		: String = "Instance";
		public static var SPRITE 		: String = "flash.display.Sprite";
		public static var MOVIECLIP 	: String = "flash.display.MovieClip";		public static var TEXTFIELD 	: String = "flash.text.TextField";
		public static var NULL 			: String = "null";		public static var DICTIONARY 	: String = "Dictionary";		public static var CLASS 		: String = "Class";		public static var XML 			: String = "XML";		public static var FUNCTION 		: String = "Function";
		
		
		//--------------------------------------------------------------------
		// Private implementation
		//--------------------------------------------------------------------
		
		/** @private */		
		public function ContextTypeList( access : PrivateConstructorAccess )
		{
			if ( !(access is PrivateConstructorAccess) ) throw new PrivateConstructorException();
		}
	}
}

internal class PrivateConstructorAccess{}