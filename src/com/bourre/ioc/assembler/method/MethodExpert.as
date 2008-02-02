package com.bourre.ioc.assembler.method 
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
	import com.bourre.error.IllegalArgumentException;
	import com.bourre.error.NoSuchMethodException;
	import com.bourre.ioc.assembler.property.PropertyExpert;
	import com.bourre.ioc.bean.BeanFactory;		

	public class MethodExpert 
		extends AbstractLocator
	{
		private static var	_oI		: MethodExpert;

		public static function getInstance() : MethodExpert
		{
			if ( !(MethodExpert._oI is MethodExpert) ) 
				MethodExpert._oI = new MethodExpert( new PrivateConstructorAccess() );

			return MethodExpert._oI;
		}

		public static function release() : void
		{
			MethodExpert._oI = null;
		}

		public function MethodExpert( access : PrivateConstructorAccess )
		{
			super( Method, MethodExpertListener, null );
		}
		
		override protected function onRegister( id : String = null, method : Object = null ) : void
		{
			broadcastEvent( new MethodEvent( MethodEvent.onRegisterMethodEVENT, id, method as Method ) );
		}

		override protected function onUnregister( id : String = null ) : void
		{
			broadcastEvent( new MethodEvent( MethodEvent.onUnregisterMethodEVENT, id ) );
		}

		public function callMethod( id : String ) : void
		{
			var method : Method = locate( id ) as Method;

			var f : Function;
			var msg : String;
			var owner : Object = BeanFactory.getInstance().locate( method.ownerID );

			try
			{
				f = owner[ method.name ] as Function;

			} catch ( error1 : Error )
			{
				msg = error1.message;
				msg += " " + this + ".callMethod() failed on " + owner + " with id '" + method.ownerID + "'. ";
				msg += method.name + " method can't be found.";
				getLogger().fatal( msg );
				throw new NoSuchMethodException( msg );
			}

			var args : Array = PropertyExpert.getInstance().deserializeArguments( method.args );

			try
			{
				f.apply( null, args );

			} catch ( error2 : Error )
			{
				msg = error2.message;
				msg += " " + this + ".callMethod() failed on " + owner + " with id '" + method.ownerID + "'. ";
				msg += "'" + method.name + "' method can't be called with these arguments: [" + args + "]";
				getLogger().fatal( msg );
				throw new IllegalArgumentException( msg );
			}
		}

		public function callAllMethods() : void
		{
			Batch.process( callMethod, getKeys() );
		}

		public function addListener( listener : MethodExpertListener ) : Boolean
		{
			return getBroadcaster().addListener( listener );
		}

		public function removeListener( listener : MethodExpertListener ) : Boolean
		{
			return getBroadcaster().removeListener( listener );
		}
	}
}

internal class PrivateConstructorAccess {}