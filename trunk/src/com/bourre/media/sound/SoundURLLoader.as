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
	import flash.media.Sound;
	
	import com.bourre.load.AbstractLoader;
	import com.bourre.media.sound.*;	

	public class SoundURLLoader extends SoundLoader
	{

		private var _bAutoPlay : Boolean;
		
	
		public function SoundURLLoader( name : String = null , autoPlay : Boolean = false )
		{
			super( new SoundURLStrategy() );
			if( name != null ) setName( name ) ;
			_bAutoPlay = autoPlay;
			
		}
		
		public function getSound() : Sound
		{
			return getContent() as Sound ; 
		}

		public function setAutoPlay( b : Boolean ) : void
		{
			_bAutoPlay = b;
		}

		
		
	}
}