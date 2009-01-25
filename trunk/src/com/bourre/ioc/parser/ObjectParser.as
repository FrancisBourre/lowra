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
	import com.bourre.events.ApplicationBroadcaster;
	import com.bourre.ioc.assembler.ApplicationAssembler;
	import com.bourre.ioc.error.NullChannelException;
	import com.bourre.ioc.error.NullIDException;
	import com.bourre.log.PixlibDebug;	
	
	/**
	 * Parser implementation for generic objects defined in xml context.
	 * 
	 * @author romain Ecarnot
	 */
	public class ObjectParser extends AbstractParser
	{
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
		
		/**
		 * Creates instance.
		 * 
		 * @param	assembler	(optional) Application assembler to use
		 */	
		public function ObjectParser( assembler : ApplicationAssembler = null )
		{
			super( assembler );
		}
		
		/**
		 * @inheritDoc
		 */
		public override function parse( xml : * ) : void
		{
			for each ( var node : XML in xml.* ) _parseNode( node );
		}
		
		
		//--------------------------------------------------------------------
		// Protected methods
		//--------------------------------------------------------------------
		
		/** @private */		
		protected function _parseNode( xml : XML ) : void
		{
			var msg : String;

			// Debug missing ids.
			var id : String = ContextAttributeList.getID( xml );
			if ( !id )
			{
				msg = this + " encounters parsing error with '" + xml.name() + "' node. You must set an id attribute.";
				PixlibDebug.FATAL( msg );
				throw( new NullIDException( msg ) );
			}

			getAssembler().registerID( id );

			var type : String;
			var args : Array;
			var factory : String;
			var singleton : String;

			// Build object.
			type = ContextAttributeList.getType( xml );

			if ( type == ContextTypeList.XML )
			{
				args = new Array();
				args.push( {ownerID:id, value:xml.children()} );
				factory = ContextAttributeList.getDeserializerClass( xml );
				getAssembler().buildObject( id, type, args, factory );

			} else
			{
				args = (type == ContextTypeList.DICTIONARY) ? getItems( xml ) : getArguments( xml, ContextNodeNameList.ARGUMENT, type );
				factory = ContextAttributeList.getFactoryMethod( xml );
				singleton = ContextAttributeList.getSingletonAccess( xml );

				getAssembler().buildObject( id, type, args, factory, singleton );
	
				// register each object to system channel.
				getAssembler().buildChannelListener( id, ApplicationBroadcaster.getInstance().SYSTEM_CHANNEL.toString() );
	
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
						var listenerArgs : Array = getArguments( listener, ContextNodeNameList.EVENT );
						getAssembler().buildChannelListener( id, channelName, listenerArgs );

					} else
					{
						msg = this + " encounters parsing error with '" + xml.name() + "' node, 'ref' attribute is mandatory in a 'listen' node.";
						PixlibDebug.FATAL( msg );
						throw( new NullChannelException( msg ) );
					}
				}
			}
		}
	}
}