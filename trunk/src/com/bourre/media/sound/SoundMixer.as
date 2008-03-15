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

package com.bourre.media.sound {
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	
	import com.bourre.collection.HashMap;
	import com.bourre.collection.TypedArray;
	import com.bourre.commands.Batch;
	import com.bourre.commands.Delegate;
	import com.bourre.error.NoSuchElementException;
	import com.bourre.events.EventBroadcaster;
	import com.bourre.events.StringEvent;
	import com.bourre.log.PixlibDebug;
	import com.bourre.log.PixlibStringifier;
	import com.bourre.media.sound.*;		

	/**
	 * @author Aigret Axel
	 * @version 1.0
	 */	
	 	 
	public class SoundMixer
	{
		private var _oEB : EventBroadcaster;
		
		/* 
		 * Contains all Sound : idSound => SoundInfo
		 * SoundInfo can contain many ChannelSoundInfo 
		 */
		private var _mSounds 	: HashMap ;		
		private var _sName 		: String  ; 
		public  var DEBUG : Boolean = false;
		// Event 
		// TODO: refactory  
		public static var onPlayEnd  : String  = "onPlayEnd" ;
		public static var onPlayLoop  : String  = "onPlayLoop" ;
		
		
		/**
		 * Constructs a new SoundFactory instance.
		 */
		public function SoundMixer( name : String = null) 
		{
			_oEB = new EventBroadcaster( this ) ;
			_mSounds = new HashMap();
			if( name ) setName( name ) ;
		
		}
		
		private function setName( name : String ) : void
		{
			_sName = name ;
			SoundMixerLocator.getInstance().register( getName() , this );
		} 
		
		public function getName() : String
		{
			return _sName ; 	
		}
		
		public function isRegistered( id : String ) : Boolean
		{
			return _mSounds.containsKey( id );
		}
		

		public function getRegisteredId() : Array
		{
			return _mSounds.getKeys();
		}
	
		public function addSound( sound : Sound , id : String , oSTI : SoundTransformInfo = null  ) : void
		{
			if( DEBUG ) PixlibDebug.DEBUG(this+".addSound" + sound + '  ' +id + '   ' +oSTI);
			if( !isRegistered(id) )
			{		
				_mSounds.put( id, new SoundInfo( sound , oSTI ) );
			}
			else
			{
				PixlibDebug.ERROR(this+'.addSound('+id+") : '"+id+"' doesn't exist");					
				throw new NoSuchElementException(this+'.addSound('+id+") : '"+id+"' doesn't exist") ;
				
			}
		
		}
		
		private function _checkId( id : String , sFunctionName : String  ) : Boolean
		{
			if ( isRegistered( id ) ) return true;
			else
			{
				PixlibDebug.ERROR(this+'.'+sFunctionName+'('+id+") : '"+id+"' doesn't exist");					
				throw new NoSuchElementException(this+'.'+sFunctionName+'('+id+") : '"+id+"' doesn't exist") ;
				return false;					
			}	
		}
		
		
		public function addSounds( sound : Sound , aId : Array , aSTI : Array = null ) : void
		{
			for( var i : int = 0 ; i < aId.length ; ++i )
				addSound( sound , aId[i] , (aSTI && i < aSTI.length )? aSTI[i] : null );
			
		}

		public function removeSound( id : String ) : void
		{
			if( _checkId(id , "removeSound" ) )
			{	
				stopSound( id ) ;
				_mSounds.remove( id ) ;
			}
					
		}
		
		public function getActivedSound( ) : Array
		{
			var a : Array = new Array();
			// retrieve all sound that have a channel in play mode and return the array of id
			var aSound : Array =  _mSounds.getKeys();
			for each( var sId : String in aSound )
			{
				var soundInfo : SoundInfo = _mSounds.get( sId ) ;
				if( soundInfo.getState() == SoundInfo.PLAY ) a.push( sId ) ;
			}
			return a ;
						
		}
		
		public function playSound( id : String , loop : Number = 1 , soundTransformInfo : SoundTransformInfo = null) : void
		{
			if( DEBUG )PixlibDebug.DEBUG(this+".playSound "  +id );
			if( loop == 0 ) loop = 1 ;
			--loop;
			
			var soundInfo : SoundInfo = getSoundInfo( id ) ; 
			var soundChannel : SoundChannel =  soundInfo.getSound().play( 0 , 0 ,
				 ( soundTransformInfo) ? soundTransformInfo.getSoundTransform() : soundInfo.getGlobalSoundTransform() );
			var channelSoundInfo : ChannelSoundInfo = new ChannelSoundInfo( soundChannel , loop , soundTransformInfo )  ;
			
			soundInfo.addChannel( channelSoundInfo );
			soundInfo.setState( SoundInfo.PLAY );
			
			if( DEBUG ) PixlibDebug.DEBUG(this+".playSound loop"  + loop );
			_playLoopSound( soundInfo  , channelSoundInfo , id ) ;
			
		}
		
		public function playSoundLoop( id : String  ) : void
		{
			playSound( id , int.MAX_VALUE ); 
		}
		
		// LOOP
		private function _playLoopSound(  soundInfo : SoundInfo , channelSoundInfo : ChannelSoundInfo , id : String ) : void
		{
			if( DEBUG ) PixlibDebug.DEBUG(this+"._playLoopSound ");
			channelSoundInfo.getChannel().addEventListener( Event.SOUND_COMPLETE, Delegate.create( _onPlayLoopFinish, soundInfo  , channelSoundInfo , id ));
		}
		
		private function _onPlayLoopFinish( soundInfo : SoundInfo , channelSoundInfo : ChannelSoundInfo, id :String , e : Event ) : void
		{
			if( DEBUG ) PixlibDebug.DEBUG(this+"._onPlayLoopFinish "+channelSoundInfo.getLoop());
			channelSoundInfo.addLoop();
			if( channelSoundInfo.isLoop() )
			{
				fireOnPlayLoopEvent( id  );
				var soundChannel : SoundChannel =  soundInfo.getSound().play( 0 , 0 , channelSoundInfo.getSoundTransform());
				channelSoundInfo.setChannel( soundChannel ) ;
				_playLoopSound( soundInfo , channelSoundInfo , id);
				
			}
			else
			{
				soundInfo.setState( SoundInfo.STOP );
				fireOnPlayEndEvent( id  );
			}
			
			
		}
		
		
		public function stopSound( id : String ) : void
		{
			if( DEBUG ) PixlibDebug.DEBUG(this+".stopSound "+id);
			
			if( _checkId(id ,"stopSound" ) )
			{			
				var soundInfo : SoundInfo = getSoundInfo( id ) ; 
				var aChannel : TypedArray = soundInfo.getChannel()	 ;	
				
				for each( var oCSI : ChannelSoundInfo in aChannel.toArray() )
				{
					oCSI.getChannel().stop();
				}
				soundInfo.setState( SoundInfo.STOP );
				soundInfo.resetChannel();
			}

		}
		
		public function pauseSound ( id : String ) : void
		{
			if( DEBUG ) PixlibDebug.DEBUG(this+".pauseSound "+id);	
			
			if( _checkId(id ,"pauseSound" ) )
			{		
				var soundInfo : SoundInfo = getSoundInfo( id ) ; 
				soundInfo.setState( SoundInfo.PAUSE);
				var aChannel : TypedArray = soundInfo.getChannel()	 ;	
				
				for each( var oCSI : ChannelSoundInfo in aChannel.toArray() )
				{
					oCSI.pause();
					oCSI.getChannel().stop();
				}
			}

		}
		
		public function resumeSound ( id : String ) : void
		{
			if( DEBUG ) PixlibDebug.DEBUG(this+".resumeSound "+id);	
			
			if( _checkId(id ,"resumeSound" ) )
			{		
				var soundInfo : SoundInfo = getSoundInfo( id ) ; 
				var aChannel : TypedArray = soundInfo.getChannel()	 ;	
				
				soundInfo.setState( SoundInfo.PLAY );
				for each( var oCSI : ChannelSoundInfo in aChannel.toArray() )
				{
					
					var soundChannel : SoundChannel =  soundInfo.getSound().play( oCSI.getPosition() , 0 , oCSI.getSoundTransform());
					oCSI.resetPosition();
					oCSI.setChannel( soundChannel ) ;
					
					if( oCSI.isLoop() )
					 	_playLoopSound( soundInfo , oCSI , id);
				}
				
			}

		}	
		//ALL 
		public function playAllSound( loop : uint  = 0 , soundTransformInfo : SoundTransformInfo = null ) : void
		{
			performAll ( playSound , loop , soundTransformInfo) ;	
		}
		
		public function resumeAllSound() : void
		{
			performAll ( resumeSound ) ;
		}
		
		public function pauseAllSound() : void
		{
			performAll ( pauseSound ) ;
		}
		
		public function stopAllSound(  ) : void
		{
			performAll ( stopSound ) ;
		}
		
		
		private function performAll( f : Function, ... args ) : void
		{
			Batch.process.apply(null , [  f, _mSounds.getKeys() ].concat( args ) );
		}
			
		//UTILS
		public function isPlaying( id : String ) : Boolean
		{			
			if( _checkId(id ,"isPlaying" ) )
			{
				var soundInfo : SoundInfo = getSoundInfo( id ) ; 
				var aChannel : TypedArray = soundInfo.getChannel()	 ;	
				
				for each( var oCSI : ChannelSoundInfo in aChannel.toArray() )
					if( !oCSI.isPause() )  return true; 
				
				return false;

			} 
			return false;
		}
		
		private function getSoundInfo( id:String ) : SoundInfo 
		{ 
			
			if( _checkId(id ,"getSoundInfo" ) )
			{
				return _mSounds.get( id ) as SoundInfo;
			}
			
			return new SoundInfo(new NullSound()) ;
			
		}
		
		// Event 
		public function addEventListener( type : String, listener : Object, ... rest ) : Boolean
		{
			return _oEB.addEventListener.apply( _oEB, rest.length > 0 ? [ type, listener ].concat( rest ) : [ type, listener ] );
		}

		public function removeEventListener( type : String, listener : Object ) : Boolean
		{
			return _oEB.removeEventListener( type, listener );
		}
		
		protected function fireOnPlayLoopEvent(  s : String ) : void
		{
			fireEvent(new StringEvent(onPlayLoop , this , s ));
		}
		
		protected function fireOnPlayEndEvent(  s : String ) : void
		{
			fireEvent(new StringEvent(onPlayEnd , this , s ));
		}
		
		protected function fireEvent( e : Event ) : void
		{
			_oEB.broadcastEvent( e );
		}

		/**
		 * Returns the string representation of this instance.
		 */
		public function toString() : String 
		{
			return PixlibStringifier.stringify( this );
		}
		
	}
}

import flash.media.Sound;
import flash.media.SoundChannel;
import flash.media.SoundLoaderContext;
import flash.media.SoundTransform;
import flash.net.URLRequest;

import com.bourre.collection.TypedArray;
import com.bourre.media.sound.SoundTransformInfo;

internal class SoundInfo 
{
	public static var PLAY : String  = "PLAY" ;
	public static var STOP : String  = "STOP" ; 
	public static var PAUSE : String = "PAUSE" ;
	
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
		_oSound = oSound;
		_oSTI = oSTI ? oSTI : new SoundTransformInfo() ;
		resetChannel();
	}
	
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
}

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