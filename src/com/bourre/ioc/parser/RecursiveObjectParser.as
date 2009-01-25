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
	import com.bourre.plugin.PluginDebug;	
	
	/**
	 * Recursive parser.
	 * 
	 * @author Francis Bourre
	 */
	public class RecursiveObjectParser extends AbstractParser
	{
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
		
		/**
		 * Creates instance.
		 * 
		 * @param	assembler	(optional) Application assembler to use
		 */	
		public function RecursiveObjectParser( assembler : ApplicationAssembler = null )
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
				PluginDebug.getInstance().fatal( msg );
				throw( new NullIDException( msg ) );
			}
			
			var type : String;
			var args : Array;
			var factory : String;
			var singleton : String;

			getAssembler().registerID( id );
			
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
				//args = (type == ContextTypeList.DICTIONARY) ? getItems( xml ) : getArguments( xml, ContextNodeNameList.ARGUMENT, type );
				args = (type == ContextTypeList.DICTIONARY) ? getItems( xml ) : getRecursiveObjects( xml, type);
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
						getAssembler().buildChannelListener( id, channelName );
	
					} else
					{
						msg = this + " encounters parsing error with '" + xml.name() + "' node, 'channel' attribute is mandatory in a 'listen' node.";
						PluginDebug.getInstance().fatal( msg );
						throw( new NullChannelException( msg ) );
					}
				}
			}
		}
		
		/** @private */	
		protected function getRecursiveObjects( xml : XML, type : String = null ) : Array
		{
			var aKeyChildsName : Array = [ ContextNodeNameList.ARGUMENT, ContextNodeNameList.PROPERTY, ContextNodeNameList.METHOD_CALL, ContextNodeNameList.LISTEN] ;
			
			var args : Array = new Array();
			var argList : XMLList = xml.child( '*' );
			var length : int = argList.length();

			if ( length > 0 )
			{
				for ( var i : int = 0; i < length; i++ ) 
				{
					if( aKeyChildsName.indexOf( String(argList[ i ].name()) ) == -1)
					{
						var id : String = ContextAttributeList.getID( argList[ i ] );
						var o : Object = {};
						o['ref'] = id ;
						args.push( o );
						_parseNode(argList[ i ]) ;
					}else{
						if(String(argList[ i ].name()) == ContextNodeNameList.ARGUMENT)
						{
							var x : XMLList = argList[ i ].attributes();
							if ( x.length() > 0 ) args.push( getAttributes(x) );
						}
					}
				}
			}else{
				var value : String = ContextAttributeList.getValue( xml );
				if ( value != null ) args.push( { type:type, value:value } );
			}

			return args;
		}
	}
}