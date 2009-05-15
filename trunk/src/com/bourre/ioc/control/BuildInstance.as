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
	import com.bourre.commands.Command;
	import com.bourre.core.CoreFactory;
	import com.bourre.error.IllegalArgumentException;
	import com.bourre.events.ValueObjectEvent;
	import com.bourre.ioc.assembler.constructor.Constructor;
	import com.bourre.plugin.ChannelExpert;
	import com.bourre.plugin.Plugin;
	import com.bourre.plugin.PluginChannel;
	import com.bourre.utils.ClassUtils;
	
	import flash.events.Event;
	import flash.utils.getDefinitionByName;	
	
	/**
	 * Command to build dynamic instance.
	 * 
	 * @see ConstructorExpert
	 * 
	 * @author Francis Bourre
	 */
	public class BuildInstance extends AbstractCommand
	{
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
		
		/**
		 * Builds object using <code>Constructor<code> object embed in event.
		 */		
		override public function execute( e : Event = null ) : void 
		{
			var constructor : Constructor = ( e as ValueObjectEvent ).getValueObject() as Constructor;

			if ( constructor.ref )
			{
				var cmd : Command = new BuildRef();
				cmd.execute( e );

			} else
			{
				try
				{
					var isPlugin : Boolean = ClassUtils.inherit( getDefinitionByName( constructor.type ) as Class, Plugin );
					
					if ( isPlugin && constructor.id != null && constructor.id.length > 0 ) 
						ChannelExpert.getInstance().registerChannel( PluginChannel.getInstance( constructor.id ) );
	
				} catch ( error1 : Error )
				{
					getLogger().fatal( this + ".execute() ::" + error1.message );
				}
				
				try
				{
					BuildInstance.buildConstructor( constructor );

				} catch( error2 : Error )
				{
					var msg : String = error2.message;
					msg += " " + this + ".execute(" + constructor.type + ") failed.";
					getLogger().fatal( msg );
					throw new IllegalArgumentException( msg );
				}
			}
		}
		
		public static function buildConstructor( cons : Constructor ) : void
		{
			try
			{
				cons.result = CoreFactory.buildInstance( cons.type, cons.arguments, cons.factory, cons.singleton );

			} catch ( e : Error )
			{
				throw e;
			}
		}
	}
}