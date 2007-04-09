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

	import com.bourre.ioc.assembler.*;
	import com.bourre.error.IllegalArgumentException;
	import com.bourre.plugin.PluginDebug;
	import com.bourre.ioc.error.*;

	public class ObjectParser
		extends AbstractParser
	{
		public function ObjectParser( assembler : ApplicationAssembler = null )
		{
			super( assembler );
		}
		
		public override function parse( xml : * ) : void
		{
			for each ( var node : XML in xml.* ) _parseNode( node );
		}
	
		private function _parseNode( xml : XML ) : void
		{
			var msg : String;
			
			// Debug missing ids.
			var id : String = ContextAttributeList.getID( xml );
			if ( id == null )
			{
				msg = this + " encounters parsing error with '" + xml.name() + "' node. You must set an id attribute.";
				PluginDebug.getInstance().fatal( msg );
				throw( new NullIDException( msg ) );
			}
/*
			IDExpert.getInstance().register( id );
*/
			// Build object.
			var type : String = ContextAttributeList.getType( xml );
			var factory : String = ContextAttributeList.getFactoryMethod( xml );
			var singleton : String = ContextAttributeList.getSingletonAccess( xml );
			var channel : String = ContextAttributeList.getChannel( xml );
			
			var args : Array = new Array();
			var argList : XMLList = xml[ ContextNodeNameList.ARGUMENT ];
			var length : int = argList.length();

			if ( length > 0 )
			{
				for ( var i : int = 0; i < length; i++ ) args.push( argList[ i ] );

			} else
			{
				var value : String = ContextAttributeList.getValue( xml );
				if ( value != null ) args.push( { type:type, value:value } );
			}
			
			getAssembler().buildObject( id, type, args, factory, singleton, channel );
/*	
			// register each object to system channel.
			_oAssembler.buildChannelListener( id, PixiocSystemChannel.CHANNEL );
			
			// Build property.
			var propertyNode = xml[ContextNodeNameList.PROPERTY];
			if ( propertyNode )
			_oAssembler.buildProperty( id, propertyNode );
	
			// Build method call.
			var methodCallNode = xml[ContextNodeNameList.METHOD_CALL];
			if ( methodCallNode )
			_oAssembler.buildMethodCall( id, methodCallNode );*/
			
			// Build channel listener.
			for each ( var listener : XML in xml[ ContextNodeNameList.LISTEN ] )
			{
				var channelName : String = ContextAttributeList.getChannel( listener );
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
}