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
	import com.bourre.ioc.error.NullChannelException;
	import com.bourre.ioc.error.NullIDException;
	import com.bourre.log.PixlibDebug;
	
	import flash.net.URLRequest;		
	
	/**
	 * Parser implementation for 'display object' defined in xml context.
	 * 
	 * @author romain Ecarnot
	 */
	public class DisplayObjectParser extends AbstractParser
	{
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
		
		/**
		 * Creates instance.
		 * 
		 * @param	assembler	(optional) Application assembler to use
		 */	
		public function DisplayObjectParser( assembler : ApplicationAssembler = null )
		{
			super( assembler );
		}
		
		/**
		 * @inheritDoc
		 */
		public override function parse( xml : * ) : void
		{
			var displayXML : XMLList = xml[ ContextNodeNameList.ROOT ];

			if ( displayXML.length() > 0  )
			{
				var rootID : String = displayXML.attribute( ContextAttributeList.ID  );
				
				if ( rootID )
				{
					getAssembler().buildRoot( rootID );

				} else
				{
					var msg : String = this + "ID attribute is mandatory with 'root' node.";
					PixlibDebug.FATAL( msg );
					throw( new NullIDException( msg ) );
				}

				for each ( var node : XML in displayXML.* ) _parseNode( node, rootID );
				delete xml[ ContextNodeNameList.ROOT ];
			}
		}
		
		
		//--------------------------------------------------------------------
		// Private implementation
		//--------------------------------------------------------------------
				
		private function _parseNode( xml : XML, parentID : String = null ) : void
		{
			var msg : String;

			// Filter reserved nodes
			if ( ContextNodeNameList.getInstance().nodeNameIsReserved( xml.name().toString() ) ) return;

			var id : String = ContextAttributeList.getID( xml );
			if ( !id )
			{
				msg = this + " encounters parsing error with '" + xml.name() + "' node. You must set an id attribute.";
				PixlibDebug.FATAL( msg );
				throw( new NullIDException( msg ) );
			}

			getAssembler().registerID( id );
			
			var url : String = ContextAttributeList.getURL( xml );
			var visible : String = ContextAttributeList.getVisible( xml );
			var isVisible : Boolean = visible ? (visible == "true") : true;
			var type : String = ContextAttributeList.getDisplayType( xml );

			getAssembler().buildDisplayObject( id, parentID, url?new URLRequest(url):null, isVisible, type );
			
			// Build property.
			for each ( var property : XML in xml[ ContextNodeNameList.PROPERTY ] )
			{
				getAssembler().buildProperty( 	id, 
												ContextAttributeList.getName( property ),
												ContextAttributeList.getValue( property ),
												ContextAttributeList.getType( property ),
												ContextAttributeList.getRef( property ),
												ContextAttributeList.getMethod( property ) );
			}

			// Build method call.
			for each ( var method : XML in xml[ ContextNodeNameList.METHOD_CALL ] )
			{
				getAssembler().buildMethodCall( id, 
												ContextAttributeList.getName( method ),
												getArguments( method, ContextNodeNameList.ARGUMENT ) );
			}

			// Build channel listener.
			for each ( var listener : XML in xml[ ContextNodeNameList.LISTEN ] )
			{
				var channelName : String = ContextAttributeList.getRef( listener );
				if ( channelName )
				{
					getAssembler().buildChannelListener( id, channelName );

				} else
				{
					msg = this + " encounters parsing error with '" + xml.name() + "' node, 'channel' attribute is mandatory in a 'listen' node.";
					PixlibDebug.FATAL( msg );
					throw( new NullChannelException( msg ) );
				}
			}

			// recursivity
			for each ( var node : XML in xml.* ) _parseNode( node, id );
		}
	}
}