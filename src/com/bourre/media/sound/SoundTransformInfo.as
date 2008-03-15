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
	import flash.media.SoundTransform;		

	public class SoundTransformInfo
	{
	
		private var _sd		: SoundTransform;
		private var _gain 	: Number;
		
		public function SoundTransformInfo( volume : Number = 1 , gain : Number = 1 , pan : Number = 0 )
		{
			_sd = new SoundTransform();
			setVolume(volume);
			setGain(gain);
			setPan(pan);
		}
		
		public function getSoundTransform() : SoundTransform
		{
			return _sd;	
		}
		
		public function getGain() : Number
		{
			return _gain;
		}
		
		public function setGain( n : Number ) : void
		{
			_gain = n;
		}
		
		public function getVolume() : Number
		{
			return _sd.volume;
		}
	
		public function setVolume( n : Number) : void
		{
			_sd.volume = n;
		}
		
		public function getPan() : Number
		{
			return _sd.pan;
		}	
	
		public function setPan( n : Number ) : void
		{
			_sd.pan = n;
		}		
	
	}
	
}