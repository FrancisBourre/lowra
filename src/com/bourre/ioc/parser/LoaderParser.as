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
	 * Parses xml node definition for Display Loader object.
	 * 
	 * @author Francis Bourre
	 */
	public class LoaderParser extends AbstractParser
	{
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
		
		/**
		 * Creates instance.
		 * 
		 * @param	assembler	(optional) Application assembler to use
		 */	
		public function LoaderParser( assembler : ApplicationAssembler = null )
		{
			super( assembler );
		}
		
		/**
		 * @inheritDoc
		 */
		public override function parse( xml : * ) : void
		{
			for each ( var node : XML in xml[ ContextNodeNameList.APPLICATION_LOADER ] ) _parseNode( node );
			delete xml[ ContextNodeNameList.APPLICATION_LOADER ];
		}
		
		
		//--------------------------------------------------------------------
		// Protected methods
		//--------------------------------------------------------------------
		
		/** @private */	
		protected function _parseNode( node : XML ) : void
		{
			getAssembler().buildLoader( ContextAttributeList.getID( node ), 
										new URLRequest(ContextAttributeList.getURL( node )),
										
										ContextAttributeList.getStartCallback( node ), 										ContextAttributeList.getNameCallback( node ), 
																				ContextAttributeList.getLoadCallback( node ), 										ContextAttributeList.getProgressCallback( node ), 										ContextAttributeList.getTimeoutCallback( node ), 										ContextAttributeList.getErrorCallback( node ), 										ContextAttributeList.getInitCallback( node ), 
																				ContextAttributeList.getParsedCallback( node ), 										ContextAttributeList.getObjectsBuiltCallback( node ), 										ContextAttributeList.getChannelsAssignedCallback( node ), 										ContextAttributeList.getMethodsCallCallback( node ),
																				ContextAttributeList.getCompleteCallback( node ) );
		}
	}
}