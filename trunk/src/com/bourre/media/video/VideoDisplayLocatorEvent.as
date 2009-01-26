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
	
	import flash.events.Event;	
	
	/**
	 * The VideoDisplayLocatorEvent class.
	 * 
	 * <p>TODO Documentation.</p>
	 * 
	 * <p>
	 * <span class='classHeaderTableLabel'>Language Version :</span> ActionScript 3.0<br/>
	 * <span class='classHeaderTableLabel'>Runtime Versions :</span> Flash Player 9
	 * </p>
	 * 
	 * @author 	Aigret Axel
	 */
	public class VideoDisplayLocatorEvent extends Event 
	{
		public static var onRegisterVideoDisplayEVENT : String = "onRegisterVideoDisplay";
		public static var onUnregisterVideoDisplayEVENT : String = "onUnregisterVideoDisplay";
	
		protected var _sName : String;
		protected var _oVideo : VideoDisplay ;
		
		public function VideoDisplayLocatorEvent( type : String, name : String, videoDisplay : VideoDisplay )
		{
			super( type );
			
			_sName = name;
			_oVideo = videoDisplay ;
		}
		
		public function getName() : String
		{
			return _sName;
		}
		
		public function getVideoDisplay() : VideoDisplay
		{
			return _oVideo;
		}
	}
}