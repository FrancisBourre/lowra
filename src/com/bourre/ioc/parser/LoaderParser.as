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
	import com.bourre.ioc.assembler.ApplicationAssembler;
	
	import flash.net.URLRequest;	

	public class LoaderParser 
		extends AbstractParser
	{
		public function LoaderParser( assembler : ApplicationAssembler = null )
		{
			super( assembler );
		}

		public override function parse( xml : * ) : void
		{
			for each ( var node : XML in xml[ ContextNodeNameList.APPLICATION_LOADER ] ) _parseNode( node );
			delete xml[ ContextNodeNameList.APPLICATION_LOADER ];
		}

		protected function _parseNode( node : XML ) : void
		{
			getAssembler().buildLoader( ContextAttributeList.getID( node ), 
										new URLRequest(ContextAttributeList.getURL( node )),
										ContextAttributeList.getProgressCallback( node ), 										ContextAttributeList.getNameCallback( node ), 										ContextAttributeList.getTimeoutCallback( node ), 										ContextAttributeList.getParsedCallback( node ), 										ContextAttributeList.getMethodsCallCallback( node ), 										ContextAttributeList.getObjectsBuiltCallback( node ), 										ContextAttributeList.getChannelsAssignedCallback( node ), 										ContextAttributeList.getInitCallback( node ) );
		}
	}
}