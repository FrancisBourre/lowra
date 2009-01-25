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
 
package com.bourre.ioc.assembler.resource
{
	import com.bourre.core.AbstractLocator;
	import com.bourre.error.PrivateConstructorException;	

	/**
	 *  Dispatched when a resource is registered.
	 *  
	 *  @eventType com.bourre.ioc.assembler.resource.ResourceEvent.onRegisterResourceEVENT
	 */
	[Event(name="onRegisterResource", type="com.bourre.ioc.assembler.resource.ResourceEvent")]
	
	/**
	 *  Dispatched when a resource is unregistered.
	 *  
	 *  @eventType com.bourre.ioc.assembler.resource.ResourceEvent.onUnregisterResourceEVENT
	 */
	[Event(name="onUnregisterResource", type="com.bourre.ioc.assembler.resource.ResourceEvent")]
	
	/**
	 * The ResourceExpert class is a locator for 
	 * <code>Resource</code> object.
	 * 
	 * @see Resource
	 * 
	 * @author Francis Bourre
	 */
	public class ResourceExpert extends AbstractLocator
	{
		//--------------------------------------------------------------------
		// Private properties
		//--------------------------------------------------------------------
				
		private static var _oI : ResourceExpert;
		
		
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
		
		/**
		 * Returns unique instance of ResourceExpert class.
		 */
		public static function getInstance() : ResourceExpert 
		{
			if ( !(ResourceExpert._oI is ResourceExpert) ) 
				ResourceExpert._oI = new ResourceExpert( new ConstructorAccess() );

			return ResourceExpert._oI;
		}
		
		/**
		 * Release instance.
		 */
		public static  function release() : void
		{
			_oI.release();			ResourceExpert._oI = null;
		}
		
		/**
		 * Dispatches <code>ResourceEvent</code> event using passed-in 
		 * arguments as event properties when a <code>Resource</code> is 
		 * registered in locator.
		 * 
		 * <p>Event type is <code>ResourceEvent.onRegisterResourceEVENT</code></p>
		 * 
		 * @param	name	Name of the registered <code>Resource</code>
		 * @param	o		The registered <code>Resource</code>
		 * 
		 * @see Resource
		 * @see ResourceEvent
		 */
		override protected function onRegister( id : String = null, resource : Object = null ) : void
		{
			broadcastEvent( new ResourceEvent( ResourceEvent.onRegisterResourceEVENT, id, resource as Resource ) );
		}
		
		/**
		 * Dispatches <code>ResourceEvent</code> event using passed-in 
		 * arguments as event properties when a <code>Resource</code> is 
		 * unregistered from locator.
		 * 
		 * <p>Event type is <code>ResourceEvent.onUnregisterResourceEVENT</code></p>
		 * 
		 * @param	name	Name of the registredred <code>Resource</code>
		 * @param	o		The registered <code>Resource</code>
		 * 
		 * @see Resource
		 * @see ResourceEvent
		 */
		override protected function onUnregister( id : String = null ) : void
		{
			broadcastEvent( new ResourceEvent( ResourceEvent.onUnregisterResourceEVENT, id ) );
		}
		
		/**
		 * @copy com.bourre.events.Broadcaster#addListener()
		 */
		public function addListener( listener : ResourceExpertListener ) : Boolean
		{
			return getBroadcaster().addListener( listener );
		}
		
		/**
		 * @copy com.bourre.events.Broadcaster#removeListener()
		 */
		public function removeListener( listener : ResourceExpertListener ) : Boolean
		{
			return getBroadcaster().removeListener( listener );
		}
		
		
		//--------------------------------------------------------------------
		// Private implementation
		//--------------------------------------------------------------------
		
		/** @private */
		function ResourceExpert( access : ConstructorAccess )
		{
			super( Resource, ResourceExpertListener, null );
			
			if ( !(access is ConstructorAccess) ) throw new PrivateConstructorException();
		}
				
	}
}

internal class ConstructorAccess {}