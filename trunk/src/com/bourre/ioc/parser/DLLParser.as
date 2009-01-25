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
	import com.bourre.ioc.assembler.ApplicationAssembler;
	
	import flash.net.URLRequest;		
	
	/**
	 * Parser implementation for 'DLL' defined in xml context.
	 * 
	 * @author romain Ecarnot
	 */
	public class DLLParser extends AbstractParser
	{
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
		
		/**
		 * Creates instances.
		 */		
		public function DLLParser( assembler : ApplicationAssembler = null )
		{
			super( assembler );
		}
		
		/**
		 * @inheritDoc
		 */
		public override function parse( xml : * ) : void
		{
			var dllXML : XMLList = (xml as XML).child( ContextNodeNameList.DLL );	
			var l : int = dllXML.length( );
			for ( var i : int = 0; i < l ; i++ ) _parseNode( dllXML[ i ] );
			delete xml[ ContextNodeNameList.DLL ];
		}
		
		//--------------------------------------------------------------------
		// Protected methods
		//--------------------------------------------------------------------
		
		/** @private */		
		protected function _parseNode( node : XML ) : void
		{
			getAssembler( ).buildDLL( new URLRequest( ContextAttributeList.getURL( node ) ) );
		}	}}