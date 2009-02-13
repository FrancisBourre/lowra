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
	import com.bourre.events.ValueObjectEvent;
	import com.bourre.ioc.assembler.constructor.Constructor;
	import com.bourre.ioc.assembler.property.DictionaryItem;
	
	import flash.events.Event;
	import flash.utils.Dictionary;	
	
	/**
	 * Command to build Dictionnay object.
	 * 
	 * @see Constructor
	 * @see ConstructorExpert
	 * 
	 * @author Francis Bourre
	 */
	public class BuildDictionary extends AbstractCommand
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

			var d : Dictionary = new Dictionary();
			var args : Array = constructor.arguments;

			if ( args.length <= 0 ) 
			{
				getLogger().warn( this + ".build(" + args + ") returns an empty Dictionary." );

			} else
			{
				var l : int = args.length;

				for ( var i : int = 0; i < l; i++ )
				{
					var di : DictionaryItem = args[ i ] as DictionaryItem;

					if (di.key != null)
					{
						d[ di.key ] = di.value;

					} else
					{
						getLogger().warn( this + ".build() adds item with a 'null' key for '"  + di.value +"' value." );
					}
				}
			}

			constructor.result = d;
		}
	}
}