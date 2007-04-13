package com.bourre.media.sound
{
	import flexunit.framework.TestCase;
	
	import com.bourre.TestSettings;
	import com.bourre.load.GraphicLoader;
	import com.bourre.load.GraphicLoaderEvent;		

	import flash.utils.Timer;	
	import flash.events.TimerEvent;
	import flash.net.URLRequest;	
	import flash.media.Sound;
	import flash.system.ApplicationDomain;
	import com.bourre.load.strategy.LoaderStrategy;
	import flash.display.Loader;
	
	
	public class SoundFactoryTest extends TestCase
	{
		[Embed(source="./../../../../../testBin/SoundFactory.swf", mimeType="application/octet-stream")]
		private static var SWFBytes : Class;	
			
		private static var _sF 			: SoundFactory = new SoundFactory();
		private static var _loader		: Loader;
		private static var _apliDomain	: ApplicationDomain;
		private static var _ms1			: Number;
		private static var _ms2			: Number;		
		
		SoundFactoryTest._loader = new Loader();
		SoundFactoryTest._loader.loadBytes( new SoundFactoryTest.SWFBytes() );
		SoundFactoryTest._apliDomain = SoundFactoryTest._loader.contentLoaderInfo.applicationDomain;
		
		public override function setUp() : void
		{	

		}
		
		public function testConstruct() : void
		{
			assertNotNull( "SoundFactory constructor returns null", _sF );
			assertTrue( "SoundFactory.isOn() returns false", _sF.isOn() );			
		}
		
		public function testAddSoundGetSoundRemoveSound() : void
		{	
			_getApplicationDomain();
			_sF.init( _apliDomain );
			_sF.addSound( "testSound1" );
			_sF.addSound( "testSound2" );

			assertEquals( "_sF.addSound( 'testSound1' ) => _sF.getSound('testSound1') : return a sound unexpected",_sF.getSound("testSound1").length, _ms1  );
			assertEquals( "_sF.addSound( 'testSound2' ) => _sF.getSound('testSound2') : return a sound unexpected",_sF.getSound("testSound2").length, _ms2  );
			assertEquals( "_sF.addSound( 'testSound1' ) + _sF.addSound( 'testSound1' ) => _sF.getAllSounds().length return wrong number",_sF.getAllSounds().length, 2 );

			_sF.removeSound( "testSound1" );	
			var bIsCaught : Boolean = false;	
			try
			{
				_sF.getSound("testSound1");		
			}
			catch( e : Error )
			{
				if( e.toString() == "id sound unexpected" );
					bIsCaught = true;
			}
			assertTrue( "_sF.getSound('testSound1') return a sound while _sF.removeSound( 'testSound1' )", bIsCaught );	
			assertEquals( "_sF.addSound( 'testSound1' ) + _sF.addSound( 'testSound2' ) + _sF.removeSound( 'testSound1' ) => _sF.getSound('testSound2') not return sound expected",_sF.getSound("testSound2").length, _ms2  );			
			assertEquals( "_sF.addSound( 'testSound1' ) + _sF.addSound( 'testSound2' ) + _sF.removeSound( 'testSound1' ) => _sF.getAllSounds().length return wrong number",_sF.getAllSounds().length,1 );									
		}
		
		public function testAddSoundsGetAllSoundClear() : void
		{
			_getApplicationDomain()
			_sF.init( _apliDomain );
			_sF.addSounds( new Array("testSound1","testSound2") );
		
			assertEquals( "_sF.addSounds( new Array('testSound1','testSound2') ) => _sF.getSound('testSound1') return a sound unexpected",_sF.getSound("testSound1").length, _ms1  );			
			assertEquals( "_sF.addSounds( new Array('testSound1','testSound2') ) => _sF.getSound('testSound2') return a sound unexpected",_sF.getSound("testSound2").length, _ms2  );			
			assertEquals( "_sF.addSounds( new Array('testSound1','testSound2') ) => _sF.getAllSounds().length return wrong number",_sF.getAllSounds().length, 2 );	
			
			_sF.clear();
			assertEquals( "_sF.addSounds( new Array('testSound1','testSound2') ) + _sF.clear() => _sF.getAllSounds().length != 0",_sF.getAllSounds().length, 0  );			
			assertFalse("_sF.isOn() = true while _sF.clear()",_sF.isOn() );

			var bIsCaught : Boolean = false;	
			if ( _sF.getSound("testSound1") == null )
				bIsCaught = true;
			assertTrue( "sF.getSound('testSound1') return a sound while _sF.clear() before",bIsCaught );				
		}
		
		public function testToggleOnOffGoOnGoOffIsOn() : void
		{
			assertTrue( "_sF = new SoundFactory() => but _sF.isOn() = false", _sF.isOn() );
			_sF.goOff();
			assertFalse( "_sF.goOff() => but _sF.isOn() = true", _sF.isOn() );
			_sF.goOn();
			assertTrue( "_sF.goOn() => but _sF.isOn() = true", _sF.isOn() );
			_sF.toggleOnOff();
			assertFalse( " _sF.isOn() = true => _sF.toggleOnOff() => but _sF.isOn() = true", _sF.isOn() );
			_sF.toggleOnOff();			
			assertTrue( " _sF.isOn() = false => _sF.toggleOnOff() => but _sF.isOn() = false", _sF.isOn() );			
		}
		
		
		public function _getApplicationDomain() : void
		{
			var clazz : Class = _apliDomain.getDefinition( "testSound1" ) as Class;
			var sound : Sound = new clazz() ;			
			_ms1 = sound.length;				
			
			clazz  = _apliDomain.getDefinition( "testSound2" ) as Class;
			sound = new clazz() ;			
			_ms2 = sound.length ;										
		}		


	}
}