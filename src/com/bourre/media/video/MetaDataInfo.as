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
	import com.bourre.error.NoSuchElementException;
	import com.bourre.log.PixlibDebug;
	import com.bourre.structures.Dimension;		

	/**
	 * The MetaDataInfo class.
	 * 
	 * <p>TODO Documentation.</p>
	 * 
	 * @author 	Aigret Axel
	 */
	public class MetaDataInfo implements MetaData 
	{
		protected var _oMetaData 		: Object ;
		
		/** Time of the video  */
		protected var _nDuration 		: Number ;
		/** Use for send onEndVideoEVENT */
		protected var _nLastTimeStamp   : Number ;
		/** Width of the video  */
		protected var _nWidth 			: Number ;
		/** Height of the video  */
		protected var _nHeight 			: Number ;
		
		
		/** Has keyframes  */
		protected var _bkeyframes 		: Boolean ;
		/** Key time   */
		protected var _aKTimes 			: Array ;
		/** File position for key time   */
		protected var _aKFilePositions 	: Array ;
		
		/**
		 * Creates new <code>MetaDataInfo</code> instance.
		 * 
		 * @param	o	Raw meta information
		 */
		public function MetaDataInfo( o : Object ) 
		{
			_oMetaData = o;
					
			if( _oMetaData.hasOwnProperty("duration"))
				_nDuration = parseInt( _oMetaData.duration );
			if( _oMetaData.hasOwnProperty("width")) 
				_nWidth = _oMetaData.width ;
			if( _oMetaData.hasOwnProperty("height")) 
				_nHeight = _oMetaData.height ;
			if( _oMetaData.hasOwnProperty("lasttimestamp"))
				_nLastTimeStamp = _oMetaData.lasttimestamp  ;
		
			if ( _bkeyframes = _oMetaData.hasOwnProperty("keyframes")  )
			{
				_aKTimes = _oMetaData.keyframes.times;
				_aKFilePositions = _oMetaData.keyframes.filepositions;
			}
		
		}
		
		/**
		 * @inheritDoc
		 */
		public function getDuration() : Number
		{
			return _nDuration ; 
		}
		
		public function getLastTimeStamp() : Number
		{
			return _nLastTimeStamp ; 
		}
		
		/**
		 * @inheritDoc
		 */
		public function getSize() : Dimension
		{
			return new Dimension(_nWidth, _nHeight) ; 
		}
		
		public function hasKeyFrames() : Boolean
		{
			return _bkeyframes ; 
		}
		
		public function getKeyTimes() : Array
		{
			return _aKTimes ; 
		}
		
		public function getKeyFilePositions() : Array
		{
			return _aKFilePositions ; 
		}
		
		public function canResolveObject( s : String ) : Boolean
		{
			return _oMetaData.hasOwnProperty( s ) ;
		}
		
		public function resolveObject( s : String ) : Object
		{
			if( _oMetaData.hasOwnProperty( s ) )
				return _oMetaData[s];
		
			var msg : String = this + ".resolveFunction(" + s + ") failed.";
			PixlibDebug.ERROR( msg );
			throw new NoSuchElementException( msg );
		
			return null;
		}
		
	}
}
