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
	import com.bourre.error.ClassCastException;
	import com.bourre.load.strategy.LoaderStrategy;
	import com.bourre.log.*;

	import flash.display.DisplayObjectContainer;
	import flash.media.Sound;

	public class SoundSWFLoader extends SoundLoader
	{
	
		public function SoundSWFLoader(  name : String = null   )
		{
			super( new LoaderStrategy() );
			if( name != null ) setName( name ) ;
		
		}
		
		public function getSound( sLinkageId : String ) : Sound
		{
			var clazz : Class;
			try
			{
				clazz = getApplicationDomain().getDefinition( sLinkageId ) as Class;
			} catch ( e : Error )
			{
				PixlibDebug.ERROR(this+".getSound("+sLinkageId+") failed, '" + sLinkageId + "' class can't be found in specified SoundFactory application domain");
				throw new ClassCastException(this + ".getSound("+sLinkageId+") failed, '" + sLinkageId + "' class can't be found in specified SoundFactory application domain") ;
			}
				
			return new clazz() ;	
		}
		
		static public function getSoundInSWF( d : DisplayObjectContainer , sLinkageId : String) : Sound
		{
			var clazz : Class;
			try
			{
				clazz = d.loaderInfo.applicationDomain.getDefinition( sLinkageId ) as Class;
			} catch ( e : Error )
			{
				PixlibDebug.ERROR("com.bourre.media.sound.getSoundInSWF("+sLinkageId+") failed, '" + sLinkageId + "' class can't be found in specified SoundFactory application domain");
				throw new ClassCastException("com.bourre.media.sound.getSoundInSWF"+sLinkageId+") failed, '" + sLinkageId + "' class can't be found in specified SoundFactory application domain") ;
			}
				
			return new clazz() ;	
		}
	}
}