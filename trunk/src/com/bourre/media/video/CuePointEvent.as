package com.bourre.media.video 
{
	import com.bourre.log.PixlibDebug;	
	
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
	public class CuePointEvent extends VideoDisplayEvent 
	{

		private var _oCuePointInfo : Object;
		
		public function CuePointEvent ( type : String, video : VideoDisplay, cuePointInfo : Object ) 
		{
			super( type , video );
	
			_oCuePointInfo = cuePointInfo;
			PixlibDebug.INFO(  "CuePointEvent "+ toString());
		}

		public function getCuePointInfo() : Object
		{
			return _oCuePointInfo;
		}
		
		public function getNameInfo() : String
		{
			return getCuePointInfo().name;
		}
		
		public function getTimeInfo() : String
		{
			return getCuePointInfo().time;
		}
		
		public function getTypeInfo() : String
		{
			return getCuePointInfo().type;
		}
		
		/**
		 * Returns the string representation of this instance.
		 * @return the string representation of this instance
		 */
		override public function toString() : String 
		{
			return getNameInfo()+ ' '+getTimeInfo() + ' '+getTypeInfo();
		}
	}
}
