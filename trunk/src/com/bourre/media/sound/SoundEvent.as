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
	 * @author Axel Aigret 
	 * @version 1.0
	 */
	import com.bourre.events.BasicEvent;
	import com.bourre.media.sound.SoundInfoChannel;	

	public class SoundEvent 
		extends BasicEvent
	{
		public static const onSoundPlay 	: String = "onSoundPlay";
		public static const onSoundProgress : String = "onSoundProgress";
		public static const onSoundLoop 	: String = "onSoundLoop";
		public static const onSoundEnd		: String = "onSoundEnd";
		
		public static const onSoundPause 	: String = "onSoundPause";
		public static const onSoundResume 	: String = "onSoundResume";
		public static const onSoundStop 	: String = "onSoundStop";
		
		protected var _sound 			: SoundInfo ;
		protected var _soundInfoChannel : SoundInfoChannel ;
		
		public function SoundEvent( type : String, sound : SoundInfo , soundInfoChannel : SoundInfoChannel )
		{
			_sound 			  = sound ;
			_soundInfoChannel = soundInfoChannel ;
			super( type, _sound );
			
		}

		public function getSoundInfo() : SoundInfo
		{
			return _sound;
		}
		
		public function getSoundInfoChannel( ) : SoundInfoChannel 
		{
			return _soundInfoChannel  ;
		}
		
	/*	public function getPerCent() : Number
		{
			return getLoader().getPerCent();
		}
		
		public function getName() : String
		{
			return getLoader().getName();
		}*/

	}
}