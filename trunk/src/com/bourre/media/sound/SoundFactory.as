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
	import com.bourre.commands.Delegate;	
	import com.bourre.log.PixlibStringifier;	

	import flash.media.Sound;	
	import flash.media.SoundChannel;
	import flash.system.ApplicationDomain;
	
	
	/**
	 * Constructs a new {@code SoundFactory} instance.
	 */		 
	public class SoundFactory
	{				
		private var _mSounds 		: HashMap;	// Contains all Sound
		private var _mChannels		: HashMap;	// Contains SoundChannel corresponding to its Sound
		
		private var _bIsOn 			: Boolean;		// SoundFactory instance state : sound(s) playing
		private var _bIsInitialized : Boolean;		// SoundFactory instance is ready	
	
		private var _appliDomain	: ApplicationDomain;	
		
		/**
		 * Constructs a new {@code SoundFactory} instance.
		 */
		public function SoundFactory() 
		{
			_mSounds = new HashMap();
			_mChannels = new HashMap();
			
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
			if( !_bIsInitialized ) init();
			var clazz : Class = _appliDomain.getDefinition( id ) as Class;
			var sound : Sound = new clazz() ;
			_mSounds.put( id, sound );
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
					throw new Error("id sound unexpected") ;
				}
			} else
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
			_mSounds.remove( id );
			_mChannels.remove( id );
		}
			
		/**
		 * Stops all sounds, clears sounds lists and reset event listeners.
		 */
		public function clear() : void
		{
			goOff();
			_mSounds.clear();
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
			var a : Array = _mChannels.getValues();
			var l : int = a.length;
			while ( -- l > - 1 ) ( a[ l ] as SoundChannel ).stop();
			_mChannels.clear();
		}


		
		/**
		 *	Play a sound simply
		 * @param id {@code String} Class identifier in the library ( applicationDomain )
		 */
		public function playSound( id:String ) : void
		{
			if( _bIsOn )
			{
				var channel : SoundChannel =  getSound( id ).play();
				_mChannels.put( id, channel);
			}
		}
		
		/**
		 *	Play a sound in loop ( 65535 times )
		 * @param id {@code String} Class identifier in the library ( applicationDomain )
		 */		
		public function playSoundLoop( id:String ) : void
		{
			if( _bIsOn ) getSound( id ).play(0,65535);
		}
		
		/**
		 *	Stop a sound
		 * @param id {@code String} Class identifier in the library ( applicationDomain )
		 */			
		public function stopSound( id:String ) : void
		{
			if( _bIsOn ) (_mChannels.get( id ) as SoundChannel).stop();
		}			



		/**
		 * Returns the string representation of this instance.
		 * @return the string representation of this instance
		 */
		public function toString() : String 
		{
			return PixlibStringifier.stringify( this );
		}
		
	}
		
}