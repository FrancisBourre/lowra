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
	import com.bourre.load.LoaderEvent;
	import com.bourre.media.video.MetaData;	

	/**
	 * The VideoDisplayEvent class.
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
	public class VideoDisplayEvent extends LoaderEvent 
	{

		public static var onPlayHeadTimeChangeEVENT : String = new String( "onPlayHeadTimeChange" );
		public static var onStartStreamEVENT : String 		 = new String( "onStartStream" );
		/** Send when video is stop manually or finish itself*/
		public static var onStopStreamEVENT : String 		 = new String( "onStopStream" );
		/** WORK ONLY WITH METADATA send when video has finish */
		public static var onEndVideoEVENT : String 			 = new String( "onEndVideo" );
		public static var onMetaDataEVENT : String 			 = new String( "onMetaData" );
		public static var onBufferEmptyEVENT : String 		 = new String( "onBufferEmpty" );
		public static var onBufferFullEVENT : String 		 = new String( "onBufferFull" );
		public static var onResizeEVENT : String 			 = new String( "onResize" );
		public static var onCuePointEVENT : String 			 = new String( "onCuePoint" );
		public static var onErrorEVENT : String 			 = new String( "onError" );
		
		public function VideoDisplayEvent( type : String , videoDisplay : VideoDisplay ,  errorMessage : String = "" )
		{ 
			super(type, videoDisplay , errorMessage);
		}
		
		public function getVideoDisplay() : VideoDisplay
		{
			return getLoader() as VideoDisplay ; 
		}

		public function getDuration() : Number
		{
			return getVideoDisplay().getDuration();
		}
	
		public function getPlayheadTime() : Number
		{
			return getVideoDisplay().getDuration();
		}
		
		public function getMetaData( ) : MetaData 
		{
			return getVideoDisplay().getMetaData();
		}
	
		/*public function getFormattedPlayheadTime() : String
		{
			return  StringUtils.getFormattedTime( Math.round(VideoDisplay( _oLib ).getPlayheadTime()) );
		}*/
	}
}
