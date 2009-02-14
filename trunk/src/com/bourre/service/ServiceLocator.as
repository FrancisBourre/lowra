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
package com.bourre.service 
{
	import com.bourre.core.AbstractLocator;		

	/**
	 *  Dispatched when a constructor is registered.
	 *  
	 *  @eventType com.bourre.service.ServiceLocatorEvent.onRegisterServiceEVENT
	 */
	[Event(name="onRegisterService", type="com.bourre.ioc.assembler.constructor.ServiceLocatorEvent")]
	
	/**
	 *  Dispatched when a constructor is unregistered.
	 *  
	 *  @eventType com.bourre.service.ServiceLocatorEvent.onUnregisterServiceEVENT
	 */
	[Event(name="onUnregisterService", type="com.bourre.ioc.assembler.constructor.ServiceLocatorEvent")]
	
	/**
	 * The ServiceLocator class is a locator for remoting
	 * <code>Service</code> object.
	 * 
	 * @see Service
	 * 
	 * @author Francis Bourre
	 */
	public class ServiceLocator extends AbstractLocator
	{
		/**
		 * Creates new <code>ServiceLocator</code> instance.
		 */
		public function ServiceLocator() 
		{
			super( null, ServiceLocatorListener, null );
		}
		
		/**
		 * Dispatches <code>ServiceLocatorEvent</code> event using passed-in 
		 * arguments as event properties when a service is 
		 * registered in locator.
		 * 
		 * <p>Event type is <code>ServiceLocatorEvent.onRegisterServiceEVENT</code></p>
		 * 
		 * @param	name	Name of the registered service
		 * @param	o		The registered service ( Service class or instance )
		 * 
		 * @see Service
		 * @see ServiceLocatorEvent
		 */
		override protected function onRegister( key : String = null, service : Object = null ) : void
		{
			var e : ServiceLocatorEvent = new ServiceLocatorEvent( ServiceLocatorEvent.onRegisterServiceEVENT, key, this );
			if ( service is Class ) {e.setServiceClass( service as Class );} else {e.setService( service as Service );}
			broadcastEvent( e );
		}
		
		/**
		 * Dispatches <code>ServiceLocatorEvent</code> event using passed-in 
		 * arguments as event properties when a <code>Constructor</code> is 
		 * unregistered from locator.
		 * 
		 * <p>Event type is <code>ServiceLocatorEvent.onUnregisterServiceEVENT</code></p>
		 * 
		 * @param	name	Name of the registredred service
		 * @param	o		The unregistered service
		 * 
		 * @see Service
		 * @see ServiceLocatorEvent
		 */
		override protected function onUnregister( key : String = null ) : void
		{
			broadcastEvent( new ServiceLocatorEvent( ServiceLocatorEvent.onUnregisterServiceEVENT, key, this ) );
		}
		
		/**
		 * @copy com.bourre.core.AbstractLocator#register()
		 */
		public function registerService( key : String, service : Service ) : Boolean
		{
			return register( key, service );
		}
		
		/**
		 * @copy com.bourre.core.AbstractLocator#register()
		 */
		public function registerServiceClass( key : String, serviceClass : Class ) : Boolean
		{
			return register( key, serviceClass );
		}
		
		/**
		 * @inheritDoc
		 */
		override public function locate( key : String ) : Object
		{
			try
			{
				var o : Object =  super.locate( key );
				return ( o is Class ) ? new ( o as Class )() : o;

			} catch ( e : Error )
			{
				getLogger().fatal( e.message );
				throw e;
			}
			
			return null;
		}
		
		/**
		 * Returns Service registered with passed-in <code>key</code> 
		 * identifier.
		 */
		public function getService( key : String ) : Service
		{
			try
			{
				var service : Service = locate( key ) as Service;
				return service;

			} catch ( e : Error )
			{
				throw( e );
			}

			return null;
		}
		
		/**
		 * @copy com.bourre.events.Broadcaster#addListener()
		 */
		public function addListener( listener : ServiceLocatorListener ) : Boolean
		{
			return getBroadcaster().addListener( listener );
		}
		
		/**
		 * @copy com.bourre.events.Broadcaster#removeListener()
		 */
		public function removeListener( listener : ServiceLocatorListener ) : Boolean
		{
			return getBroadcaster().removeListener( listener );
		}
	}}