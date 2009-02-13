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
	import com.bourre.error.IllegalArgumentException;
	import com.bourre.error.UnimplementedVirtualMethodException;
	import com.bourre.ioc.assembler.ApplicationAssembler;
	import com.bourre.ioc.assembler.DefaultApplicationAssembler;
	import com.bourre.log.PixlibDebug;
	import com.bourre.utils.ClassUtils;	
	
	/**
	 * Abstract implementation for IoC xml node parsers.
	 * 
	 * @author Francis Bourre
	 */
	public class AbstractParser
	{
		//--------------------------------------------------------------------
		// Private properties
		//--------------------------------------------------------------------
				
		private var _oAssembler : ApplicationAssembler;
		
		
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
		
		/**
		 * Creates instance.
		 * 
		 * @param	assembler	(optional) Application assembler to use
		 */		
		public function AbstractParser( assembler : ApplicationAssembler = null )
		{
			if( !( ClassUtils.isImplemented( this, "com.bourre.ioc.parser:AbstractParser", "parse" ) ) )
			{
				var msg : String = this + " have to implement virtual method : parse";
				PixlibDebug.ERROR ( msg );
				throw new UnimplementedVirtualMethodException ( msg );
			}

			setAssembler( ( assembler != null ) ? assembler : new DefaultApplicationAssembler() );
		}
		
		/**
		 * Returns Application assembler used.
		 */
		public function getAssembler() : ApplicationAssembler
		{
			return _oAssembler;
		}
		
		/**
		 * Sets the Application assembler to use.
		 */
		public function setAssembler( assembler : ApplicationAssembler ) : void
		{
			if ( assembler != null )
			{
				_oAssembler = assembler;

			} else
			{
				var msg : String = this + ".setAssembler() failed. Assembler can't be null";
				PixlibDebug.FATAL( msg );
				throw new IllegalArgumentException( msg );
			}
		}
		
		/**
		 * Parses passed-in xml definition to build a clean object.
		 * 
		 * <p>Must be overriding by concrete classes.</p>
		 */
		public function parse( xml : * ) : void
		{
			//
		}
		
		/**
		 * Returns arguments array from passed-in xml.
		 */
		public final function getArguments( xml : XML, nodeName : String, type : String = null ) : Array
		{
			var args : Array = new Array();
			var argList : XMLList = xml.child( nodeName );
			var length : int = argList.length();

			if ( length > 0 )
			{
				for ( var i : int = 0; i < length; i++ ) 
				{
					var x : XMLList = argList[ i ].attributes();
					if ( x.length() > 0 ) args.push( getAttributes(x) );
				}

			} else
			{
				var value : String = ContextAttributeList.getValue( xml );
				if ( value != null ) args.push( { type:type, value:value } );
			}
			
			return args;
		}
		
		public final function getItems( xml : XML ) : Array
		{
			var args : Array = new Array();
			var itemList : XMLList = xml.child( ContextNodeNameList.ITEM );
			var length : int = itemList.length();

			if ( length > 0 )
			{
				for ( var i : int = 0; i < length; i++ ) 
				{
					var keyList : XMLList = (itemList[ i ].child( ContextNodeNameList.KEY ) as XMLList).attributes();
					var valueList : XMLList = (itemList[ i ].child( ContextNodeNameList.VALUE ) as XMLList).attributes();
					if ( keyList.length() > 0 ) args.push( {key:getAttributes(keyList), value:getAttributes(valueList)} );
				}
			}

			return args;
		}
		
		/**
		 * Returns attributes from passed-in xml.
		 */
		public final function getAttributes( attributes : XMLList ) : Object
		{
			var l : int = attributes.length();
			var o : Object = {};
			for ( var j : int = 0; j < l; j++ ) o[ String( attributes[j].name() ) ] = attributes[j];
			return o;
		}
	}
}