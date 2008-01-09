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

	import com.bourre.events.EventBroadcaster;
	import com.bourre.events.StringEvent;
	import com.bourre.ioc.assembler.ApplicationAssembler;
	import com.bourre.log.PixlibStringifier;
	import com.bourre.collection.Iterator;

	public class ContextParser 
		extends AbstractParser
	{
		protected var _oEB : EventBroadcaster;
		protected var _pc : ParserCollection;
		protected var _oContext : XML;

		public function ContextParser( pc : ParserCollection = null, assembler : ApplicationAssembler = null ) 
		{
			super( assembler );

			_oEB = new EventBroadcaster( this );

			if ( _pc == null )
			{
				_pc = new ParserCollection();
				_pc.push( new DLLParser( getAssembler() ) );
				_pc.push( new DisplayObjectParser( getAssembler() ) );
				_pc.push( new ObjectParser( getAssembler() ) );

			} else
			{
				_pc = pc;
			}
		}

		override public function parse( xml : * ) : void
		{
			_oContext = XML( xml );
			var context : XML = _oContext.copy();

			var i : Iterator = _pc.iterator();
			while( i.hasNext() ) ( i.next( ) as AbstractParser ).parse( context );

			_oEB.broadcastEvent( new StringEvent( ContextParserEvent.onContextParsingEndEVENT ) );
		}

		/**
		 * Event system
		 */
		public function addListener( listener : ContextParserListener ) : Boolean
		{
			return _oEB.addListener( listener );
		}

		public function removeListener( listener : ContextParserListener ) : Boolean
		{
			return _oEB.removeListener( listener );
		}

		public function addEventListener( type : String, listener : Object, ... rest ) : Boolean
		{
			return _oEB.addEventListener.apply( _oEB, rest.length > 0 ? [ type, listener ].concat( rest ) : [ type, listener ] );
		}

		public function removeEventListener( type : String, listener : Object ) : Boolean
		{
			return _oEB.removeEventListener( type, listener );
		}

		public function toString() : String
		{
			return PixlibStringifier.stringify( this );
		}
	}
}