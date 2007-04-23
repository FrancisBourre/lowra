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
	import com.bourre.collection.HashMap;
	import com.bourre.error.NoSuchElementException;
	import com.bourre.error.IllegalArgumentException;		
	import com.bourre.log.PixlibStringifier;	

	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.system.ApplicationDomain;
	import flash.media.SoundTransform;
	
	import com.bourre.log.PixlibDebug;
	import com.bourre.collection.TypedArray;
	import com.bourre.error.IllegalStateException;
	import com.bourre.error.ClassCastException;
	
	/**
	 * <pre>
	 * The SoundFactory class is a collection of sounds. 
	 * All sounds put in , must be in the library of one swf and linked with a className.
	 * You can define the ApplicationDomain which contains your sounds, by default the ApplicationDomain is the current.
	 * 
	 * You can add, get, remove, play (simple or loop), stop a sound and know if it is registered, is playing thanks to it's className.
	 * The same sound can be played several times at same time.
	 * If you stop a sound, all channels wich play it are stopped.
	 * You can make a pause : it make a pause on all channels.
	 * You can make a resume : all channels paused resume to their default behaviors.
	 * </pre>
	 * 
	 * @example
	 * <pre>
	 * import com.bourre.media.sound.SoundFactory;
	 * import com.bourre.media.load.GraphicLoader; 
	 * import com.bourre.media.load.GraphicLoaderEvent;
	 * 
	 * public class MaClasse
	 * { 
	 * 		private var _myLoader 		: GraphicLoader ;
	 * 		private static var _sF 		: SoundFactory ; 
	 * 		...
	 * 		private function init( url : String ) : void
	 * 		{
	 *	 		var myUrlLoader : URLRequest = new URLRequest(url);	// url = "mylibSound1.swf"
	 * 			_myLoader = new GraphicLoader();
	 * 			_myLoader.addEventListener( GraphicLoaderEvent.onLoadInitEVENT ,callBack );
	 * 			_myLoader.load( myUrlLoader );
	 * 		}
	 *
	 * 		public function callBack( e : Event)
	 * 		{
	 * 			_sF = new SoundFactory();
	 * 			_sF.init(_myLoader.getContentLoaderInfo().applicationDomain);
	 * 
	 * 			_sF.addSound("sound1");
	 * 			_sF.isRegistered("sound1");	// => true
	 * 			_sF.isRegistered("sound2");	// => false
	 * 
	 * 			var sound : Sound = _sF.getSound("sound1");
	 * 			var soundChannel : SoundChannel = sound.play( sound.length/2, 2 );
	 * 			_sF.stopSound("sound1"); 	// the sound is not stopped
	 * 			soundChannel.stop(); 		// the sound is stopped
	 * 
	 * 			_sF.play("sound1");
	 * 			_sF.play("sound1"); 		// 2 channels play the "sound1"
	 * 			_sF.stop("sound1"); 		// the 2 channels are stopped
	 * 			...
	 * 		}
	 * }
	 * </pre>
	 * 
	 * @author Francis Bourre (Pixlib.com.bourre.media.sound.SoundFactory), Steve Lombard (rewrite for lowRa)
	 * @version 1.0
	 */		
	 	 
	public class SoundFactory
	{				
		protected var _mSoundTransform	: HashMap;
		protected var _aChannelsSounds	: TypedArray;	// Contains ChannelSoundInfo objects of sounds playing(ChannelSoundInfo.id, ChannelSoundInfo.soundChannel, ChannelSoundInfo.loop)		
		
		private var _mSounds 			: HashMap;	// Contains all Sound : idSound => ObjectSound
		private var _aResumeSounds		: TypedArray;	// Contains ReumeSoundInfo objects of sounds to resume(ResumeSoundInfo.id, ReumeSoundInfo.position, ReumeSoundInfo.loop, ReumeSoundInfo.SoundTransform )
		
		private var _bIsOn 				: Boolean;		// SoundFactory instance state : sound(s) playing
		private var _bIsInitialized 	: Boolean;		// SoundFactory instance is ready	
	
		private var _appliDomain		: ApplicationDomain;	
		
		/**
		 * Constructs a new SoundFactory instance.
		 */
		public function SoundFactory() 
		{
			_mSounds = new HashMap();
			_mSoundTransform = new HashMap();			
			_aChannelsSounds = new TypedArray( ChannelSoundInfo );
			_aResumeSounds = new TypedArray( ResumeSoundInfo );
						
			_bIsInitialized = false;
			_bIsOn = true;
		}

		/**
		 * Defines passed-in applicationDomain as the sound library's applicationDomain.
		 * It can be check with Loader.contentLoaderInfo.applicationDomain.
		 * To use only if your sounds are in an external swf.
		 * 
		 * @param by default it's ApplicationDomain.currentDomain
		 * 
		 * @throws if your SoundFactory instance is already initialised : an IllegalStateException instance is return
		 * 
		 * @example 
		 * <pre>
		 * embed method :
		 * 
		 * import com.bourre.media.sound.SoundFactory;
		 * import flash.display.Loader;
		 * 
		 * public class MaClasse
		 * { 
		 * 		[Embed(source="./../../../testBin/SoundFactory.swf", mimeType="application/octet-stream")]
		 * 		private static var _SWFBytes 	: Class;	
		 * 		private static var _sF 			: SoundFactory = new SoundFactory();
		 * 		private static var _loader		: Loader;
		 * 		private static var _apliDomain	: ApplicationDomain;
		 * 
		 * 		MaClasse._loader = new Loader();
		 * 		MaClasse._loader.loadBytes( new MaClasse._SWFBytes() );
		 * 		MaClasse._apliDomain = MaClasse._loader.contentLoaderInfo.applicationDomain;
		 * 		try
		 * 		{
		 * 			MaClasse._sF.init( MaClasse._apliDomain );
		 * 			MaClasse._sF.init( ApplicationDomain.currentDomain ); // generate a IllegalStateException
		 * 		}
		 * 		catch ( e : IllegalStateException)
		 * 		{
		 * 			trace(e.message); //=>instanceSoundFactory.init() failed, SoundFactory can't be initialized twice
		 * 		}
		 * 
		 * 		...
		 * }
		 * 
		 * loaded method :
		 * 
		 * import com.bourre.media.sound.SoundFactory;
		 * import com.bourre.media.load.GraphicLoader; 
		 * import com.bourre.media.load.GraphicLoaderEvent;
		 * 
		 * public class MaClasse
		 * { 
		 * 		private var _myLoader 		: GraphicLoader ;
		 * 		private var _sF 			: SoundFactory ; 
		 * 		...
		 * 		private function init( url : String ) : void
		 * 		{
		 *	 		var myUrlLoader : URLRequest = new URLRequest(url);	// url = "mylibSound1.swf"
		 * 			_myLoader = new GraphicLoader();
 		 * 			_myLoader.addEventListener( GraphicLoaderEvent.onLoadInitEVENT ,callBack );
		 * 			_myLoader.load( myUrlLoader );
		 * 		}
		 *
		 * 		public function callBack( e : Event)
		 * 		{
		 * 			_sF = new SoundFactory();
		 * 			try
		 * 			{
		 * 				_sF.init( _myLoader.getContentLoaderInfo.applicationDomain );
		 * 				_sF.init( ApplicationDomain.currentDomain ); // generate a IllegalStateException
		 * 			}
		 * 			catch ( e : IllegalStateException )
		 * 			{
		 * 				trace(e.message); //=>instanceSoundFactory.init() failed, SoundFactory can't be initialized twice
		 * 			}
		 * 		}
		 * }
		 * </pre>
		 */
		public function init( applicationDomain : ApplicationDomain = null ) : void 
		{ 
			if ( !_bIsInitialized )
			{
				_appliDomain = ( applicationDomain is ApplicationDomain ) ? applicationDomain : ApplicationDomain.currentDomain;
				_bIsInitialized = true;

			} else
			{
				PixlibDebug.ERROR(this + ".init() failed, SoundFactory can't be initialized twice");
				throw( new IllegalStateException( this + ".init() failed, SoundFactory can't be initialized twice" ) );
			}
		}
		
		
		/**
		 * Check if a sound is already register
		 * 
		 * @param sound's class identifier in the library
		 * 
		 * @return true : is registered / false : is not registered 
		 * 
		 * @see #getRegisteredId()
		 * 
		 * @example
		 * <pre>
		 *   var _sf : SoundFactory = new SoundFactory();
		 *	_sF.addSound("sound1");
		 *	_sF.isRegistered("sound1");	// => true
		 *	_sF.isRegistered("sound2");	// => false
		 * </pre>
		 * 
		 */
		public function isRegistered( id : String ) : Boolean
		{
			return _mSounds.containsKey( id );
		}
		
		/**
		 * Get all sound's class identifier use
		 * 
		 * @return an Array of sound's class identifier use
		 * 
		 * @see #isRegistered()
		 * 
		 * @example
		 * <pre>
		 *   var _sf : SoundFactory = new SoundFactory();
		 *	_sF.addSound("sound1");
		 *	_sF.addSound("sound2");
		 *	_sF.addSound("sound3");
		 *  _sF.getRegisteredId(); // => ["sound3", "sound2", "sound1"] NO ORDER GUARANTED !
		 * </pre>
		 */
		public function getRegisteredId() : Array
		{
			return _mSounds.getKeys();
		}
	
		/**
		 * Add a new sound.
		 * 
		 * @param sound's class identifier in the library
		 * 
		 * @throws if sound's class identifier is already use : an IllegalArgumentException instance is return
		 * @throws if sound's class not found in specified SoundFactory application domain : an ClassCastException instance is return
		 * 
		 * @see #getSound()
		 * @see #removeSound()
		 * 
		 * @example
		 * <pre>
		 *  var _sf : SoundFactory = new SoundFactory();
		 *  try
		 *  {
		 * 		_sF.addSound("sound1");
		 *  	_sF.addSound("sound1");  // generate an IllegalArgumentException : it's already added
		 * 		_sF.addSound("badSound");// generate a ClassCastException : this sound's class identifier in the library doesn't exist
		 *  }
		 *  catch( e : IllegalArgumentException )
		 *  {
		 * 		trace(e.message); //=>instanceSoundFactory.addSound( sound1 ) failed, 'sound1' id sound is already use
		 *  }
		 *  catch( e : ClassCastException )
		 *  {
		 * 		trace(e.message); //=>instanceSoundFactory.addSound( badSound ) failed, 'badSound' class can't be found in specified SoundFactory application domain
		 *  }
		 * </pre>
		 * 
		 */
		public function addSound( id : String ) : void
		{
			if( !_bIsInitialized )	init();
			if( !isRegistered(id) )
			{				
				var clazz : Class;
				try
				{
					clazz = _appliDomain.getDefinition( id ) as Class;
				} catch ( e : Error )
				{
					PixlibDebug.ERROR(this+".addSound("+id+") failed, '" + id + "' class can't be found in specified SoundFactory application domain");
					throw new ClassCastException(this+".addSound("+id+") failed, '" + id + "' class can't be found in specified SoundFactory application domain") ;
				}
				
				var sound : Sound = new clazz() ;
				_mSounds.put( id, sound );
				_mSoundTransform.put( id, new SoundTransformInfo() );
			}
			else
			{
				PixlibDebug.ERROR(this+".addSound("+id+") failed, '" + id + "' id sound is already use");
				throw new IllegalArgumentException(this+".addSound("+id+") failed, '" + id + "' id sound is already use") ;				
			}
		}
		
		/**
		 * Adds a list of sounds. Add all sounds except for IllegalArgumentException and ClassCastException.
		 * 
		 * @param an array of sound's class identifier (in the library)
		 * 
		 * @throws if sound's class identifier is already use : an IllegalArgumentException instance is return
		 * @throws if sound's class not found in specified SoundFactory application domain : an ClassCastException instance is return
		 * 
		 * @see #getAllSounds()
		 * @see #clear()
		 * 
		 * @example
		 * <pre>
		 *   var _sf : SoundFactory = new SoundFactory();
		 *   var aSndList : Array = new Array("Sound1", "Sound2", "Sound2","BadSound"); // class identifiers in the library except "BadSound"
		 * 	 try
		 * 	 {
		 *   	_sf.addSounds( aSndList );
		 * 	 }
		 * 	 catch( e : IllegalArgumentException )
		 * 	 {
		 * 		trace(e.message); //=>instanceSoundFactory.addSounds( ["Sound1", "Sound2", "Sound2","BadSound"] ) failed, 'Sound2' id has been already added
		 * 	 }
		 * 	 catch( e : ClassCastException )
		 * 	 {
		 * 		trace(e.message); //=>instanceSoundFactory.addSounds( ["Sound1", "Sound2", "Sound2","BadSound"] ) failed, 'BadSound' class can't be found in specified SoundFactory application domain
		 * 	 }
		 * </pre>
		 */
		public function addSounds( a:Array ) : void
		{
			var l:int = a.length;

			while( -- l > -1 ) 
			{
				try
				{
					addSound(a[l]);
				} catch ( e : IllegalArgumentException )
				{
					e.message = this+".addSounds(" + a + ") failed, '" + a[l] + "' id has been already added";
					PixlibDebug.ERROR(e.message);	
					throw( e );
				} catch ( e : ClassCastException )
				{
					e.message = this+".addSounds(" + a + ") failed, '" + a[l] + "' class can't be found in specified SoundFactory application domain" ;
					PixlibDebug.ERROR(e.message);					
					throw( e );
				}
			}
		}
			
		/**
		 * Returns Sound instance stored under passed-in sound's class identifier.
		 * 
		 * @param sound's class identifier in the library
		 * 
		 * @return Sound instance. If no sound is found, a NullSound is returned.
		 * 
		 * @throws if sound's class identifier has not been used currently in your SoundFactory : a NoSuchElementException instance is return
		 * 
		 * @see #addSound()
		 * @see #removeSound()
		 * 
		 * @example
		 * <pre>
		 *   var _sf : SoundFactory = new SoundFactory();
		 *   
		 *	try
		 * 	{
		 *  	_sf.addSound("Sound1");
		 *   	_sf.addSound("Sound2");
		 *   	_sf.getSound("Sound3"); // not been added
		 *  {
		 * 	catch (e : NoSuchElementException)
		 *  {
		 * 		trace(e.message);//=> instanceSoundFactory.getSound(Sound3) : 'Sound3' doesn't exist
		 *  }
		 * </pre>
		 */
		public function getSound( id:String ) : Sound 
		{ 
			if (_bIsOn )
			{
				if ( isRegistered( id ) )
				{
					return _mSounds.get( id ) as Sound;
				}
				else
				{
					PixlibDebug.ERROR(this+".getSound("+id+") : '"+id+"' doesn't exist");					
					throw new NoSuchElementException(this+".getSound("+id+") : '"+id+"' doesn't exist") ;
				}
			}
			else
			{
				return new NullSound();
			}
		}
				
		/**
	 	 * Get all Sound instances stored under passed-in sound's class identifier.
	 	 * 
		 * @return Get all Sound instances stored under passed-in sound's class identifier.
		 * 
		 * @see #addSounds()
		 * @see #clear()
		 * 
		 * @example
		 * <pre>
		 *   var _sf : SoundFactory = new SoundFactory();
		 *   _sf.addSounds(new Array("sound2","sound3","sound4"));
		 *   _sf.addSound("sound1");
		 *   _sf.getAllSounds(); //=> ["sound2","sound4","sound1","sound3"] NO ORDER GUARANTED !
		 * </pre>
		 */
		public function getAllSounds() : Array
		{
			return _mSounds.getValues();
		}
		
		/**
		 * Removes Sound instance stored under passed-in sound's class identifier.
		 * 
		 * @param sound's class identifier in the library
		 * 
		 * @throws if sound's class identifier has not been used currently in your SoundFactory : a NoSuchElementException instance is return
		 * 
		 * @see #addSound()
		 * @see #getSound()
		 * 
		 * @example
		 * <pre>
		 *   var _sf : SoundFactory = new SoundFactory();
		 *   _sf.addSound("sound_1");
		 *   _sf.addSound("sound_2");
		 *   
		 *	try
		 * 	{
		 *   	var o : Sound = _sf.getSound("Sound3"); // "Sound3" doesn't exist in your factory, but in the library
		 *  {
		 * 	catch (e : NoSuchElementException)
		 *  {
		 * 		trace(e);//=> instanceSoundFactory.removeSound(Sound3) : 'Sound3' doesn't exist
		 *  }
		 * </pre>
		 */
		public function removeSound( id:String ) : void
		{
			if ( isRegistered( id ) )
			{
				var i : uint = _aChannelsSounds.length ;
				while ( -- i > - 1 )
				{
					if( ( _aChannelsSounds[i] as ChannelSoundInfo ).id == id)
					{
						(_aChannelsSounds[i] as ChannelSoundInfo).soundChannel.stop();
						_aChannelsSounds.splice( i,1 );
					}
				}

				i = _aResumeSounds.length ;
				while ( -- i > - 1 )
					if( ( _aResumeSounds[i] as ChannelSoundInfo ).id == id)
						_aResumeSounds.splice( i,1 );
			
				_mSounds.remove( id );	
				_mSoundTransform.remove( id );
			}
			else
			{
				PixlibDebug.ERROR(this+".removeSound("+id+") : '"+id+"' doesn't exist");					
				throw new NoSuchElementException(this+".removeSound("+id+") : '"+id+"' doesn't exist") ;
			}			
		}
			
		/**
		 * Stops all sounds, clears sounds lists and reset : you must reinitialise it after with @see #init().
		 */
		public function clear() : void
		{
			goOff();
			_mSounds.clear();
			_mSoundTransform.clear();
			_aResumeSounds = new TypedArray();			
			_appliDomain = null;			
			_bIsInitialized = false;
		}
		
			

	
	

		/**
		 * Toggles "playing" mode.
		 * 
		 * Uses @see #goOn() or @see #goOff() methods to switch "playing" mode.
		 */
		public function toggleOnOff() : void 
		{ 
			if ( _bIsOn )
			{
				goOff();
				
			} else 
			{
				goOn();
			}
		}
		
		/**
		 * Checks if "playing" mode is enable or not.
		 * @return true is "playing" mode is enable, either false
		 */
		public function isOn() : Boolean 
		{ 
			return _bIsOn; 
		}
		
		/**
		 * Turns "playing" mode on.
		 * Sounds are not automatically played : it's just the state.
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
			_aChannelsSounds = new TypedArray();	
		}


		/**
		 * Without argument : it return a Boolean to indicate if there is at least one sound is playing
		 * With argument : it return a Boolean to indicate if the id passed-in is playing
		 * 
		 * @param sound's class identifier in the library
		 * 
		 * @throws if sound's class identifier has not been used currently in your SoundFactory : a NoSuchElementException instance is return
		 * 
		 * @see #getActiveChannel()
		 * @see #playSound()
 		 * @see #playSoundLoop()
		 * @see #stopSound()
		 * @see #pause()
		 * @see #resume()
		 * 
		 * @example
		 * <pre>
		 *   var _sf : SoundFactory = new SoundFactory();
		 *   _sf.addSound("sound_1");
		 *   _sf.addSound("sound_2");
		 * 	 _sf.play("sound_2");
		 *   
		 *	try
		 * 	{
		 *   	_sf.isPlaying() // => true
		 * 		_sf.isPlaying("Sound3")// => generate a NoSuchElementException
		 *  {
		 * 	catch (e : NoSuchElementException)
		 *  {
		 * 		trace(e);//=> instanceSoundFactory.removeSound(Sound3) : 'Sound3' doesn't exist
		 *  }
		 * </pre>
		 * 
		 */
		public function isPlaying( id : String = null ) : Boolean
		{			
			if( id == null )
			{
				return ( _aChannelsSounds.length > 0 );
			}
			
			if ( isRegistered( id ) )	
			{
				var i : uint = _aChannelsSounds.length;

				while ( -- i > - 1 )
					if( ( _aChannelsSounds[i] as ChannelSoundInfo ).id == id) return true;
	
				return false;

			} else
			{
				PixlibDebug.ERROR(this+".isPlaying("+id+") : '"+id+"' doesn't exist");					
				throw new NoSuchElementException(this+".isPlaying("+id+") : '"+id+"' doesn't exist") ;
			}
		}
		
		/**
		 * Return an Array of all SoundChannel instances use by the id passed-in
		 *
		 * @param sound's class identifier in the library
		 * 
		 * @return an Array of all SoundChannel instances use by the id passed-in
		 * 
		 * @throws if sound's class identifier has not been used currently in your SoundFactory : a NoSuchElementException instance is return		 * 
		 * 
		 * @see #isPlaying()
		 * @see #playSound()
 		 * @see #playSoundLoop()
		 * @see #stopSound()
		 * @see #pause()
		 * @see #resume()
		 * 
		 * @example
		 *   var _sf : SoundFactory = new SoundFactory();
		 *   _sf.addSound("sound_1");
		 *   _sf.addSound("sound_2");
		 *   _sf.play("sound_2");	//SoundChannel1
		 *   _sf.playSoundLoop("sound_2");	//SoundChannel2
		 *   
		 *	try
		 * 	{
		 *   	_sf.getActiveChannel("sound_2") // => [SoundChannel2,SoundChannel1] inverse order
		 * 		_sf.getActiveChannel("Sound3") // => generate a NoSuchElementException
		 *  {
		 * 	catch (e : NoSuchElementException)
		 *  {
		 * 		trace(e);//=> instanceSoundFactory.removeSound(Sound3) : 'Sound3' doesn't exist
		 *  }
		 */
		public function getActiveChannel( id : String ) : Array
		{
			var a : Array = new Array();
			if ( isRegistered( id ) )	
			{
				var i : uint = _aChannelsSounds.length ;
				while ( -- i > - 1 )
				{
					if( ( _aChannelsSounds[i] as ChannelSoundInfo ).id == id)
					{
						a.push( ( _aChannelsSounds[i] as ChannelSoundInfo ).soundChannel );
					}
				}

				return a;
			}
			else
			{
				PixlibDebug.ERROR("SoundFactory.getPlaying("+id+") : '"+id+"' doesn't exist");					
				throw new NoSuchElementException("SoundFactory.getPlaying("+id+") : '"+id+"' doesn't exist") ;
			}				
		}
			

		
		/**
		 * Play a sound simply according to its Class identifier in the library : only if @see isOn() = true
		 * 
		 * @param Class identifier in the library
		 * 
 		 * @see #playSoundLoop()
		 * @see #isPlaying()
		 * @see #getActiveChannel()
		 * @see #stopSound()
		 * @see #pause()
		 * @see #resume()
		 */
		public function playSound( id : String ) : void
		{
			if( _bIsOn )
			{
				var soundChannel : SoundChannel =  getSound( id ).play( 0, 0, (_mSoundTransform.get(id) as SoundTransformInfo).getSoundTransform() );
				var csi : ChannelSoundInfo = new ChannelSoundInfo(id, soundChannel, false);
				_aChannelsSounds.push( csi );
			}
		}
		
		/**
		 * Play a sound in loop ( uint.MAX_VALUE times ) according to its Class identifier in the library : only if @see #isOn() = true
		 * 
		 * @param Class identifier in the library
		 * 
 		 * @see #playSound()
		 * @see #isPlaying()
		 * @see #getActiveChannel()
		 * @see #stopSound()
		 * @see #pause()
		 * @see #resume()
		 */		
		public function playSoundLoop( id:String ) : void
		{
			if( _bIsOn )
			{
				var soundChannel : SoundChannel =  getSound( id ).play( 0, int.MAX_VALUE, (_mSoundTransform.get(id) as SoundTransformInfo).getSoundTransform() );
				var csi : ChannelSoundInfo = new ChannelSoundInfo(id, soundChannel, true);
				_aChannelsSounds.push( csi );			
			}
		}
		
	
		/**
		 *	Stop all channel for a sound according to its Class identifier in the library : only if @see isOn() = true
		 * 
		 * @param Class identifier in the library
		 * 
		 * @throws if sound's class identifier has not been used currently in your SoundFactory : a NoSuchElementException instance is return
		 * 
 		 * @see #playSound()
 		 * @see #playSoundLoop()
		 * @see #isPlaying()
		 * @see #getActiveChannel()
		 * @see #pause()
		 * @see #resume()
		 */			
		public function stopSound( id:String ) : void
		{
			if( _bIsOn )
			{
				if ( isRegistered( id ) )
				{				
					var i : uint = _aChannelsSounds.length ;
					while ( -- i > - 1 )
					{
						if( ( _aChannelsSounds[i] as ChannelSoundInfo ).id == id)
						{
							(_aChannelsSounds[i] as ChannelSoundInfo).soundChannel.stop();
							_aChannelsSounds.splice( i,1 );
						}
					}
				}
				else
				{
					PixlibDebug.ERROR(this+".stopSound("+id+") : '"+id+"' doesn't exist");					
					throw new NoSuchElementException(this+".stopSound("+id+") : '"+id+"' doesn't exist") ;					
				}
			}
		}
		
		/**
		 * Pause all sounds
		 */
		 public function pause () : void
		 {
			var i : uint = _aChannelsSounds.length ;

			while ( -- i > - 1 )
			{
				var id : String = (_aChannelsSounds[i] as ChannelSoundInfo).id ;
				var position : int = (_aChannelsSounds[i] as ChannelSoundInfo).soundChannel.position ;
				var loop : Boolean = (_aChannelsSounds[i] as ChannelSoundInfo).loop ;
				var RSI : ResumeSoundInfo = new ResumeSoundInfo( id, position, loop ) ;
				_aResumeSounds.push( RSI ) ;
			}
			
			 goOff();
		 }		

		/**
		 * Resume all sounds stopped with pause()
		 */
		 public function resume () : void 
		 {
		 	goOn();
			var i : uint = _aResumeSounds.length ;

			while ( -- i > - 1 )
			{
				var soundChannel : SoundChannel;
				var csi : ChannelSoundInfo;
				var rsi : ResumeSoundInfo = _aResumeSounds[i] as ResumeSoundInfo;
				
				var id : String = rsi.id;
				var position : int = rsi.position;
				var loop : Boolean = rsi.loop;

				soundChannel = loop ?
					getSound( id ).play( position, uint.MAX_VALUE, (_mSoundTransform.get(id) as SoundTransformInfo).getSoundTransform() )
					: getSound( id ).play( position, 0, (_mSoundTransform.get(id) as SoundTransformInfo).getSoundTransform() );

				
				csi = new ChannelSoundInfo(id, soundChannel, true);
				_aChannelsSounds.push( csi );	

			}
	 	
		 	_aResumeSounds = new TypedArray();	
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
import flash.media.Sound;
import flash.net.URLRequest;
import flash.media.SoundLoaderContext;

internal class SoundTransformInfo
{

	private var _sd		: SoundTransform;
	private var _gain 	: Number;
	
	public function SoundTransformInfo( gain : Number =1 )
	{
		_sd = new SoundTransform();
		_gain = gain;
	}
	
	public function getSoundTransform() : SoundTransform
	{
		return _sd;	
	}
	
	public function getGain() : Number
	{
		return _gain;
	}
	
	public function setGain( n : Number ) : void
	{
		_gain = n;
	}
	
	public function getVolume() : Number
	{
		return _sd.volume;
	}

	public function setVolume( n : Number) : void
	{
		_sd.volume = n;
	}
	
	public function getPan() : Number
	{
		return _sd.pan;
	}	

	public function setPan( n : Number ) : void
	{
		_sd.pan = n;
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

internal class NullSound 
	extends Sound
{
	public override function play( startTime:Number = 0, loops:int = 0, sndTransform:SoundTransform = null ) : SoundChannel
	{
		// do nothing
		return null;
	}
	
	public override function load( stream:URLRequest, context:SoundLoaderContext = null ) : void
	{
		// do nothing
	}
}