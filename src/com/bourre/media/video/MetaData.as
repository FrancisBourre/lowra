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
	import com.bourre.structures.Dimension;		

	/**
	 * The MetaData interface.
	 * 
	 * <p>TODO Documentation.</p>
	 * 
	 * @author 	Aigret Axel
	 */
	public interface MetaData 
	{
		/**
		 * Returns the duration of the video file, in seconds.
		 * 
		 * @return The duration of the video file, in seconds.
		 */
		function getDuration() : Number
		function getLastTimeStamp() : Number
		
		/**
		 * Returns the size of the video file, in seconds.
		 * 
		 * @return The size of the video file, in seconds.
		 */
		function getSize() : Dimension
		function hasKeyFrames() : Boolean
		function getKeyTimes() : Array
		function getKeyFilePositions() : Array
	}
}
