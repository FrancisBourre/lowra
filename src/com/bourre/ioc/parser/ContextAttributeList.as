package com.bourre.ioc.parser
{
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

	/**
	 * @author Francis Bourre
	 * @version 1.0
	 */

	public class ContextAttributeList
	{
		public static const ID 								: String = "id";
		public static const TYPE 							: String = "type";
		public static const NAME 							: String = "name";
		public static const REF 							: String = "ref";
		public static const VALUE 							: String = "value";
		public static const FACTORY 						: String = "factory";
		public static const URL 							: String = "url";
		public static const VISIBLE 						: String = "visible";
		public static const SINGLETON_ACCESS 				: String = "singleton-access";
		public static const METHOD 							: String = "method";
		public static const PROGRESS_CALLBACK				: String = "progress-callback";
		public static const NAME_CALLBACK 					: String = "name-callback";
		public static const TIMEOUT_CALLBACK 				: String = "timeout-callback";	
		public static const PARSED_CALLBACK 				: String = "parsed-callback";			public static const OBJECTS_BUILT_CALLBACK 			: String = "objects-built-callback";			public static const METHODS_CALL_CALLBACK 			: String = "methods-call-callback";			public static const CHANNELS_ASSIGNED_CALLBACK 		: String = "channels-assigned-callback";	
		public static const INIT_CALLBACK 					: String = "init-callback";	
		public static const DELAY 							: String = "delay";		public static const DESERIALIZER_CLASS 				: String = "deserializer-class";

		public function ContextAttributeList( access : PrivateConstructorAccess )
		{
			//
		}

		public static function getID( xml : XML ) : String
		{
			return xml.attribute( ContextAttributeList.ID );
		}

		public static function getType( xml : XML ) : String
		{
			var type : String = xml.attribute( ContextAttributeList.TYPE );
			return type ? type : ContextTypeList.STRING;
		}

		public static function getDisplayType( xml : XML ) : String
		{
			var type : String = xml.attribute( ContextAttributeList.TYPE );
			return type ? type : ContextTypeList.SPRITE;
		}

		public static function getName( xml : XML ) : String
		{
			return xml.attribute( ContextAttributeList.NAME );
		}

		public static function getRef( xml : XML ) : String
		{
			return xml.attribute( ContextAttributeList.REF );
		}

		public static function getValue( xml : XML ) : String
		{
			return xml.attribute( ContextAttributeList.VALUE ) || null;
		}

		public static function getURL( xml : XML ) : String
		{
			return xml.attribute( ContextAttributeList.URL );
		}

		public static function getVisible( xml : XML ) : String
		{
			return xml.attribute( ContextAttributeList.VISIBLE );
		}

		public static function getFactoryMethod( xml : XML ) : String
		{
			return xml.attribute( ContextAttributeList.FACTORY ) || null;
		}

		public static function getSingletonAccess( xml : XML ) : String
		{
			return xml.attribute( ContextAttributeList.SINGLETON_ACCESS ) || null;
		}

		public static function getMethod( xml : XML ) : String
		{
			return xml.attribute( ContextAttributeList.METHOD );
		}

		public static function getProgressCallback( xml : XML ) : String
		{
			return xml.attribute( ContextAttributeList.PROGRESS_CALLBACK );
		}

		public static function getNameCallback( xml : XML ) : String
		{
			return xml.attribute( ContextAttributeList.NAME_CALLBACK );
		}

		public static function getTimeoutCallback( xml : XML ) : String
		{
			return xml.attribute( ContextAttributeList.TIMEOUT_CALLBACK );
		}

		public static function getParsedCallback( xml : XML ) : String
		{
			return xml.attribute( ContextAttributeList.PARSED_CALLBACK );
		}

		public static function getObjectsBuiltCallback( xml : XML ) : String
		{
			return xml.attribute( ContextAttributeList.OBJECTS_BUILT_CALLBACK );
		}

		public static function getMethodsCallCallback( xml : XML ) : String
		{
			return xml.attribute( ContextAttributeList.METHODS_CALL_CALLBACK );
		}

		public static function getChannelsAssignedCallback( xml : XML ) : String
		{
			return xml.attribute( ContextAttributeList.CHANNELS_ASSIGNED_CALLBACK );
		}

		public static function getInitCallback( xml : XML ) : String
		{
			return xml.attribute( ContextAttributeList.INIT_CALLBACK );
		}

		public static function getDelay( xml : XML ) : String
		{
			return xml.attribute( ContextAttributeList.DELAY );
		}

		public static function getDeserializerClass( xml : XML ) : String
		{
			return xml.attribute( ContextAttributeList.DESERIALIZER_CLASS ) || null;
		}		
	}
}

internal class PrivateConstructorAccess{}