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
	import com.bourre.error.IllegalArgumentException;
	import com.bourre.events.ValueObjectEvent;
	import com.bourre.ioc.assembler.constructor.Constructor;
	
	import flash.events.Event;	
	
	/**
	 * Command to build uint object.
	 * 
	 * @see Constructor
	 * @see ConstructorExpert
	 * 
	 * @author Francis Bourre
	 */
	public class BuildUint extends AbstractCommand
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

			var n : Number = NaN;
			var args : Array = constructor.arguments;

			if ( args != null && args.length > 0 ) n = parseInt( ( args[0] ).toString() );

			if ( !isNaN( n ) && n <= uint.MAX_VALUE && n >= uint.MIN_VALUE ) 
			{
				constructor.result = uint( n );

			} else
			{
				var msg : String = this + ".build(" + n + ") failed.";
				getLogger().fatal( msg );
				throw new IllegalArgumentException( msg );
			}
		}
	}
}