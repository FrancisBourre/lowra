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
	public interface SoundInfoListener 
	{
		function onSoundPlay ( e : SoundEvent ) : void ;
		function onSoundProgress ( e : SoundEvent ) : void ;
		function onSoundLoop ( e : SoundEvent ) : void ;
		function onSoundEnd ( e : SoundEvent ) : void ;
		
		function onSoundPause ( e : SoundEvent ) : void ;
		function onSoundResume ( e : SoundEvent ) : void ;
		function onSoundStop ( e : SoundEvent ) : void ;
	}
}
