package com.bourre.ioc.control 
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
	import com.bourre.commands.AbstractCommand;
	import com.bourre.events.ValueObjectEvent;
	import com.bourre.ioc.assembler.constructor.Constructor;
	import com.bourre.ioc.assembler.constructor.ConstructorExpert;
	import com.bourre.ioc.bean.BeanFactory;
	import com.bourre.utils.ObjectUtils;
	
	import flash.events.Event;	

	public class BuildRef 
		extends AbstractCommand
	{
		override public function execute( e : Event = null ) : void 
		{
			var constructor : Constructor = ( e as ValueObjectEvent ).getValueObject() as Constructor;

			var key : String = constructor.ref;
			if ( key.indexOf(".") != -1 ) key = String( (key.split(".")).shift() );

			if ( !(BeanFactory.getInstance().isRegistered( key )) )
				ConstructorExpert.getInstance().buildObject( key );
				
			constructor.result = BeanFactory.getInstance().locate( key );

			if ( constructor.ref.indexOf(".") != -1 )
			{
				var args : Array = constructor.ref.split(".");
                args.shift();
                constructor.result =  ObjectUtils.evalFromTarget( constructor.result, args.join(".") );
			}
		}
	}
}