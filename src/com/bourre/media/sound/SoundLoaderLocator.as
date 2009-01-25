package com.bourre.media.sound
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
	 * @author Aigret Axel
	 * @version 1.0
	 */
	import com.bourre.core.AbstractLocator;
	import com.bourre.error.PrivateConstructorException;
	import com.bourre.media.sound.SoundLoader;
	import com.bourre.media.sound.SoundLoaderLocatorEvent;
	import com.bourre.media.sound.SoundLoaderLocatorListener;	

	public class SoundLoaderLocator 
		extends AbstractLocator
	{
		private static var _oI : SoundLoaderLocator = null;

		public function SoundLoaderLocator( access : ConstructorAccess )
		{
			super(SoundLoader, SoundLoaderLocatorListener );
			if ( !(access is ConstructorAccess) ) throw new PrivateConstructorException();
		}

		public static function getInstance() : SoundLoaderLocator
		{
			if ( !(SoundLoaderLocator._oI is SoundLoaderLocator) ) SoundLoaderLocator._oI = new SoundLoaderLocator( new ConstructorAccess() );
			return SoundLoaderLocator._oI;
		}

		public static function release():void
		{
			if ( SoundLoaderLocator._oI is SoundLoaderLocator ) SoundLoaderLocator._oI = null;
		}

		override protected function onRegister( name : String = null, o : Object = null ) : void
		{
			broadcastEvent( new SoundLoaderLocatorEvent( SoundLoaderLocatorEvent.onRegisterGraphicLoaderEVENT, name, o as SoundLoader ) );
		}

		override protected function onUnregister( name : String = null ) : void
		{
			broadcastEvent( new SoundLoaderLocatorEvent( SoundLoaderLocatorEvent.onUnregisterGraphicLoaderEVENT, name, null ) );
		} 

		public function getSoundLoader( name : String ) : SoundLoader
		{
			try
			{
				var sound : SoundLoader = locate( name) as SoundLoader;
				return sound;

			} catch ( e : Error )
			{
				throw( e );
			}

			return null;
		}
/*
		public function getApplicationDomain( name : String ) : ApplicationDomain
		{
			return getGraphicLoader( name ).getApplicationDomain();
		}*/

		public function addListener( listener : SoundLoaderLocatorListener ) : Boolean
		{
			return getBroadcaster().addListener( listener );
		}

		public function removeListener( listener : SoundLoaderLocatorListener ) : Boolean
		{
			return getBroadcaster().removeListener( listener );
		}
	}
}

internal class ConstructorAccess {}