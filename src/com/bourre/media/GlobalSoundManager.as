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
	 
package com.bourre.media
{
	import com.bourre.error.PrivateConstructorException;
	import com.bourre.events.EventBroadcaster;
	import com.bourre.media.sound.SoundMixerLocator;
	import com.bourre.media.video.VideoDisplayLocator;
	
	import flash.events.Event;		

	/**
	 * The GlobalSoundManager class.
	 * 
	 * <p>TODO Documentation.</p>
	 * 
	 * @author 	Aigret Axel
	 */
	public class GlobalSoundManager 
	{
		private static var _oI : GlobalSoundManager = null;

		protected var _oSTI : SoundTransformInfo ;
		private   var _oEB : EventBroadcaster;

		/**
		 * GlobalSoundManager is a singleton that permit to change all sound of your application in same time
		 * In case of you don't use always sound and video of lowra, you can listen the <code>GlobalSoundManagerEvent.onGlobalSoundChangeEVENT</code>
		 * 
		 * So if you want to change the volume temporarely ( a global volume slider per sample ) you can change just the gain here.
		 * GlobalSoundManager.getInstance().setSoundTransform( new SoundTransformInfo( NaN, 0.2 , NaN ));
		 * 
		 * By putting NaN you will just change the gain ( 0.2 ) , the other properties of SoundTransformInfo will still the same.
		 */
		public function GlobalSoundManager( access : ConstructorAccess )
		{
			if ( !(access is ConstructorAccess) ) throw new PrivateConstructorException();
			
			_oEB = new EventBroadcaster( this ) ;
		}

		public static function getInstance() : GlobalSoundManager
		{
			if ( !(GlobalSoundManager._oI is GlobalSoundManager) ) GlobalSoundManager._oI = new GlobalSoundManager( new ConstructorAccess() );
			return GlobalSoundManager._oI;
		}

		public static function release():void
		{
			if ( GlobalSoundManager._oI is GlobalSoundManager ) GlobalSoundManager._oI = null;
		}
		
		public function setSoundTransform( o : SoundTransformInfo  ) : void
		{
			// set the sound transform to all sound or video created 
			setMasterSoundTransform( o ) ;
			SoundMixerLocator.getInstance().setSoundTransformAll( null, o ) ;
			VideoDisplayLocator.getInstance().setSoundTransformAll( o ) ;	
		}
		
		
		public function setMasterSoundTransform( o : SoundTransformInfo  ) : void
		{
			_oSTI = o ;
			fireEvent( new GlobalSoundManagerEvent( _oSTI.clone() ) ) ;
		}
		
		public function getMasterSoundTransform(  ) : SoundTransformInfo
		{
			return _oSTI ;
		}
		
		public function removeMasterSoundTransform() : void
		{
			_oSTI = null ;
			fireEvent( new GlobalSoundManagerEvent( null ) ) ;
		}
		
		public function hasMasterSoundTransform() : Boolean
		{
			return _oSTI != null ;
		}
		
		
		// Event Broadcaster

		protected function fireEvent( e : Event ) : void
		{
			_oEB.broadcastEvent( e ) ;
		}

		public function addEventListener( type : String, listener : Object, ... rest ) : Boolean
		{
			return _oEB.addEventListener.apply( _oEB, rest.length > 0 ? [ type, listener ].concat( rest ) : [ type, listener ] );
		}

		public function removeEventListener( type : String, listener : Object ) : Boolean
		{
			return _oEB.removeEventListener( type, listener );
		}
		
		
	}
}

internal class ConstructorAccess {}