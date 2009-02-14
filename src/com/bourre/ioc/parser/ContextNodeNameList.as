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
	import com.bourre.collection.HashMap;
	import com.bourre.error.PrivateConstructorException;
	import com.bourre.log.PixlibStringifier;	

	/**
	 * Enumeration of nodes name compliant with Lowra context assembler.
	 * 
	 * @author Francis Bourre
	 */
	public class ContextNodeNameList
	{
		//--------------------------------------------------------------------
		// Constants
		//--------------------------------------------------------------------

		public static var BEANS : String = "beans";
		public static var PROPERTY : String = "property";
		public static var ARGUMENT : String = "argument";
		public static var ROOT : String = "root";
		public static var APPLICATION_LOADER : String = "application-loader";
		public static var DLL : String = "dll";		public static var RSC : String = "rsc";
		public static var METHOD_CALL : String = "method-call";
		public static var LISTEN : String = "listen";
		public static var ITEM : String = "item";		public static var KEY : String = "key";		public static var VALUE : String = "value";		public static var INCLUDE : String = "include";
		public static var EVENT : String = "event";
		public static var PREPROCESSOR : String = "preprocessor";
		
		
		//--------------------------------------------------------------------
		// Private properties
		//--------------------------------------------------------------------

		private static var _oI : ContextNodeNameList;		
		private var _mNodeName : HashMap;

		
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
		
		/**
		 * Returns unique <code>ContextNodeNameList</code> instance.
		 */	
		public static function getInstance() : ContextNodeNameList
		{
			if ( !(ContextNodeNameList._oI is ContextNodeNameList) ) ContextNodeNameList._oI = new ContextNodeNameList( new PrivateConstructorAccess( ) );
			return ContextNodeNameList._oI;
		}

		/**
		 * Initializes node hashmap with default values.
		 */
		public function init() : void
		{
			_mNodeName = new HashMap( );

			addNodeName( ContextNodeNameList.BEANS, "" );
			addNodeName( ContextNodeNameList.PROPERTY, "" );
			addNodeName( ContextNodeNameList.ARGUMENT, "" );
			addNodeName( ContextNodeNameList.ROOT, "" );
			addNodeName( ContextNodeNameList.APPLICATION_LOADER, "" );
			addNodeName( ContextNodeNameList.METHOD_CALL, "" );
			addNodeName( ContextNodeNameList.LISTEN, "" );
			addNodeName( "attribute", "" );
		}

		/**
		 * Adds a new node name with associated value.
		 * 
		 * @param	nodeName	Node name to add.
		 * @param	value		Value associated with new node name.
		 */
		public function addNodeName( nodeName : String, value : * ) : void
		{
			_mNodeName.put( nodeName, value );
		}

		/**
		 * Returns <code>true</code> if passed-in <code>nodeName</code> 
		 * is a protected node name (eq already defined in list ).
		 */
		public function nodeNameIsReserved( nodeName : * ) : Boolean
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

		
		//--------------------------------------------------------------------
		// Private implementation
		//--------------------------------------------------------------------
		
		/** @private */
		function ContextNodeNameList( access : PrivateConstructorAccess )
		{
			if ( !(access is PrivateConstructorAccess) ) throw new PrivateConstructorException();
			
			init( );
		}		
	}
}

internal class PrivateConstructorAccess 
{
}