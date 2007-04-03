package com.bourre.ioc.parser
{
	public class ContextAttributeList
	{
	
		private static var ID 					: String = "id";
		private static var TYPE 				: String = "type";
		private static var NAME 				: String = "name";
		private static var REF 					: String = "ref";
		private static var VALUE 				: String = "value";
		private static var FACTORY 				: String = "factory";
		private static var URL 					: String = "url";
		private static var DEPTH 				: String = "depth";
		private static var VISIBLE 				: String = "visible";
		private static var SINGLETON_ACCESS 	: String = "singleton-access";
		private static var METHOD 				: String = "method";
		private static var PROGRESS_CALLBACK	: String = "progress-callback";
		private static var NAME_CALLBACK 		: String = "name-callback";
		private static var TIMEOUT_CALLBACK 	: String = "timeout-callback";	
		private static var BUILT_CALLBACK 		: String = "built-callback";	
		private static var INIT_CALLBACK 		: String = "init-callback";	
		private static var CHANNEL 				: String = "channel";
		private static var DELAY 				: String = "delay";
		
		public function ContextAttributeList()
		{
			//
		}

		public static function getID( nodeAttribute : Object ) : String
		{
			return nodeAttribute[ ContextAttributeList.ID ];
		}
		
		public static function getType( nodeAttribute : Object ) : String
		{
			return nodeAttribute[ ContextAttributeList.TYPE ];
		}
		
		public static function getName( nodeAttribute : Object ) : String
		{
			return nodeAttribute[ ContextAttributeList.NAME ];
		}
		
		public static function getRef( nodeAttribute : Object ) : String
		{
			return nodeAttribute[ ContextAttributeList.REF ];
		}
		
		public static function getValue( nodeAttribute : Object ) : String
		{
			return nodeAttribute[ ContextAttributeList.VALUE ];
		}
		
		public static function getFactoryMethod( nodeAttribute : Object ) : String
		{
			return nodeAttribute[ ContextAttributeList.FACTORY ];
		}
		
		public static function getURL( nodeAttribute : Object ) : String
		{
			return nodeAttribute[ ContextAttributeList.URL ];
		}
		
		public static function getDepth( nodeAttribute : Object ) : String
		{
			return nodeAttribute[ ContextAttributeList.DEPTH ];
		}
		
		public static function getVisible( nodeAttribute : Object ) : String
		{
			return nodeAttribute[ ContextAttributeList.VISIBLE ];
		}
		
		public static function getSingletonAccess( nodeAttribute : Object ) : String
		{
			return nodeAttribute[ ContextAttributeList.SINGLETON_ACCESS ];
		}
		
		public static function getMethod( nodeAttribute : Object ) : String
		{
			return nodeAttribute[ ContextAttributeList.METHOD ];
		}
		
		public static function getProgressCallback( nodeAttribute : Object ) : String
		{
			return nodeAttribute[ ContextAttributeList.PROGRESS_CALLBACK ];
		}
		
		public static function getNameCallback( nodeAttribute : Object ) : String
		{
			return nodeAttribute[ ContextAttributeList.NAME_CALLBACK ];
		}
		
		public static function getTimeoutCallback( nodeAttribute : Object ) : String
		{
			return nodeAttribute[ ContextAttributeList.TIMEOUT_CALLBACK ];
		}
		
		public static function getBuiltCallback( nodeAttribute : Object ) : String
		{
			return nodeAttribute[ ContextAttributeList.BUILT_CALLBACK ];
		}
		
		public static function getInitCallback( nodeAttribute : Object ) : String
		{
			return nodeAttribute[ ContextAttributeList.INIT_CALLBACK ];
		}
		
		public static function getChannel( nodeAttribute : Object ) : String
		{
			return nodeAttribute[ ContextAttributeList.CHANNEL ];
		}
		
		public static function getDelay( nodeAttribute : Object ) : String
		{
			return nodeAttribute[ ContextAttributeList.DELAY ];
		}		
	}
}