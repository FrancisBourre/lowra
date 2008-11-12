package com.bourre.media.video
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
	import com.bourre.media.SoundTransformInfo;	

	public class VideoDisplayLocator 
		extends AbstractLocator
	{
		private static var _oI : VideoDisplayLocator = null;

		public function VideoDisplayLocator( o : ConstructorAccess )
		{
			super( VideoDisplay, VideoDisplayLocatorListener );
		}

		public static function getInstance() : VideoDisplayLocator
		{
			if ( !(VideoDisplayLocator._oI is VideoDisplayLocator) ) VideoDisplayLocator._oI = new VideoDisplayLocator( new ConstructorAccess() );
			return VideoDisplayLocator._oI;
		}

		public static function release():void
		{
			if ( VideoDisplayLocator._oI is VideoDisplayLocator ) VideoDisplayLocator._oI = null;
		}

		override protected function onRegister( name : String = null, o : Object = null ) : void
		{
			broadcastEvent(new VideoDisplayLocatorEvent( VideoDisplayLocatorEvent.onRegisterVideoDisplayEVENT, name, o as VideoDisplay));
		}

		override protected function onUnregister( name : String = null ) : void
		{
			broadcastEvent(new VideoDisplayLocatorEvent( VideoDisplayLocatorEvent.onUnregisterVideoDisplayEVENT, name, null ) );
		} 

		public function getVideoDisplay( name : String ) : VideoDisplay
		{
			try
			{
				var videoDisplay : VideoDisplay = locate( name) as VideoDisplay;
				return videoDisplay;

			} catch ( e : Error )
			{
				throw( e );
			}

			return null;
		}
		
		public function addListener( listener : VideoDisplayLocatorListener ) : Boolean
		{
			return getBroadcaster().addListener( listener );
		}

		public function removeListener( listener : VideoDisplayLocatorListener ) : Boolean
		{
			return getBroadcaster().removeListener( listener );
		}
		
		public function setSoundTransformAll(   soundTransformInfo : SoundTransformInfo ) : void
		{	
			performAll( "setSoundTransform",  soundTransformInfo  ) ;
		}
			
		/**
		 * If id call the function on all id of all SoundMixer
		 * If no id , call the funciton on all sound in all SoundMixer
		 */
		private function performAll( sFunction : String , ... args ) : void 
		{
			for each( var oVideoDisplay : VideoDisplay in getValues() )
			{
				var f : Function  = oVideoDisplay[ sFunction ] as Function ;
				f.apply( null,  args  );
			}		
		}
	}
}

internal class ConstructorAccess {}