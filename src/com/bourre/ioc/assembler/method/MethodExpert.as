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
	 
package com.bourre.ioc.assembler.method 
{
	import com.bourre.commands.Batch;
	import com.bourre.core.AbstractLocator;
	import com.bourre.error.IllegalArgumentException;
	import com.bourre.error.PrivateConstructorException;
	import com.bourre.ioc.assembler.constructor.Constructor;
	import com.bourre.ioc.assembler.property.PropertyExpert;
	import com.bourre.ioc.control.BuildFactory;
	import com.bourre.ioc.parser.ContextTypeList;	

	/**
	 *  Dispatched when a method is registered.
	 *  
	 *  @eventType com.bourre.ioc.assembler.method.MethodEvent.onRegisterMethodEVENT
	 */
	[Event(name="onRegisterMethod", type="com.bourre.ioc.assembler.method.MethodEvent")]

	/**
	 *  Dispatched when a method is unregistered.
	 *  
	 *  @eventType com.bourre.ioc.assembler.method.MethodEvent.onUnregisterMethodEVENT
	 */
	[Event(name="onUnregisterMethod", type="com.bourre.ioc.assembler.method.MethodEvent")]

	/**
	 * The MethodExpert class is a locator for 
	 * <code>Method</code> object.
	 * 
	 * @see Method
	 * 
	 * @author Francis Bourre
	 */
	public class MethodExpert extends AbstractLocator
	{
		//--------------------------------------------------------------------
		// Private properties
		//--------------------------------------------------------------------

		private static var	_oI : MethodExpert;

		
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
		
		/**
		 * Returns the unique <code>MethodExpert</code> instance.
		 * 
		 * @return The unique <code>MethodExpert</code> instance.
		 */
		public static function getInstance() : MethodExpert
		{
			if ( !(MethodExpert._oI is MethodExpert) ) 
				MethodExpert._oI = new MethodExpert( new PrivateConstructorAccess( ) );

			return MethodExpert._oI;
		}
		
		/**
		 * Releases singleton.
		 */
		public static function release() : void
		{
			MethodExpert._oI = null;
		}

		/**
		 * Dispatches <code>MethodEvent</code> event using passed-in 
		 * arguments as event properties when a <code>Method</code> is 
		 * registered in locator.
		 * 
		 * <p>Event type is <code>MethodEvent.onRegisterMethodEVENT</code></p>
		 * 
		 * @param	name	Name of the registered <code>Method</code>
		 * @param	o		The registered <code>Method</code>
		 * 
		 * @see Method
		 * @see MethodEvent
		 */
		override protected function onRegister( id : String = null, method : Object = null ) : void
		{
			broadcastEvent( new MethodEvent( MethodEvent.onRegisterMethodEVENT, id, method as Method ) );
		}
		
		/**
		 * Dispatches <code>MethodEvent</code> event using passed-in 
		 * arguments as event properties when a <code>Method</code> is 
		 * unregistered from locator.
		 * 
		 * <p>Event type is <code>MethodEvent.onUnregisterMethodEVENT</code></p>
		 * 
		 * @param	name	Name of the registredred <code>Method</code>
		 * @param	o		The registered <code>Method</code>
		 * 
		 * @see Method
		 * @see MethodEvent
		 */
		override protected function onUnregister( id : String = null ) : void
		{
			broadcastEvent( new MethodEvent( MethodEvent.onUnregisterMethodEVENT, id ) );
		}
		
		public function callMethod( id : String ) : void
		{
			var msg : String;

			var method : Method = locate( id ) as Method;
			var cons : Constructor = new Constructor( null, ContextTypeList.FUNCTION, [ method.ownerID + "." + method.name ] );
			var f : Function = BuildFactory.getInstance( ).build( cons );

			var args : Array = PropertyExpert.getInstance( ).deserializeArguments( method.arguments );
			
			try
			{
				f.apply( null, args );
			} catch ( error2 : Error )
			{
				msg = error2.message;
				msg += " " + this + ".callMethod() failed on instance with id '" + method.ownerID + "'. ";
				msg += "'" + method.name + "' method can't be called with these arguments: [" + args + "]";
				getLogger( ).fatal( msg );
				throw new IllegalArgumentException( msg );
			}
		}
		
		/**
		 * Methods are called in same order as they defined in IoC context.
		 */
		public function callAllMethods() : void
		{
			var keys : Array = getKeys();
			keys.sort();
			
			Batch.process( callMethod, keys );
		}
		
		/**
		 * @copy com.bourre.events.Broadcaster#addListener()
		 */
		public function addListener( listener : MethodExpertListener ) : Boolean
		{
			return getBroadcaster( ).addListener( listener );
		}
		
		/**
		 * @copy com.bourre.events.Broadcaster#removeListener()
		 */
		public function removeListener( listener : MethodExpertListener ) : Boolean
		{
			return getBroadcaster( ).removeListener( listener );
		}
		
		
		//--------------------------------------------------------------------
		// Private implementation
		//--------------------------------------------------------------------
		
		/** @private */
		function MethodExpert( access : PrivateConstructorAccess )
		{
			super( Method, MethodExpertListener, null );
			
			if ( !(access is PrivateConstructorAccess) ) throw new PrivateConstructorException( );
		}
				
	}
}

internal class PrivateConstructorAccess 
{
}