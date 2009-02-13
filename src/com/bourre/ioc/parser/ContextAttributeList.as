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
	import com.bourre.error.PrivateConstructorException;			/**
	 * Enumeration of possible attribute name in the xml context.
	 * 
	 * @author Francis Bourre
	 */
	public class ContextAttributeList
	{
		//--------------------------------------------------------------------
		// Constants
		//--------------------------------------------------------------------

		public static const ID : 							String = "id";
		public static const TYPE : 							String = "type";
		public static const NAME : 							String = "name";
		public static const REF : 							String = "ref";
		public static const VALUE : 						String = "value";
		public static const FACTORY : 						String = "factory";
		public static const URL : 							String = "url";
		public static const VISIBLE : 						String = "visible";
		public static const SINGLETON_ACCESS : 				String = "singleton-access";
		public static const METHOD : 						String = "method";
		public static const ROOT_REF : 						String = "root-ref";
		
		public static const START_CALLBACK : 				String = "start-callback";
		public static const NAME_CALLBACK : 				String = "name-callback";
		public static const LOAD_CALLBACK : 				String = "load-callback";		public static const PROGRESS_CALLBACK : 			String = "progress-callback";
		public static const TIMEOUT_CALLBACK : 				String = "timeout-callback";			public static const ERROR_CALLBACK : 				String = "error-callback";	
		public static const INIT_CALLBACK : 				String = "init-callback";	
		public static const PARSED_CALLBACK : 				String = "parsed-callback";			public static const OBJECTS_BUILT_CALLBACK : 		String = "objects-built-callback";			public static const CHANNELS_ASSIGNED_CALLBACK :	String = "channels-assigned-callback";	
		public static const METHODS_CALL_CALLBACK : 		String = "methods-call-callback";			public static const COMPLETE_CALLBACK : 			String = "complete-callback";	

		public static const DELAY : 						String = "delay";		public static const DESERIALIZER_CLASS : 			String = "deserializer-class";

		
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
		
		/** @private */
		public function ContextAttributeList( access : PrivateConstructorAccess )
		{
			if ( !(access is PrivateConstructorAccess) ) throw new PrivateConstructorException();
		}

		/**
		 * Returns <code>ID</code> attibute value.
		 */
		public static function getID( xml : XML ) : String
		{
			return xml.attribute( ContextAttributeList.ID );
		}

		/**
		 * Returns <code>type</code> attibute value.
		 */
		public static function getType( xml : XML ) : String
		{
			var type : String = xml.attribute( ContextAttributeList.TYPE );
			return type ? type : ContextTypeList.STRING;
		}

		/**
		 * Returns <code>type</code> attibute value for display object.
		 */
		public static function getDisplayType( xml : XML ) : String
		{
			var type : String = xml.attribute( ContextAttributeList.TYPE );
			return type ? type : ContextTypeList.SPRITE;
		}

		/**
		 * Returns <code>name</code> attibute value.
		 */
		public static function getName( xml : XML ) : String
		{
			return xml.attribute( ContextAttributeList.NAME );
		}

		/**
		 * Returns <code>ref</code> attibute value.
		 */
		public static function getRef( xml : XML ) : String
		{
			return xml.attribute( ContextAttributeList.REF );
		}

		/**
		 * Returns <code>value</code> attibute value.
		 */
		public static function getValue( xml : XML ) : String
		{
			return xml.attribute( ContextAttributeList.VALUE ) || null;
		}

		/**
		 * Returns <code>url</code> attibute value.
		 */
		public static function getURL( xml : XML ) : String
		{
			return xml.attribute( ContextAttributeList.URL );
		}

		/**
		 * Returns <code>visible</code> attibute value.
		 */
		public static function getVisible( xml : XML ) : String
		{
			return xml.attribute( ContextAttributeList.VISIBLE );
		}

		/**
		 * Returns <code>factory</code> attibute value.
		 */
		public static function getFactoryMethod( xml : XML ) : String
		{
			return xml.attribute( ContextAttributeList.FACTORY ) || null;
		}

		/**
		 * Returns <code>singleton-access</code> attibute value.
		 */
		public static function getSingletonAccess( xml : XML ) : String
		{
			return xml.attribute( ContextAttributeList.SINGLETON_ACCESS ) || null;
		}

		/**
		 * Returns <code>method</code> attibute value.
		 */
		public static function getMethod( xml : XML ) : String
		{
			return xml.attribute( ContextAttributeList.METHOD );
		}
		
		/**
		 * Returns <code>root-ref</code> attibute value.
		 */
		public static function getRootRef( xml : XML ) : String
		{
			return xml.attribute( ContextAttributeList.ROOT_REF );
		}
		
		/**
		 * Returns <code>start-callback</code> attibute value.
		 */
		public static function getStartCallback( xml : XML ) : String
		{
			return xml.attribute( ContextAttributeList.START_CALLBACK );
		}

		/**
		 * Returns <code>name-callback</code> attibute value.
		 */
		public static function getNameCallback( xml : XML ) : String
		{
			return xml.attribute( ContextAttributeList.NAME_CALLBACK );
		}

		/**
		 * Returns <code>load-callback</code> attibute value.
		 */
		public static function getLoadCallback( xml : XML ) : String
		{
			return xml.attribute( ContextAttributeList.LOAD_CALLBACK );
		}

		/**
		 * Returns <code>progress-callback</code> attibute value.
		 */
		public static function getProgressCallback( xml : XML ) : String
		{
			return xml.attribute( ContextAttributeList.PROGRESS_CALLBACK );
		}

		/**
		 * Returns <code>timeout-callback</code> attibute value.
		 */
		public static function getTimeoutCallback( xml : XML ) : String
		{
			return xml.attribute( ContextAttributeList.TIMEOUT_CALLBACK );
		}

		/**
		 * Returns <code>error-callback</code> attibute value.
		 */
		public static function getErrorCallback( xml : XML ) : String
		{
			return xml.attribute( ContextAttributeList.ERROR_CALLBACK );
		}

		/**
		 * Returns <code>init-callback</code> attibute value.
		 */
		public static function getInitCallback( xml : XML ) : String
		{
			return xml.attribute( ContextAttributeList.INIT_CALLBACK );
		}

		/**
		 * Returns <code>parsed-callback</code> attibute value.
		 */
		public static function getParsedCallback( xml : XML ) : String
		{
			return xml.attribute( ContextAttributeList.PARSED_CALLBACK );
		}

		/**
		 * Returns <code>objects-built-callback</code> attibute value.
		 */
		public static function getObjectsBuiltCallback( xml : XML ) : String
		{
			return xml.attribute( ContextAttributeList.OBJECTS_BUILT_CALLBACK );
		}

		/**
		 * Returns <code>channels-assigned-callback</code> attibute value.
		 */
		public static function getChannelsAssignedCallback( xml : XML ) : String
		{
			return xml.attribute( ContextAttributeList.CHANNELS_ASSIGNED_CALLBACK );
		}

		/**
		 * Returns <code>methods-call-callback</code> attibute value.
		 */
		public static function getMethodsCallCallback( xml : XML ) : String
		{
			return xml.attribute( ContextAttributeList.METHODS_CALL_CALLBACK );
		}

		/**
		 * Returns <code>complete-callback</code> attibute value.
		 */
		public static function getCompleteCallback( xml : XML ) : String
		{
			return xml.attribute( ContextAttributeList.COMPLETE_CALLBACK );
		}

		/**
		 * Returns <code>delay</code> attibute value.
		 */
		public static function getDelay( xml : XML ) : String
		{
			return xml.attribute( ContextAttributeList.DELAY );
		}

		/**
		 * Returns <code>deserializer-class</code> attibute value.
		 */
		public static function getDeserializerClass( xml : XML ) : String
		{
			return xml.attribute( ContextAttributeList.DESERIALIZER_CLASS ) || null;
		}		
	}
}

internal class PrivateConstructorAccess
{
}