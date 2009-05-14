
	 
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
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	
	import com.bourre.collection.TypedArray;
	import com.bourre.commands.Delegate;
	import com.bourre.commands.Suspendable;
	import com.bourre.events.EventBroadcaster;
	import com.bourre.log.PixlibDebug;
	import com.bourre.media.SoundTransformInfo;
	import com.bourre.media.sound.SoundInfoChannel;
	import com.bourre.transitions.MSBeacon;
	import com.bourre.transitions.TickBeacon;
	import com.bourre.transitions.TickListener;	

	public class 	  SoundInfo 
		   implements Suspendable , TickListener
	{
		/** TickBeacon to manage the time to fire onSoundProgress event */
		protected static var TICKBEACON : TickBeacon ;

		public static function setTickBeacon( beacon : TickBeacon ) : void
		{
			TICKBEACON = beacon ; 
		}
		
		public function onTick( e : Event = null )  : void
		{
			for each( var souchChannelInfo : SoundInfoChannel in getChannel().toArray() )
				if( souchChannelInfo.isPlaying() ) fireSoundEvent( SoundEvent.onSoundProgress , souchChannelInfo ) ;
		}
		
		public    var DEBUG 		 : Boolean = false;
		
		public static const PLAY  : String  = "PLAY" ;
		public static const STOP  : String  = "STOP" ; 
		public static const PAUSE : String  = "PAUSE" ;
		
		/** The occurence of the sound for playing the sound */
		protected var _oSound : Sound;
		/** the global setting for the id */
		protected var _oSTI : SoundTransformInfo ;
		/** A list of <code>ChannelSoundInfo</code> that use this sound */
		protected var _aChannel : TypedArray;
		
		protected var _oEB 			 : EventBroadcaster;
	
		public function SoundInfo( oSound : Sound ,  oSTI : SoundTransformInfo = null )
		{
			
			_oEB = new EventBroadcaster( this ) ; 
			_oSound = oSound;
			_oSTI = oSTI ? oSTI : SoundTransformInfo.NORMAL ;
			initTickBeacon();
			
			resetChannel();
		}
		
		protected function initTickBeacon() : void
		{
			if( !TICKBEACON )
			{
				var t : MSBeacon = new MSBeacon();
				t.setTickPerSecond(15);
				TICKBEACON = t ;
			}
			TICKBEACON.addTickListener(this);
		}
		
		//channel
		protected function addChannel( channelSoundInfo : ChannelSoundInfo ) : void
		{
			if( !channelSoundInfo.hasSoundTransformInfo() )
				channelSoundInfo.setSoundTransformInfo( _oSTI );
			_aChannel.push( channelSoundInfo );
		}
		
		/*
		 * Returns an array of all SoundInfoChannel use by this SoundInfo
		 */
		public function getChannel(  ) : TypedArray
		{
			return _aChannel ;
		}
		
		protected function resetChannel(): void
		{
			_aChannel = new TypedArray( ChannelSoundInfo );
		}
	
		public function getSound() : Sound
		{
			return _oSound ;
		}
		
		public function getSoundTransformInfo() : SoundTransformInfo
		{
			return _oSTI ;
		}
		
		// Core feature 
		public function playSoundLoop(  ) : void
		{
			playSound( int.MAX_VALUE ); 
		}
		
		public function playSound( loop : Number = 1 , soundTransformInfo : SoundTransformInfo = null) : void
		{
			if( DEBUG )PixlibDebug.DEBUG( this+".playSound " +getSound() );
			if( loop <= 0 ) loop = 1 ;
			--loop ;
		
			var oSTI : SoundTransformInfo   =  soundTransformInfo ? soundTransformInfo : getSoundTransformInfo() ;
			var soundChannel : SoundChannel =  getSound().play( 0 , 0 , oSTI.getSoundTransform() );
			var channelSoundInfo : ChannelSoundInfo = new ChannelSoundInfo( soundChannel , loop , oSTI )  ;
			
			addChannel( channelSoundInfo );
			
			fireSoundEvent( SoundEvent.onSoundPlay, channelSoundInfo) ;
			
			if( DEBUG ) PixlibDebug.DEBUG(this+".playSound loop"  + loop  );
			_playLoopSound(  channelSoundInfo  ) ;
			
		}

		protected function _playLoopSound(  channelSoundInfo : ChannelSoundInfo ) : void
		{
			if( DEBUG ) PixlibDebug.DEBUG(this+"._playLoopSound "+ channelSoundInfo.getChannel() );
			channelSoundInfo.getChannel().addEventListener( Event.SOUND_COMPLETE, Delegate.create( _onPlayLoopFinish , channelSoundInfo  ));
		}
		
		protected function _onPlayLoopFinish(e : Event, channelSoundInfo : ChannelSoundInfo) : void
		{
			if( DEBUG ) PixlibDebug.DEBUG(this+"._onPlayLoopFinish "+channelSoundInfo.getLoop());

			channelSoundInfo.addLoop();
			if( channelSoundInfo.isLoop() )
			{
				fireSoundEvent( SoundEvent.onSoundLoop , channelSoundInfo) ;
				var soundChannel : SoundChannel =  getSound().play( 0 , 0 , channelSoundInfo.getSoundTransform());
				channelSoundInfo.setChannel( soundChannel ) ;
				_playLoopSound(  channelSoundInfo );
			}
			else
			{
				// remove channel after finish playing
				_aChannel.splice( _aChannel.toArray().indexOf( channelSoundInfo ) , 1) ;
				// if we have no more channel the SoundInfo is stop, else we don't know 
				fireSoundEvent( SoundEvent.onSoundEnd , channelSoundInfo) ;
			}
		}
		
		public function stopSound(  ) : void
		{
			if( DEBUG ) PixlibDebug.DEBUG(this+".stopSound ");
			var aChannel : TypedArray = getChannel()	 ;	
			
			for each( var oCSI : ChannelSoundInfo in aChannel.toArray() )
			{
				oCSI.getChannel().stop();
				fireSoundEvent( SoundEvent.onSoundStop, oCSI ) ;
			}
			
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
				fireSoundEvent( SoundEvent.onSoundPause, oCSI) ;
			}
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
				
				fireSoundEvent( SoundEvent.onSoundResume , oCSI) ;
				
				_playLoopSound(   oCSI );
			}
		}	
		
		public function setSoundTransform( o : SoundTransformInfo  ) : void
		{
			if( DEBUG ) PixlibDebug.DEBUG(this+".setSoundTransform "+ o );	
			var aChannel : TypedArray = getChannel()	 ;	
			
			for each( var oCSI : ChannelSoundInfo in aChannel.toArray() )
			{
				var channelSTI : SoundTransformInfo = oCSI.getSoundTransformInfo( );
				channelSTI.setSoundTransformInfo( o  ) ;
			}
			
			_oSTI = o ;
		}

		
		public function getState( ) : String
		{
			return 	getCurrentState( ) ;
		}
		
		public function isPlaying( ) : Boolean
		{			
			if( getCurrentState() == SoundInfo.PLAY )  return true; 
			return false;
		}
		
		public function isPause( )  : Boolean
		{
			if( getCurrentState() == SoundInfo.PAUSE )  return true; 
			return false;
		}
		
		public function isStop( )  : Boolean
		{
			if( getCurrentState() == SoundInfo.STOP )  return true; 
			return false;
		}
		
		public function isBuffering( )  : Boolean
		{
			return getSound().isBuffering ;
		}
		
		/**
		 * Return state in force order : PLAY PAUSE STOP ( in decrease )
		 * If we have three channel with at least one playing , it return SoundInfo.PLAY
		 * If no play channel but at least one pause , it return SoundInfo.PAUSE
		 * If no channel it return SoundInfo.STOP
		 */
		protected function getCurrentState( ) : String
		{
			var sState : String = SoundInfo.STOP ;
			var aChannel : Array = getChannel().toArray()	 ;	
			
			for ( var i : uint = 0 ; i < aChannel.length && sState != SoundInfo.PLAY ; ++i )
			{
				var oCSI : ChannelSoundInfo = aChannel[i] as ChannelSoundInfo ;
				if( oCSI.isPause()   ) sState = SoundInfo.PAUSE ;
				if( oCSI.isPlaying() ) sState = SoundInfo.PLAY  ;  
			}
			return sState ;
		}
		
		/**
		 * Implements Suspendable
		 */
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
		
		public function addListener( listener : SoundInfoListener ) : Boolean
		{
			return _oEB.addListener( listener );
		}

		public function removeListener( listener : SoundInfoListener ) : Boolean
		{
			return _oEB.removeListener( listener );
		}
		
		protected function fireSoundEvent( type : String , soundInfoChannel : SoundInfoChannel ) : void
		{
			fireEvent( new SoundEvent( type , this, soundInfoChannel ) );
		}
		
		protected function fireEvent( e : Event ) : void
		{
			_oEB.broadcastEvent( e);
		}
		
		
	}
}

import flash.media.Sound;
import flash.media.SoundChannel;
import flash.media.SoundLoaderContext;
import flash.media.SoundTransform;
import flash.net.URLRequest;

import com.bourre.media.SoundTransformInfo;
import com.bourre.media.sound.SoundInfoChannel;

/**
 * ChannelSoundInfo is use to play and remember all information about a play iteration of a sound
 * The time of live of this object in the array of soundInfo channel is during it's playing time including pause
 * In case of stop , it is delete.
 */
internal class 		ChannelSoundInfo 
		 implements SoundInfoChannel
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
	private var _nLoop : uint ;
	/** Number of play iteration*/
	private var _nPlayIteration : uint ;
	
	public function ChannelSoundInfo( soundChannel : SoundChannel, loop : uint = 0 , soundTranformInfo : SoundTransformInfo = null )
	{
		_oSoundChannel = soundChannel ;
		setSoundTransformInfo( soundTranformInfo) ;
		
		getSoundTransformInfo().addSoundChannel( _oSoundChannel ) ;
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
		getSoundTransformInfo().addSoundChannel( _oSoundChannel ) ;
	}
	
	public function getPosition( ) : Number 
	{
		return _nPosition ;
	}
	
	public function getLoopIteration( ): uint
	{
		return _nPlayIteration ;
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
	
	public function isPlaying( ) : Boolean 
	{
		return !isPause() ;
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
	
	public function getLoop() : uint
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