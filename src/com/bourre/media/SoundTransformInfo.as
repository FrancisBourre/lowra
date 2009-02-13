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
 
package com.bourre.media
{
	
	import com.bourre.collection.Iterator;
	import com.bourre.collection.WeakCollection;
	import com.bourre.log.PixlibStringifier;
	import com.bourre.media.GlobalSoundManager;
	
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.NetStream;		
	
	/**
	 * The SoundTransformInfo class.
	 * 
	 * <p>TODO Documentation.</p>
	 * 
	 * @author 	Aigret Axel
	 */
	public class SoundTransformInfo
	{
		public static const NORMAL : SoundTransformInfo			 = new SoundTransformInfo( 1, 1, 0);
		public static const NORMAL_LEFT : SoundTransformInfo 	 = new SoundTransformInfo( 1, 1,-1);
		public static const NORMAL_RIGHT : SoundTransformInfo 	 = new SoundTransformInfo( 1, 1, 1);
		
		protected var _oWCsoundChannel : WeakCollection ;
		protected var _oWCstream : WeakCollection ;
		protected var _soundTransform : SoundTransform;
		protected var _nGain 	: Number;
		protected var _nVolume 	: Number;
		protected var _nPan 	: Number;
		
		public function SoundTransformInfo( volume : Number = NaN, gain : Number = NaN , pan : Number = NaN )
		{
			_soundTransform  = new SoundTransform();
			_oWCsoundChannel = new WeakCollection();
			_oWCstream 		 = new WeakCollection();
			
			if( !isNaN(volume) ) setVolume(volume);
			if( !isNaN(gain) ) 	 setGain(gain);
			if( !isNaN(pan) ) 	 setPan(pan);
		}
		
		/*
		 *  Return the sound transform if not global sound transform settings
		 *  In case of global sound information , use it to calculate a new soundTransformInfo but not modify the current one
		 */
		public function getSoundTransform() : SoundTransform
		{
			if( GlobalSoundManager.getInstance().hasMasterSoundTransform() )
				return getGlobalSoundTransfom() ;
			else
				return _soundTransform ;	
		}
		
		protected function getGlobalSoundTransfom() : SoundTransform
		{
			var globalSTI : SoundTransformInfo = clone() ;
			globalSTI.addSoundTransformInfo ( GlobalSoundManager.getInstance().getMasterSoundTransform() ) ;
			return globalSTI._soundTransform ;
		}
		
		public function getGain() : Number
		{
			return _nGain ;
		}
		
		public function setGain( n : Number ) : void
		{
			_nGain = borned0to1( n ) ; 
			applyVolume();
			applySoundTransform() ;
		}
		
		public function hasGain() : Boolean
		{
			return !isNaN(_nGain );
		}
		
		public function getVolume() : Number
		{
			return _nVolume ;
		}
	
		public function setVolume( n : Number) : void
		{
			_nVolume = borned0to1( n ) ; 
			applyVolume();
			applySoundTransform() ;
		}
		
		public function hasVolume() : Boolean
		{
			return !isNaN(_nVolume );
		}
		
		protected function borned0to1( n : Number ) : Number
		{
			return Math.max( Math.min( n , 1 ) , 0 )  ;
		}
		
		protected function applyVolume( ) : void
		{
			_soundTransform.volume = _nGain * _nVolume  ;
		}
		
		protected function applyPan( ) : void
		{
			_soundTransform.pan = _nPan  ;
		}
		
		public function getPan() : Number
		{
			return _soundTransform.pan ;
		}	
	
		public function setPan( n : Number ) : void
		{
			_nPan = Math.max( Math.min( n , 1 ) , -1 )  ;
			applyPan();
			applySoundTransform() ;
		}	
		
		public function hasPan() : Boolean
		{
			return !isNaN(_nPan );
		}
		
		/** Use to apply when the property change for sound */
		public function addSoundChannel( o : SoundChannel ) : void
		{
			_oWCsoundChannel.add( o ) ;
		}

		/** Use to apply when the property change for video */
		public function addStream( o : NetStream ) : void
		{
			_oWCstream.add( o ) ;
		}
		
		/**
		 * Apply sound transform to all SoundChannel or NetStream that use it
		 */
		protected function applySoundTransform() : void
		{
			var soundTransform : SoundTransform  = getSoundTransform();
				
			var it : Iterator = _oWCsoundChannel.iterator() ;
			while( it.hasNext() )
			{
				var soundChannel : SoundChannel = it.next() ;
				soundChannel.soundTransform = soundTransform ;
			}
			
			it = _oWCstream.iterator() ;
			while( it.hasNext() )
			{
				var stream : NetStream = it.next() ;
				stream.soundTransform = soundTransform ;
			}
			
		}	
		
		/**
		 * Set the sound transform info in parameter to the current one 
		 * Set only the none default parameter
		 */
		public function setSoundTransformInfo( o : SoundTransformInfo  ) : void
		{
			addSoundTransformInfo( o ) ; 
			applySoundTransform() ;
		}
		
		protected function addSoundTransformInfo( o : SoundTransformInfo ) : void
		{
			if( o.hasGain( )   ) _nGain = o.getGain()   ;
			if( o.hasVolume( ) ) _nVolume =	o.getVolume()    ;
			if( o.hasPan( )    ) _nPan = o.getPan() ;
			
			applyVolume();
			applyPan();
		}
		
		public function clone( ) : SoundTransformInfo 
		{
			var o : SoundTransformInfo = new SoundTransformInfo() ;
			o._nGain 	= getGain() ;
			o._nVolume 	= getVolume() ;
			o._nPan  	= getPan() ;
			o.applyVolume();
			o.applyPan();
			return o;
		}

		
		
		public function toString( ) : String 
		{
			return PixlibStringifier.stringify(this) + ' volume:'+getVolume()+' gain:'+ getGain() + ' pan:'+getPan()  ;
		}
	
	}
	
}