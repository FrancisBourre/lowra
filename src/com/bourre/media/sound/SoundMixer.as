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
	import flash.media.Sound;
	
	import com.bourre.collection.HashMap;
	import com.bourre.commands.Batch;
	import com.bourre.commands.Suspendable;
	import com.bourre.error.IllegalArgumentException;
	import com.bourre.error.NoSuchElementException;
	import com.bourre.log.PixlibDebug;
	import com.bourre.log.PixlibStringifier;
	import com.bourre.media.SoundTransformInfo;
	import com.bourre.media.sound.*;	

	/**
	 * @author Aigret Axel
	 * @version 1.0
	 */	
	 	 
	public class 	  SoundMixer
		   implements Suspendable
	{
		/* use it to learn to manipulate SoundMixer */
		public  var DEBUG 		: Boolean = false;
		/* 
		 * Contains all Sound : idSound => SoundInfo
		 * SoundInfo can contain many ChannelSoundInfo 
		 */
		protected var _mSounds 	: HashMap ;		
		/** Id name of this SoundMixer */
		protected var _sName 		: String  ; 
		/** If lock , play, stop, resume, pause, are ignore */ 
		protected var _bLocked 	: Boolean = false;
		
		
		/**
		 * Constructs a new <code>SoundMixer</code> instance.
		 * @param name (optionnal) The Sound Mixer name id , if present SoundMixer is register in the SoundMixerLocator
		 */
		public function SoundMixer( name : String = null) 
		{
			//_oEB = new EventBroadcaster( this ) ;
			_mSounds = new HashMap();
			if( name ) setName( name ) ;
			
		}
		
		private function setName( name : String ) : void
		{
			if ( name != null ) 
			{
				_sName = name ;
				
				if ( !(SoundMixerLocator.getInstance().isRegistered( _sName )) )
					SoundMixerLocator.getInstance().register( _sName , this );
				else
				{
					var msg : String = this + " can't be registered to " + SoundMixerLocator.getInstance() 
										+ " with '" + _sName  + "' name. This name already exists.";
					PixlibDebug.ERROR( msg );
					throw new IllegalArgumentException( msg );
				}
			}
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

		/*
		 * Lock
		 * If lock all play, pause, resume, stop, call will be ignore
		 */
		public function lock( ) : void
		{
			_bLocked = true; 
		}
		
		public function unlock( ) : void
		{
			_bLocked = false; 
		}
		
		public function isLock( ) : Boolean
		{
			return _bLocked ; 
		}
		
		// Construct library
		
		public function addSound( sound : Sound , id : String , oSTI : SoundTransformInfo = null  ) : void
		{
			if( DEBUG ) PixlibDebug.DEBUG(this+".addSound" + sound + '  ' +id + '   ' +oSTI);
			if( !isRegistered(id)  )
			{	
				_mSounds.put( id, new SoundInfo( sound , oSTI ) );
			}
			else
			{
				PixlibDebug.ERROR(this+'.addSound('+id+") : '"+id+"' doesn't exist");					
				throw new NoSuchElementException(this+'.addSound('+id+") : '"+id+"' doesn't exist") ;
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
				//TODO:  remove listener
				_mSounds.remove( id ) ;
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
		
		/**
		 * 
		 */
		public function getSoundInfoWithState( sState : String = null ) : Array
		{
			var a : Array = new Array();
			// retrieve all sound that have a channel in play mode and return the array of id
			if( !sState ) return _mSounds.getValues() ;
			
			var aSound : Array =  _mSounds.getKeys();
			for each( var sId : String in aSound )
			{
				var soundInfo : SoundInfo = _mSounds.get( sId ) ;
				if( soundInfo.getState() == sState ) a.push( sId ) ;
			}
			return a ;
						
		}
		
		// Manipulate id ( if unlock )
		public function playSoundLoop( id : String  ) : void
		{
			playSound( id , int.MAX_VALUE ); 
		}
		
		public function playSound( id : String , loop : Number = 1 , soundTransformInfo : SoundTransformInfo = null) : void
		{
			if( DEBUG )PixlibDebug.DEBUG(this+".playSound "  +id );
			
			if( _checkId(id ,"playSound" ) && !isLock() )
			{
				var soundInfo : SoundInfo = getSoundInfo( id ) ; 
				soundInfo.playSound( loop , soundTransformInfo )  ;
			}
		}
		
		

		public function stopSound( id : String ) : void
		{
			if( DEBUG ) PixlibDebug.DEBUG(this+".stopSound "+id);
			if( _checkId( id ,"stopSound" ) && !isLock())
			{			
				var soundInfo : SoundInfo = getSoundInfo( id ) ; 
				soundInfo.stopSound( )  ;
			}

		}
		
		public function pauseSound ( id : String ) : void
		{
			if( DEBUG ) PixlibDebug.DEBUG(this+".pauseSound "+id);	
			if( _checkId( id ,"pauseSound" ) && !isLock() )
			{		
				var soundInfo : SoundInfo = getSoundInfo( id ) ; 
				soundInfo.pauseSound( )  ;
			}

		}
		
		public function resumeSound ( id : String ) : void
		{
			if( DEBUG ) PixlibDebug.DEBUG(this+".resumeSound "+id);	
			if( _checkId( id ,"resumeSound" ) && !isLock() )
			{		
				var soundInfo : SoundInfo = getSoundInfo( id ) ; 
				soundInfo.resumeSound( )  ;
			}

		}
		
		public function setSoundTransform( id : String  , o : SoundTransformInfo  ) : void
		{
			if( DEBUG ) PixlibDebug.DEBUG(this+".setSoundTransform "+id);	
			if( _checkId( id ,"setSoundTransform" ) && !isLock() )
			{		
				var soundInfo : SoundInfo = getSoundInfo( id ) ; 
				soundInfo.setSoundTransform( o ) ;
			}

		}
		
		// Manipulate all id
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
		
		public function setSoundTransformAllSound(  o : SoundTransformInfo) : void
		{
			performAll ( setSoundTransform , o ) ;
		}
		
		private function performAll( f : Function, ... args ) : void
		{
			if( !isLock() ) 
				Batch.process.apply(null , [  f, _mSounds.getKeys() ].concat( args ) );
		}
			
		// Utils
		public function isPlaying( id : String ) : Boolean
		{			
			if( _checkId(id ,"isPlaying" ) )
			{
				var soundInfo : SoundInfo = getSoundInfo( id ) ; 
				return soundInfo.isPlaying();
			} 
			return false;
		}
		
		public function isPause( id : String )  : Boolean
		{
			if( _checkId(id , "isPause" ) )
			{
				var soundInfo : SoundInfo = getSoundInfo( id ) ; 
				return soundInfo.isPause();
			} 
			return false;
		}
		
		public function isStop( id : String )  : Boolean
		{
			if( _checkId(id , "isStop" ) )
			{
				var soundInfo : SoundInfo = getSoundInfo( id ) ; 
				return soundInfo.isStop();
			} 
			return false;
		}
		
		public function getSoundInfo( id : String ) : SoundInfo 
		{ 
			if( _checkId(id ,"getSoundInfo" ) )
				return _mSounds.get( id ) as SoundInfo;
		
			return new SoundInfo(new NullSound()) ;
		}
		
		// Event 
		/*public function addEventListener( type : String, listener : Object, ... rest ) : Boolean
		{
			return _oEB.addEventListener.apply( _oEB, rest.length > 0 ? [ type, listener ].concat( rest ) : [ type, listener ] );
		}

		public function removeEventListener( type : String, listener : Object ) : Boolean
		{
			return _oEB.removeEventListener( type, listener );
		}
		
		
		protected function fireLoopEvent(  id :String ) : void
		{
			fireEvent(new StringEvent( SoundEvent.onSoundLoop, this , id ) );
		}
		
		protected function fireEndEvent(  id :String ) : void
		{
			fireEvent( new StringEvent( SoundEvent.onSoundEnd, this, id ) );
		}
		
		protected function fireEvent( e : Event ) : void
		{
			_oEB.broadcastEvent( e );
		}*/

		/**
		 * Returns the string representation of this instance.
		 */
		public function toString() : String 
		{
			return PixlibStringifier.stringify( this);
		}
		
		/**
		 * Implements Suspendable 
		 */
		public function start() : void
		{
			resumeAllSound();
		}
		
		public function stop() : void
		{
			pauseAllSound();
		}
		
		public function reset() : void
		{
			stopAllSound();
		}
		
		public function run() : void
		{
			playAllSound();
		}
		
		public function isRunning() : Boolean
		{
			return getSoundInfoWithState( SoundInfo.PLAY ).length > 0 ;
		}
		
		public function release() : void
		{
			for each(var sSoundId : String in getRegisteredId())
				removeSound( sSoundId ) ;
				
			if ( getName() && SoundMixerLocator.getInstance().isRegistered(getName()) ) 
				 SoundMixerLocator.getInstance().unregister( getName() );
		}
	}
}

import flash.media.Sound;
import flash.media.SoundChannel;
import flash.media.SoundLoaderContext;
import flash.media.SoundTransform;
import flash.net.URLRequest;

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