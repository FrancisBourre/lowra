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
 
package com.bourre.ioc.assembler.constructor
{
	import com.bourre.commands.Batch;
	import com.bourre.core.AbstractLocator;
	import com.bourre.error.PrivateConstructorException;
	import com.bourre.ioc.assembler.plugins.PluginExpert;
	import com.bourre.ioc.assembler.property.PropertyExpert;
	import com.bourre.ioc.control.BuildFactory;
	import com.bourre.plugin.Plugin;	

	/**
	 *  Dispatched when a constructor is registered.
	 *  
	 *  @eventType com.bourre.ioc.assembler.channel.ConstructorEvent.onRegisterChannelListenerEVENT
	 */
	[Event(name="onRegisterConstructor", type="com.bourre.ioc.assembler.constructor.ConstructorEvent")]
	
	/**
	 *  Dispatched when a constructor is unregistered.
	 *  
	 *  @eventType com.bourre.ioc.assembler.channel.ConstructorEvent.onUnregisterChannelListenerEVENT
	 */
	[Event(name="onUnregisterConstructor", type="com.bourre.ioc.assembler.constructor.ConstructorEvent")]
	
	/**
	 * The ConstructorExpert class is a locator for 
	 * <code>Constructor</code> object.
	 * 
	 * @see Constructor
	 * 
	 * @author Francis Bourre
	 */
	public class ConstructorExpert extends AbstractLocator
	{
		//--------------------------------------------------------------------
		// Private properties
		//--------------------------------------------------------------------
				
		private static var _oI : ConstructorExpert;
		
		
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
		
		/**
		 * Returns the unique <code>ConstructorExpert</code> instance.
		 * 
		 * @return The unique <code>ConstructorExpert</code> instance.
		 */
		public static function getInstance() : ConstructorExpert 
		{
			if ( !(ConstructorExpert._oI is ConstructorExpert) ) 
				ConstructorExpert._oI = new ConstructorExpert( new PrivateConstructorAccess() );

			return ConstructorExpert._oI;
		}
		
		/**
		 * Releases singleton.
		 */
		public static  function release() : void
		{
			ConstructorExpert._oI = null;
		}
		
		/**
		 * Dispatches <code>ConstructorEvent</code> event using passed-in 
		 * arguments as event properties when a <code>Constructor</code> is 
		 * registered in locator.
		 * 
		 * <p>Event type is <code>ConstructorEvent.onRegisterConstructorEVENT</code></p>
		 * 
		 * @param	name	Name of the registered <code>Constructor</code>
		 * @param	o		The registered <code>Constructor</code>
		 * 
		 * @see Constructor
		 * @see ConstructorEvent
		 */
		override protected function onRegister( id : String = null, constructor : Object = null ) : void
		{
			broadcastEvent( new ConstructorEvent( ConstructorEvent.onRegisterConstructorEVENT, id, constructor as Constructor ) );
		}
		
		/**
		 * Dispatches <code>ConstructorEvent</code> event using passed-in 
		 * arguments as event properties when a <code>Constructor</code> is 
		 * unregistered from locator.
		 * 
		 * <p>Event type is <code>ConstructorEvent.onUnregisterConstructorEVENT</code></p>
		 * 
		 * @param	name	Name of the registredred <code>Constructor</code>
		 * @param	o		The registered <code>Constructor</code>
		 * 
		 * @see Constructor
		 * @see ConstructorEvent
		 */
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
				
				var o : * = BuildFactory.getInstance().build( cons, id );
				if( o is Plugin ) PluginExpert.getInstance().register( id, o );
				
				unregister( id );
			}
		}

		public function buildAllObjects() : void
		{
			Batch.process( buildObject, getKeys() );
		}
		
		/**
		 * @copy com.bourre.events.Broadcaster#addListener()
		 */
		public function addListener( listener : ConstructorExpertListener ) : Boolean
		{
			return getBroadcaster().addListener( listener );
		}
		
		/**
		 * @copy com.bourre.events.Broadcaster#removeListener()
		 */
		public function removeListener( listener : ConstructorExpertListener ) : Boolean
		{
			return getBroadcaster().removeListener( listener );
		}
		
		
		//--------------------------------------------------------------------
		// Private implementation
		//--------------------------------------------------------------------
		
		/** @private */
		function ConstructorExpert( access : PrivateConstructorAccess )
		{
			super( Constructor, ConstructorExpertListener, null );
			
			if ( !(access is PrivateConstructorAccess) ) throw new PrivateConstructorException();
		}		
	}
}

internal class PrivateConstructorAccess {}