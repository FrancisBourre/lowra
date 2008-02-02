package com.bourre.service 
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
	 */	import com.bourre.core.AbstractLocator;
	import com.bourre.service.ServiceLocatorListener;	

	public class ServiceLocator 
		extends AbstractLocator
	{
		public function ServiceLocator() 
		{
			super( null, ServiceLocatorListener, null );
		}

		override protected function onRegister( key : String = null, service : Object = null ) : void
		{
			var e : ServiceLocatorEvent = new ServiceLocatorEvent( ServiceLocatorEvent.onRegisterServiceEVENT, key, this );
			if ( service is Class ) {e.setServiceClass( service as Class );} else {e.setService( service as Service );}
			broadcastEvent( e );
		}

		override protected function onUnregister( key : String = null ) : void
		{
			broadcastEvent( new ServiceLocatorEvent( ServiceLocatorEvent.onUnregisterServiceEVENT, key, this ) );
		}

		public function registerService( key : String, service : Service ) : Boolean
		{
			return register( key, service );
		}

		public function registerServiceClass( key : String, serviceClass : Class ) : Boolean
		{
			return register( key, serviceClass );
		}

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

		public function addListener( listener : ServiceLocatorListener ) : Boolean
		{
			return addListener( listener );
		}

		public function removeListener( listener : ServiceLocatorListener ) : Boolean
		{
			return removeListener( listener );
		}
	}}