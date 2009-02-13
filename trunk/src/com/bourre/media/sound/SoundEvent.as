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
	 
package com.bourre.media.sound
{
	
	import com.bourre.events.BasicEvent;
	import com.bourre.media.sound.SoundInfoChannel;	
	
	/**
	 * The SoundEvent class represents the event object passed 
	 * to the event listener for <strong>BeanFactory</strong> events.
	 * 
	 * @author Axel Aigret 
	 */
	public class SoundEvent extends BasicEvent
	{
		public static const onSoundPlay 	: String = "onSoundPlay";
		public static const onSoundProgress : String = "onSoundProgress";
		public static const onSoundLoop 	: String = "onSoundLoop";
		public static const onSoundEnd		: String = "onSoundEnd";
		
		public static const onSoundPause 	: String = "onSoundPause";
		public static const onSoundResume 	: String = "onSoundResume";
		public static const onSoundStop 	: String = "onSoundStop";
		
		/** @private */
		protected var _sound 			: SoundInfo ;
		
		/** @private */
		protected var _soundInfoChannel : SoundInfoChannel ;
		
		
		/**
		 * Creates a new <code>SoundEvent</code> object.
		 * 
		 * @param	type				Name of the event type
		 * @param	sound				SoundInfo object carried by this event		 * @param	soundInfoChannel	SoundInfoChannel object carried by this event
		 */	
		public function SoundEvent( type : String, sound : SoundInfo , soundInfoChannel : SoundInfoChannel )
		{
			_sound 			  = sound ;
			_soundInfoChannel = soundInfoChannel ;
			super( type, _sound );
			
		}
		
		/**
		 * Returns the SoundInfo object carried by this event.
		 * 
		 * @return	The SoundInfo value carried by this event.
		 */
		public function getSoundInfo() : SoundInfo
		{
			return _sound;
		}
		
		/**
		 * Returns the SoundInfoChannel object carried by this event.
		 * 
		 * @return	The SoundInfoChannel value carried by this event.
		 */
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