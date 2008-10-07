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
	import com.bourre.collection.Iterator;
	import com.bourre.collection.WeakCollection;
	
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;	

	public class SoundTransformInfo
	{
		protected var _oWCsoundChannel : WeakCollection ;
		protected var _soundTransform : SoundTransform;
		protected var _gain 	: Number;
		
		public function SoundTransformInfo( volume : Number = 1 , gain : Number = 1 , pan : Number = 0 )
		{
			_soundTransform = new SoundTransform();
			_oWCsoundChannel = new WeakCollection();
			
			setVolume(volume);
			setGain(gain);
			setPan(pan);
		}
		
		public function getSoundTransform() : SoundTransform
		{
			return _soundTransform ;	
		}
		
		//TODO: compute gain in volume
		public function getGain() : Number
		{
			return _gain ;
		}
		
		public function setGain( n : Number ) : void
		{
			_gain = n ;
			//applySoundTransform() ;
		}
		
		public function getVolume() : Number
		{
			return _soundTransform.volume ;
		}
	
		public function setVolume( n : Number) : void
		{
			_soundTransform.volume = n ;
			applySoundTransform() ;
		}
		
		public function getPan() : Number
		{
			return _soundTransform.pan ;
		}	
	
		public function setPan( n : Number ) : void
		{
			_soundTransform.pan = n ;
			applySoundTransform() ;
		}	
		
		/** Use to apply when the property change */
		public function addSoundChannel( o : SoundChannel ) : void
		{
			_oWCsoundChannel.add( o ) ;
		}

		protected function applySoundTransform() : void
		{
			var it : Iterator = _oWCsoundChannel.iterator() ;
			while( it.hasNext() )
			{
				var soundChannel : SoundChannel = it.next() ;
				soundChannel.soundTransform = _soundTransform ;
			}
			
		}	
	
	}
	
}