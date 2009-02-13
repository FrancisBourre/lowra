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
	 
package com.bourre.media.video 
{
	import com.bourre.log.PixlibDebug;		

	/**
	 * The CuePointEvent class represents the event object passed 
	 * to the event listener when VideoDisplay receive video cue points.
	 * 
	 * @see VideoDisplay
	 * 
	 * @author 	Aigret Axel
	 */
	public class CuePointEvent extends VideoDisplayEvent 
	{

		private var _oCuePointInfo : Object;
		
		/**
		 * Creates new <code>CuePointEvent</code> instance.
		 * 
		 * @param	type			Name of the event type
		 * @param	video			VideoDisplay object carried by this event
		 * @pram	cuePointInfo	Raw cue points definitions for passed-in VideoDisplay
		 */
		public function CuePointEvent ( type : String, video : VideoDisplay, cuePointInfo : Object ) 
		{
			super( type , video );
	
			_oCuePointInfo = cuePointInfo;
			PixlibDebug.INFO(  "CuePointEvent "+ toString());
		}
		
		/**
		 * Returns the cue points object carried by this event.
		 * 
		 * @return	The cue points object carried by this event.
		 */
		public function getCuePointInfo() : Object
		{
			return _oCuePointInfo;
		}
		
		public function getNameInfo() : String
		{
			return getCuePointInfo().name as String;
		}
		
		public function getTimeInfo() : String
		{
			return getCuePointInfo().time as String;
		}
		
		public function getTypeInfo() : String
		{
			return getCuePointInfo().type as String; 
		}
		
		/**
		 * Returns the string representation of this instance.
		 * 
		 * @return the string representation of this instance
		 */
		override public function toString() : String 
		{
			return getNameInfo()+ ' '+getTimeInfo() + ' '+getTypeInfo();
		}
	}
}
