package com.bourre.ioc.parser
{
	public class ContextTypeList
	{
		
		public static var DEFAULT 	: String = "Default";
		public static var STRING 	: String = "String";
		public static var NUMBER 	: String = "Number";
		public static var INT 		: String = "Int";
		public static var UINT 		: String = "Uint";
		public static var BOOLEAN 	: String = "Boolean";
		public static var ARRAY 	: String = "Array";
		public static var OBJECT 	: String = "Object";
		public static var INSTANCE 	: String = "Instance";
		public static var NULL 		: String = "null";
		
		public function ContextTypeList( access : PrivateConstructorAccess )
		{
			//
		}
	}
}

internal class PrivateConstructorAccess{}