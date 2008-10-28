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
	import flash.events.Event;
	
	import com.bourre.media.sound.*;	

	public class SoundMixerLocatorEvent 
		extends Event 
	{
		public static var onRegisterSoundMixerEVENT : String = "onRegisterSoundMixer";
		public static var onUnregisterSoundMixerEVENT : String = "onUnregisterSoundMixer";
	
		protected var _sName : String;
		protected var _sm : SoundMixer ;
		
		public function SoundMixerLocatorEvent( type : String, name : String, sm : SoundMixer )
		{
			super( type );
			
			_sName = name;
			_sm = sm;
		}
		
		public function getName() : String
		{
			return _sName;
		}
		
		public function getSoundMixer() : SoundMixer
		{
			return _sm;
		}
	}
}