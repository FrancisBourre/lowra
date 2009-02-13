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
	 
package com.bourre.ioc.control 
{
	import com.bourre.commands.AbstractCommand;
	import com.bourre.core.CoreFactory;
	import com.bourre.encoding.Deserializer;
	import com.bourre.error.IllegalArgumentException;
	import com.bourre.events.ValueObjectEvent;
	import com.bourre.ioc.assembler.constructor.Constructor;
	
	import flash.events.Event;	
	
	/**
	 * Command to build XML object.
	 * 
	 * @see Constructor
	 * @see ConstructorExpert
	 * 
	 * @author Francis Bourre
	 */
	public class BuildXML extends AbstractCommand
	{
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
		
		/**
		 * Builds object using <code>Constructor<code> object embed in event.
		 */
		override public function execute( e : Event = null ) : void 
		{
			var constructor : Constructor = ( e as ValueObjectEvent ).getValueObject( ) as Constructor;

			var args : Array = constructor.arguments;
			var factory : String = constructor.factory;

			if ( args != null || args.length > 0 ) 
			{
				var s : String = args[ 0 ] as String;

				if ( s.length > 0 )
				{
					if ( factory == null )
					{
						constructor.result = new XML( s );

					} else
					{
						try
						{
							var deserialiser : Deserializer = CoreFactory.buildInstance( factory ) as Deserializer;
							constructor.result = deserialiser.deserialize( new XML( s ) );

						} catch ( error : Error )
						{
							var msg : String = error.message;
							msg += this + ".build() failed to deserialize XML with '" + factory + "' deserializer class.";
							getLogger().fatal( msg );
							throw new IllegalArgumentException( msg );
						}
					}

				} else
				{
					getLogger().warn( this + ".build() returns an empty XML." );
					constructor.result = new XML();
				}

			} else
			{
				getLogger().warn( this + ".build() returns an empty XML." );
				constructor.result = new XML();
			}
		}
	}
}