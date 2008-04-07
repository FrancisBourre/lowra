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

package com.bourre.media.sound 
{
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	
	import com.bourre.collection.TypedArray;
	import com.bourre.commands.Delegate;
	import com.bourre.commands.Suspendable;
	import com.bourre.events.BasicEvent;
	import com.bourre.events.EventBroadcaster;
	import com.bourre.log.PixlibDebug;	
	import com.bourre.media.sound.SoundTransformInfo;

	public class 	  SoundInfo 
		   implements Suspendable
	{
		public  var DEBUG 		: Boolean = false;
		private var _oEB : EventBroadcaster;

		private static const PLAY : String  = "PLAY" ;
		private static const STOP : String  = "STOP" ; 
		private static const PAUSE : String = "PAUSE" ;
		
		public static const onPlayEnd   : String  = "onPlayEnd" ;
		public static const onPlayLoop  : String  = "onPlayLoop" ;
		
		/** The occurence of the sound for playing the sound */
		private var _oSound : Sound;
		/** the global setting for the id */
		private var _oSTI : SoundTransformInfo ;
		/** A list of <code>ChannelSoundInfo</code> that use this sound */
		private var _aChannel : TypedArray;
		/** Current state */
		private var _sState : String ; 
		
		public function SoundInfo( oSound : Sound ,  oSTI : SoundTransformInfo = null )
		{
			_oEB = new EventBroadcaster( this ) ; 
			_oSound = oSound;
			_oSTI = oSTI ? oSTI : new SoundTransformInfo() ;
			resetChannel();
		}
		
		//channel
		public function addChannel( channelSoundInfo : ChannelSoundInfo ) : void
		{
			if( !channelSoundInfo.hasSoundTransformInfo() )
				channelSoundInfo.setSoundTransformInfo( _oSTI );
			_aChannel.push( channelSoundInfo );
		}
		
		public function getChannel(  ) : TypedArray
		{
			return _aChannel ;
		}
		
		public function resetChannel(): void
		{
			_aChannel = new TypedArray( ChannelSoundInfo );
		}
	
		public function getSound() : Sound
		{
			return _oSound ;
		}
		
		public function getGlobalSoundTransform() : SoundTransform
		{
			return _oSTI.getSoundTransform() ;
		}
		
		public function setState ( s : String ) : void
		{
			_sState = s ;
		}
		
		public function getState() : String
		{
			return _sState;
		}
		
		// Core feature 
		public function playSound( loop : Number = 1 , soundTransformInfo : SoundTransformInfo = null) : void
		{
			if( DEBUG )PixlibDebug.DEBUG(this+".playSound "  );
			if( loop == 0 ) loop = 1 ;
			--loop;
			
			
			var soundChannel : SoundChannel =  getSound().play( 0 , 0 ,
				 ( soundTransformInfo) ? soundTransformInfo.getSoundTransform() : getGlobalSoundTransform() );
			var channelSoundInfo : ChannelSoundInfo = new ChannelSoundInfo( soundChannel , loop , soundTransformInfo )  ;
			
			addChannel( channelSoundInfo );
			setState( SoundInfo.PLAY );
			
			if( DEBUG ) PixlibDebug.DEBUG(this+".playSound loop"  + loop );
			_playLoopSound(  channelSoundInfo  ) ;
			
		}
		
		public function playSoundLoop(  ) : void
		{
			playSound( int.MAX_VALUE ); 
		}
		
		// LOOP
		private function _playLoopSound(  channelSoundInfo : ChannelSoundInfo ) : void
		{
			if( DEBUG ) PixlibDebug.DEBUG(this+"._playLoopSound ");
			channelSoundInfo.getChannel().addEventListener( Event.SOUND_COMPLETE, Delegate.create( _onPlayLoopFinish , channelSoundInfo  ));
		}
		
		private function _onPlayLoopFinish( channelSoundInfo : ChannelSoundInfo, e : Event ) : void
		{
			if( DEBUG ) PixlibDebug.DEBUG(this+"._onPlayLoopFinish "+channelSoundInfo.getLoop());
			channelSoundInfo.addLoop();
			if( channelSoundInfo.isLoop() )
			{
				fireOnPlayLoopEvent(   );
				var soundChannel : SoundChannel =  getSound().play( 0 , 0 , channelSoundInfo.getSoundTransform());
				channelSoundInfo.setChannel( soundChannel ) ;
				_playLoopSound(  channelSoundInfo );
				
			}
			else
			{
				setState( SoundInfo.STOP );
				fireOnPlayEndEvent(  );
			}
		}
		
		public function stopSound(  ) : void
		{
			if( DEBUG ) PixlibDebug.DEBUG(this+".stopSound ");
			var aChannel : TypedArray = getChannel()	 ;	
			
			for each( var oCSI : ChannelSoundInfo in aChannel.toArray() )
				oCSI.getChannel().stop();
			
			setState( SoundInfo.STOP );
			resetChannel();

		}
		
		public function pauseSound (  ) : void
		{
			if( DEBUG ) PixlibDebug.DEBUG(this+".pauseSound ");	

			
			var aChannel : TypedArray = getChannel()	 ;	
			
			for each( var oCSI : ChannelSoundInfo in aChannel.toArray() )
			{
				oCSI.pause();
				oCSI.getChannel().stop();
			}
			setState( SoundInfo.PAUSE);
			

		}
		
		public function resumeSound (  ) : void
		{
			if( DEBUG ) PixlibDebug.DEBUG(this+".resumeSound ");	
	
			var aChannel : TypedArray = getChannel()	 ;	
			
			
			for each( var oCSI : ChannelSoundInfo in aChannel.toArray() )
			{
				
				var soundChannel : SoundChannel =  getSound().play( oCSI.getPosition() , 0 , oCSI.getSoundTransform());
				oCSI.resetPosition();
				oCSI.setChannel( soundChannel ) ;
				
				if( oCSI.isLoop() ) 
					_playLoopSound(  oCSI );
			}
			setState( SoundInfo.PLAY );
				
		}	
		
		
		public function isPlaying( ) : Boolean
		{			
			if( getState() == SoundInfo.PLAY )  return true; 
			return false;
		}
		
		public function isPause( )  : Boolean
		{
			if( getState() == SoundInfo.PAUSE )  return true; 
			return false;
		}
		
		public function isStop( )  : Boolean
		{
			if( getState() == SoundInfo.STOP )  return true; 
			return false;
		}
		
		public function start() : void
		{
			resumeSound();
		}
		
		public function stop() : void
		{
			pauseSound() ;
		}
		
		public function reset() : void
		{
			stopSound();
		}
		
		public function run() : void
		{
			playSound() ;
		}
		
		public function isRunning() : Boolean
		{
			return isPlaying() ;
		}
		
		/**
		 * Event
		 */
		public function addEventListener( type : String, listener : Object, ... rest ) : Boolean
		{
			return _oEB.addEventListener.apply( _oEB, rest.length > 0 ? [ type, listener ].concat( rest ) : [ type, listener ] );
		}

		public function removeEventListener( type : String, listener : Object ) : Boolean
		{
			return _oEB.removeEventListener( type, listener );
		}
		
		protected function fireOnPlayLoopEvent(   ) : void
		{
			fireEvent(new BasicEvent(onPlayLoop , this  ));
		}
		
		protected function fireOnPlayEndEvent(   ) : void
		{
			fireEvent(new BasicEvent(onPlayEnd , this  ));
		}
		
		protected function fireEvent( e : Event ) : void
		{
			_oEB.broadcastEvent( e );
		}
	}
}

import flash.media.Sound;
import flash.media.SoundChannel;
import flash.media.SoundLoaderContext;
import flash.media.SoundTransform;
import flash.net.URLRequest;
import com.bourre.media.sound.SoundTransformInfo;

internal class ChannelSoundInfo 
{
	/** The soundChannel */
	private var _oSoundChannel : SoundChannel;
	/** The specific sound transform ( optional )*/
	private var _oSTI : SoundTransformInfo ; 

	// Pause Resume
	/** the position to remember in case of pause resume*/
	private var _nPosition : Number ;
	/** If the pause is active */
	private var _bPause : Boolean ;
	
	// Loop
	/** Number of loop wanted*/
	private var _nLoop : int ;
	/** Number of play iteration*/
	private var _nPlayIteration : int ;
	
	public function ChannelSoundInfo( soundChannel : SoundChannel, loop : int = 0 , soundTranformInfo : SoundTransformInfo = null )
	{
		_oSoundChannel = soundChannel ;
		setSoundTransformInfo( soundTranformInfo ) ;
		
		resetPosition( ) ;
		
		_nLoop = loop ;
		_nPlayIteration = 0 ; 
		
	}
	
	public function getChannel( ) : SoundChannel 
	{
		return _oSoundChannel ;	
	}
	
	public function setChannel( soundChannel : SoundChannel ) : void
	{
		_oSoundChannel = soundChannel ;
	}
	
	public function getPosition( ) : Number 
	{
		return _nPosition ;
	}

	public function resetPosition( ) : void
	{
		_nPosition = 0;
		_bPause = false;
	}
	
	public function pause() : void
	{
		_nPosition = _oSoundChannel.position ;
		_bPause = true;
	}
	
	public function isPause( ) : Boolean
	{
		return _bPause ; 
	}

	public function addLoop() : void
	{
		++_nPlayIteration;	
	}
	
	public function isLoop( ) : Boolean
	{
		if( _nLoop > 0 && _nPlayIteration <= _nLoop ) return true;
		return false; 
	}
	
	public function getLoop() : Number
	{
		return _nPlayIteration ;
	}
	
	public function hasSoundTransformInfo( ) : Boolean
	{
		return ( _oSTI )? true : false;
	}
	
	public function getSoundTransformInfo( ) : SoundTransformInfo
	{
		return _oSTI ;
	}
	
	public function setSoundTransformInfo( oSTI : SoundTransformInfo ) : void
	{
		_oSTI = oSTI;
	}
	
	public function getSoundTransform() : SoundTransform
	{
		return _oSTI.getSoundTransform() ;
	}
}

internal class NullSound 
	extends Sound
{
	public override function play( startTime:Number = 0, loops:int = 0, sndTransform : SoundTransform = null ) : SoundChannel
	{
		// do nothing
		return null;
	}
	
	public override function load( stream : URLRequest, context : SoundLoaderContext = null ) : void
	{
		// do nothing
	}
}