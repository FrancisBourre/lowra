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
	 * @author Francis Bourre (Pixlib.com.bourre.media.sound.SoundFactory), Steve Lombard (rewrite for lowRa)
	 * @version 1.0
	 */
	
	import com.bourre.collection.HashMap;
	import com.bourre.error.NoSuchElementException;
	import com.bourre.error.IllegalArgumentException;		
	import com.bourre.log.PixlibStringifier;	

	import flash.media.Sound;	
	import flash.media.SoundChannel;
	import flash.system.ApplicationDomain;
	import flash.media.SoundTransform;
	
	import com.bourre.log.PixlibDebug;
	
	/**
	 * Constructs a new {@code SoundFactory} instance.
	 */		 
	public class SoundFactory
	{				
		private var _mSounds 		: HashMap;	// Contains all Sound : idSound => ObjectSound
		protected var _mSoundTransform: HashMap;
		private var _aChannelsSounds: Array;	// Contains ChannelSoundInfo objects of sounds playing(ChannelSoundInfo.id, ChannelSoundInfo.soundChannel, ChannelSoundInfo.loop)
		private var _aResumeSounds	: Array;	// Contains ReumeSoundInfo objects of sounds to resume(ResumeSoundInfo.id, ReumeSoundInfo.position, ReumeSoundInfo.loop, ReumeSoundInfo.SoundTransform )
		
		private var _bIsOn 			: Boolean;		// SoundFactory instance state : sound(s) playing
		private var _bIsInitialized : Boolean;		// SoundFactory instance is ready	
	
		private var _appliDomain	: ApplicationDomain;	
		
		/**
		 * Constructs a new {@code SoundFactory} instance.
		 */
		public function SoundFactory() 
		{
			_mSounds = new HashMap();
			_mSoundTransform = new HashMap();			
			_aChannelsSounds = new Array();
			_aResumeSounds = new Array();
						
			_bIsInitialized = false;
			_bIsOn = true;
		}

		/**
		 * Defines passed-in {@code applicationDomain} as the sound library's applicationDomain.
		 * @param applicationDomain (optional) {@code ApplicationDomain} instance
		 */
		public function init( applicationDomain : ApplicationDomain = null ) : void 
		{ 
			_appliDomain = ( applicationDomain == null ) ? ApplicationDomain.currentDomain : applicationDomain;
			_bIsInitialized = true;	
		}

	
		/**
		 * Adds new sound to factory.
		 * 
		 * <p>Example
		 * <code>
		 *   var sf : SoundFactory = new SoundFactory();
		 *   sf.addSound("Sound1");	// "Sound1" is a class identifier in the library
		 *   sf.addSound("Sound2"); // "Sound1" is an another class identifier in the library
		 * </code>
		 * 
		 * @param id {@code String} Class identifier in the library ( applicationDomain )
		 */
		public function addSound( id : String ) : void
		{
			if( !_bIsInitialized )	init();
			if( !_mSounds.containsKey(id) )
			{				
				var clazz : Class = _appliDomain.getDefinition( id ) as Class;
				var sound : Sound = new clazz() ;
				_mSounds.put( id, sound );
				_mSoundTransform.put( id, new SoundTransform() );
			}
			else
			{
				PixlibDebug.ERROR("SoundFactory.addSound("+id+") : this id sound is already use");
				throw new IllegalArgumentException("SoundFactory.addSound("+id+") : this id sound is already use") ;				
			}
		}
		
		/**
		 * Adds sounds id list to factory.
		 * 
		 * <p>Example
		 * <code>
		 *   var sf : SoundFactory = new SoundFactory();
		 *   var aSndList : Array = new Array("Sound1", "Sound2"); // contains class identifier
		 *   
		 *   sf.addSounds( aSndList );
		 * </code>
		 * 
		 * @param a {@code Array} Sounds identifier class list
		 */
		public function addSounds( a:Array ) : void
		{
			var l:Number = a.length;
			for (var c:Number=0; c<l ; c++) addSound(a[c]);
		}
			
		/**
		 * Returns {@code Sound} instance stored under passed-in 
		 * {@code id} class identifier.
		 * 
		 * <p>Example
		 * <code>
		 *   var sf : SoundFactory = new SoundFactory();
		 *   sf.addSound("Sound1");
		 *   sf.addSound("Sound2");
		 *   
		 *	try
		 * 	{
		 *   	var o : Sound = sf.getSound("Sound3");
		 *  {
		 * 	catch (e)
		 *  {
		 * 		trace(e);// if idSound not exist
		 *  }
		 * </code>
		 * 
		 * @param id {@code String} Class identifier in the library ( applicationDomain )
		 * @return {@code Sound} instance. If no sound is found, an empty
		 * {@code Sound} is returned.
		 */
		public function getSound( id:String ) : Sound 
		{ 
			if (_bIsOn )
			{
				if ( _mSounds.containsKey( id ) )
				{
					return _mSounds.get( id ) as Sound;
				}
				else
				{
					PixlibDebug.ERROR("SoundFactory.getSound("+id+") : this id doesn't exist");					
					throw new NoSuchElementException("SoundFactory.getSound("+id+") : this id doesn't exist") ;
				}
			}
			else
			{
				return null;
			}
		}
				
		/**
		 * Returns an {@code Array} list of stored sounds.
		 * @return {@code Array} instance
		 */
		public function getAllSounds() : Array
		{
			return _mSounds.getValues();
		}
		
		/**
		 * Removes {@code Sound} instance stored under passed-in 
		 * {@code id} identifier from factory.
		 * 
		 * <p>Example
		 * <code>
		 *   var sf : SoundFactory = new SoundFactory();
		 *   sf.addSound("sound_1");
		 *   sf.addSound("sound_2");
		 *   
		 *   sf.removeSound("sound_1");
		 * </code>
		 * @param id {@code String} Class identifier in the library ( applicationDomain )
		 */
		public function removeSound( id:String ) : void
		{
			var i : uint = _aChannelsSounds.length ;
			if( i > 0 )
			{
				while ( -- i > - 1 )
				{
					if( ( _aChannelsSounds[i] as ChannelSoundInfo ).id == id)
					{
						(_aChannelsSounds[i] as ChannelSoundInfo).soundChannel.stop();
						_aChannelsSounds.splice( i,1 );
					}
				}
			}
			i = _aResumeSounds.length ;
			if( i > 0 )
			{
				while ( -- i > - 1 )
				{
					if( ( _aResumeSounds[i] as ChannelSoundInfo ).id == id)
					{
						_aResumeSounds.splice( i,1 );
					}
				}
			}			
			_mSounds.remove( id );	
			_mSoundTransform.remove( id );
		}
			
		/**
		 * Stops all sounds, clears sounds lists and reset event listeners.
		 */
		public function clear() : void
		{
			goOff();
			_mSounds.clear();
			_aResumeSounds = new Array();			
			_appliDomain = null;			
			_bIsInitialized = false;
		}		

	
	

		/**
		 * Toggles "playing" mode.
		 * 
		 * <p>Uses {@link #goOn} or {@link #goOff} methods to switch 
		 * "playing" mode.
		 */
		public function toggleOnOff() : void 
		{ 
			(_bIsOn) ? goOff() : goOn() ;
		}
		
		/**
		 * Checks if "playing" mode is enable or not.
		 * @return {@code true} is "playing" mode is enable, either {@code false}
		 */
		public function isOn() : Boolean 
		{ 
			return _bIsOn; 
		}
		
		/**
		 * Turns "playing" mode on.
		 * <p>Sounds are not automatically played.
		 */
		public function goOn() : void 
		{ 
			_bIsOn = true; 
		}
		
		/**
		 * Turns "playing" mode off and stops all currently played sounds.
		 */
		public function goOff() : void 
		{ 
			_bIsOn = false;
			var i : uint = _aChannelsSounds.length;
			while ( -- i > - 1 ) ( _aChannelsSounds[ i ] as ChannelSoundInfo ).soundChannel.stop();
			_aChannelsSounds = new Array();	
		}


		
		/**
		 *	Play a sound simply
		 * @param id {@code String} Class identifier in the library ( applicationDomain )
		 */
		public function playSound( id : String ) : void
		{
			if( _bIsOn )
			{
				var soundChannel : SoundChannel =  getSound( id ).play( 0, 0, (_mSoundTransform.get(id) as SoundTransform) );
				var CSI : ChannelSoundInfo = new ChannelSoundInfo(id, soundChannel, false);
				_aChannelsSounds.push( CSI );
			}
		}
		
		/**
		 *	Play a sound in loop ( 65535 times )
		 * @param id {@code String} Class identifier in the library ( applicationDomain )
		 */		
		public function playSoundLoop( id:String ) : void
		{
			if( _bIsOn )
			{
				var soundChannel : SoundChannel =  getSound( id ).play( 0, 65535, (_mSoundTransform.get(id) as SoundTransform) );
				var CSI : ChannelSoundInfo = new ChannelSoundInfo(id, soundChannel, true);
				_aChannelsSounds.push( CSI );			
			}
		}
		
	
		/**
		 *	Stop all channel for a sound
		 * @param id {@code String} Class identifier in the library ( applicationDomain )
		 */			
		public function stopSound( id:String ) : void
		{
			if( _bIsOn )
			{
				var i : uint = _aChannelsSounds.length ;
				if( i > 0 )
				{
					while ( -- i > - 1 )
					{
						if( ( _aChannelsSounds[i] as ChannelSoundInfo ).id == id)
						{
							(_aChannelsSounds[i] as ChannelSoundInfo).soundChannel.stop();
							_aChannelsSounds.splice( i,1 );
						}
					}
				}
			}
		}
		
		/**
		 * Pause all sounds
		 */
		 public function pause () : void
		 {
			var i : uint = _aChannelsSounds.length ;
			if( i > 0 )
			{
				while ( -- i > - 1 )
				{
					var id : String = (_aChannelsSounds[i] as ChannelSoundInfo).id ;
					var position : int = (_aChannelsSounds[i] as ChannelSoundInfo).soundChannel.position ;
					var loop : Boolean = (_aChannelsSounds[i] as ChannelSoundInfo).loop ;
					var RSI : ResumeSoundInfo = new ResumeSoundInfo( id, position, loop ) ;
					_aResumeSounds.push( RSI ) ;
				}
			}			
			 goOff();
		 }		

		/**
		 * Resume sound stop with pause()
		 */
		 public function resume () : void 
		 {
		 	goOn();
			var i : uint = _aResumeSounds.length ;
			if( i > 0 )
			{
				while ( -- i > - 1 )
				{
					var soundChannel : SoundChannel;
					var CSI : ChannelSoundInfo;
					
					var id : String = (_aResumeSounds[i] as ResumeSoundInfo).id;
					var position : int = (_aResumeSounds[i] as ResumeSoundInfo).position;
					var loop : Boolean = (_aResumeSounds[i] as ResumeSoundInfo).loop;
					if( ! loop )
					{	
						soundChannel =  getSound( id ).play( position, 0, (_mSoundTransform.get(id) as SoundTransform) );
						CSI = new ChannelSoundInfo(id, soundChannel, true);
						_aChannelsSounds.push( CSI );
					}
					else
					{
						soundChannel =  getSound( id ).play( position, 65535, (_mSoundTransform.get(id) as SoundTransform) );
						CSI = new ChannelSoundInfo(id, soundChannel, true);
						_aChannelsSounds.push( CSI );			
					}
				}
			}		 	
		 	_aResumeSounds = new Array();	
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

import flash.media.SoundTransform;
import flash.media.SoundChannel;


internal class ResumeSoundInfo
{
	public var id : String;
	public var position : int;
	public var loop : Boolean;
	
	public function ResumeSoundInfo(id : String, position : int , loop : Boolean ) 
	{
		this.id = id;
		this.position = position;
		this.loop = loop;	
	}	
}

internal class ChannelSoundInfo 
{
	
	public var id : String;
	public var soundChannel : SoundChannel;
	public var loop : Boolean;
	
	public function ChannelSoundInfo( id : String, soundChannel : SoundChannel, loop : Boolean )
	{
		this.id = id;
		this.soundChannel = soundChannel;
		this.loop = loop;
	}
}