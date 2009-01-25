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
	import com.bourre.media.SoundTransformInfo;
	import com.bourre.media.sound.SoundMixerLocatorEvent;
	import com.bourre.media.sound.SoundMixerLocatorListener;	

	public class SoundMixerLocator 
		extends AbstractLocator
	{
		private static var _oI : SoundMixerLocator = null;

		public function SoundMixerLocator( access : ConstructorAccess )
		{
			super( SoundMixer, SoundLoaderLocatorListener );
			
			if ( !(access is ConstructorAccess) ) throw new PrivateConstructorException();
		}

		public static function getInstance() : SoundMixerLocator
		{
			if ( !(SoundMixerLocator._oI is SoundMixerLocator) ) SoundMixerLocator._oI = new SoundMixerLocator( new ConstructorAccess() );
			return SoundMixerLocator._oI;
		}

		public static function release():void
		{
			if ( SoundMixerLocator._oI is SoundMixerLocator ) SoundMixerLocator._oI = null;
		}

		override protected function onRegister( name : String = null, o : Object = null ) : void
		{
			broadcastEvent(new SoundMixerLocatorEvent( SoundMixerLocatorEvent.onRegisterSoundMixerEVENT, name, o as SoundMixer));
		}

		override protected function onUnregister( name : String = null ) : void
		{
			broadcastEvent(new SoundMixerLocatorEvent( SoundMixerLocatorEvent.onUnregisterSoundMixerEVENT, name, null ) );
		} 

		public function getSoundMixer( name : String ) : SoundMixer
		{
			try
			{
				var soundMixer : SoundMixer = locate( name) as SoundMixer;
				return soundMixer;

			} catch ( e : Error )
			{
				throw( e );
			}

			return null;
		}
		
		/**
		 * If id , will play all sound with this id , in each SoundMixer
		 * If not it , will play all sound in each SoundMixer
		 */
		public function playAll( id : String = null, loop : uint  = 0 , soundTransformInfo : SoundTransformInfo = null ) : void
		{	
			if( id ) performAll( "playSound", id , loop , soundTransformInfo ) ;
			else  	 performAll( "playAllSound", null ,loop , soundTransformInfo ) ;
		}
		
		public function pauseAll( id : String = null ) : void
		{	
			if( id ) performAll( "pauseSound", id  ) ;
			else  	 performAll( "pauseAllSound", null) ;
		}
		
		public function resumeAll( id : String = null ) : void
		{	
			if( id ) performAll( "resumeSound", id  ) ;
			else  	 performAll( "resumeAllSound", null) ;
		}
		
		public function stopAll( id : String = null ) : void
		{	
			if( id ) performAll( "stopSound", id  ) ;
			else  	 performAll( "stopAllSound", null) ;
		}
		
		public function setSoundTransformAll( id : String = null , soundTransformInfo : SoundTransformInfo = null ) : void
		{	
			if( id ) performAll( "setSoundTransform", id , soundTransformInfo  ) ;
			else  	 performAll( "setSoundTransformAllSound", null ,  soundTransformInfo  ) ;
		}
			
		/**
		 * If id call the function on all id of all SoundMixer
		 * If no id , call the funciton on all sound in all SoundMixer
		 */
		private function performAll( sFunction : String , id : String , ... args ) : void 
		{
			for each( var oSoundMixer : SoundMixer in getValues() )
			{
				var f : Function  = oSoundMixer[ sFunction ] as Function ;
				if( id != null && oSoundMixer.isRegistered( id ) )
					f.apply( null, [ id ].concat( args ) );
				if( id == null )
					f.apply( null,  args  );
			}		
		}
/*
		public function getApplicationDomain( name : String ) : ApplicationDomain
		{
			return getGraphicLoader( name ).getApplicationDomain();
		}*/

		public function addListener( listener : SoundMixerLocatorListener ) : Boolean
		{
			return getBroadcaster().addListener( listener );
		}

		public function removeListener( listener : SoundMixerLocatorListener ) : Boolean
		{
			return getBroadcaster().removeListener( listener );
		}
	}
}

internal class ConstructorAccess {}