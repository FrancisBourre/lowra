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
	import com.bourre.error.NoSuchMethodException;
	import com.bourre.events.ValueObjectEvent;
	import com.bourre.ioc.assembler.constructor.Constructor;
	import com.bourre.ioc.assembler.constructor.ConstructorExpert;
	import com.bourre.ioc.bean.BeanFactory;
	
	import flash.events.Event;	
	
	/**
	 * Command to build Function object.
	 * 
	 * @see Constructor
	 * @see ConstructorExpert
	 * 
	 * @author Francis Bourre
	 */
	public class BuildFunction extends AbstractCommand
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

			var f : Function;
			var msg : String;

			var a : Array = ( constructor.arguments[ 0 ] ).split( "." );
			var targetID : String = a[ 0 ];

			if ( !BeanFactory.getInstance().isRegistered( targetID ) )
				ConstructorExpert.getInstance().buildObject( targetID );
				
			var target : Object = BeanFactory.getInstance().locate( targetID );
			var methodName : String = a[ 1 ];

			try
			{
				f = target[ methodName ] as Function;

			} catch ( error2 : Error )
			{
				msg = error2.message;
				msg += " " + this + ".execute() failed on " + target + " with id '" + targetID + "'. ";
				msg += methodName + " method can't be found.";
				getLogger().fatal( msg );
				throw new NoSuchMethodException( msg );
			}

			constructor.result = f;
		}
	}
}