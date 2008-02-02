package com.bourre.ioc.assembler.constructor
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
	import com.bourre.commands.Batch;
	import com.bourre.core.AbstractLocator;
	import com.bourre.ioc.assembler.property.PropertyExpert;
	import com.bourre.ioc.bean.BeanFactory;
	import com.bourre.ioc.control.BuildFactory;	

	public class ConstructorExpert 
		extends AbstractLocator
	{
		private static var _oI : ConstructorExpert;

		public static function getInstance() : ConstructorExpert 
		{
			if ( !(ConstructorExpert._oI is ConstructorExpert) ) 
				ConstructorExpert._oI = new ConstructorExpert( new PrivateConstructorAccess() );

			return ConstructorExpert._oI;
		}

		public static  function release() : void
		{
			ConstructorExpert._oI = null;
		}

		public function ConstructorExpert( access : PrivateConstructorAccess )
		{
			super( Constructor, ConstructorExpertListener, null );
		}

		override protected function onRegister( id : String = null, constructor : Object = null ) : void
		{
			broadcastEvent( new ConstructorEvent( ConstructorEvent.onRegisterConstructorEVENT, id, constructor as Constructor ) );
		}

		override protected function onUnregister( id : String = null ) : void
		{
			broadcastEvent( new ConstructorEvent( ConstructorEvent.onUnregisterConstructorEVENT, id ) );
		}

		public function buildObject( id : String ) : void
		{
			if ( isRegistered( id ) )
			{
				var cons : Constructor = locate( id ) as Constructor;
				if ( cons.arguments != null )  cons.arguments = PropertyExpert.getInstance().deserializeArguments( cons.arguments );
				BeanFactory.getInstance().register( id, BuildFactory.getInstance().build( cons ) );
				unregister( id );
			}
		}

		public function buildAllObjects() : void
		{
			Batch.process( buildObject, getKeys() );
		}

		public function addListener( listener : ConstructorExpertListener ) : Boolean
		{
			return getBroadcaster().addListener( listener );
		}

		public function removeListener( listener : ConstructorExpertListener ) : Boolean
		{
			return getBroadcaster().removeListener( listener );
		}
	}
}

internal class PrivateConstructorAccess {}