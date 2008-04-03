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
	import com.bourre.collection.HashMap;
	import com.bourre.log.PixlibStringifier;	

	public class ContextNodeNameList
	{
		private static var _oI 					: ContextNodeNameList;

		public static var BEANS 				: String = "beans";
		public static var PROPERTY 				: String = "property";
		public static var ARGUMENT 				: String = "argument";
		public static var ROOT 					: String = "root";
		public static var APPLICATION_LOADER 	: String = "application-loader";
		public static var DLL 					: String = "dll";
		public static var METHOD_CALL 			: String = "method-call";
		public static var LISTEN 				: String = "listen";
		public static var ITEM 					: String = "item";		public static var KEY 					: String = "key";		public static var VALUE 				: String = "value";		public static var INCLUDE 				: String = "include";
		public static var EVENT 				: String = "event";

		private var _mNodeName : HashMap;

		public static function getInstance() : ContextNodeNameList
		{
			if ( !(ContextNodeNameList._oI is ContextNodeNameList) ) ContextNodeNameList._oI = new ContextNodeNameList( new PrivateConstructorAccess() );
			return ContextNodeNameList._oI;
		}

		public function ContextNodeNameList( access : PrivateConstructorAccess )
		{
			init();
		}

		public function init() : void
		{
			_mNodeName = new HashMap();

			addNodeName( ContextNodeNameList.BEANS, "" );
			addNodeName( ContextNodeNameList.PROPERTY, "" );
			addNodeName( ContextNodeNameList.ARGUMENT, "" );
			addNodeName( ContextNodeNameList.ROOT, "" );
			addNodeName( ContextNodeNameList.APPLICATION_LOADER, "" );
			addNodeName( ContextNodeNameList.METHOD_CALL, "" );
			addNodeName( ContextNodeNameList.LISTEN, "" );
			addNodeName( "attribute", "" );
		}

		public function addNodeName( nodeName : String, value:* ) : void
		{
			_mNodeName.put( nodeName, value );
		}

		public function nodeNameIsReserved( nodeName:* ) : Boolean
		{
			return _mNodeName.containsKey( nodeName );
		}

		/**
		* Returns the string representation of this instance.
		* @return the string representation of this instance
		*/
		public function toString() : String 
		{
			return PixlibStringifier.stringify( this );
		}
	}
}
internal class PrivateConstructorAccess {}