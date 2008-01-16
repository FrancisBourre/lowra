package com.bourre.load
{
	
	import flexunit.framework.TestCase;
	import flash.net.URLRequest;
	import com.bourre.TestSettings;
	import com.bourre.log.PixlibDebug;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import com.bourre.commands.*;

	import flash.events.Event;	

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
	 * @author Steve Lombard
	 * @version 1.0
	 */
	 
	// TODO décommenter le test : testFireOnLoadTimeOutEVENT quand AbstractLoader l'aura implémenter
	// TODO décommenter le test : testAddASyncCommandListener quand AbstractLoader l'aura implémenter	 
	
	public class AbstractLoaderTest 
		extends TestCase
		implements LoaderListener, ASyncCommandListener
	{
		private var _l : MockAbstractLoader;
		
		private var _bOnStart 		: Boolean;
		private var _bOnProgress	: Boolean;
		private var _bOnInit		: Boolean;
		private var	_bOnError		: Boolean;	
		private var _bOnTimeOut		: Boolean;

		public override function setUp() : void
		{
			_l = new MockAbstractLoader();
			
			_bOnStart 		= false;
	    	_bOnProgress    = false;	
	    	_bOnInit		= false;	
	    	_bOnError 		= false;	
			_bOnTimeOut	    = false;
		}

		public function testConstruct() : void
		{
			assertNotNull( "MockLoader constructor returns null", _l );
			assertTrue( "MockLoader constructor returns null", _l is AbstractLoader);
			assertEquals("AbstractLoader.getBytesLoaded() doesn't be at 0 before the first loading", _l.getBytesLoaded(), 0);
			assertEquals("AbstractLoader.getBytesTotal() doesn't be at 0 before the first loading", _l.getBytesTotal(), 0);
			assertTrue("AbstractLoader.getBytesLoaded() doesn't return a 'uint' type", _l.getBytesLoaded() is uint);
			assertTrue("AbstractLoader.getBytesTotal() doesn't return a 'uint' type", _l.getBytesTotal() is uint);
			assertEquals("AbstractLoader.getPerCent() doesn't be at 0 before the first loading", _l.getPerCent(), 0);
			assertTrue("AbstractLoader.getPerCent() doesn't return a 'Number' type", _l.getPerCent() is Number);						
		}

		public function testGetSetURL() : void
		{
			var url : URLRequest = new URLRequest("http://www.tweenpix.net");
			_l.setURL( url );
			assertEquals( "AbstractLoader.getURL doesn't return value passed to AbstractLoader.setURL", url.url, _l.getURL().url );
		}

		public function testGetSetTimeOut() : void
		{
			var time : Number = 1000;
			_l.setTimeOut( time );
			assertEquals( "AbstractLoader.getTimeOut doesn't return value passed to AbstractLoader.setTimeOut", time, _l.getTimeOut() );
		}

		public function testGetSetAntiCache() : void
		{
			var b : Boolean = true;
			_l.setAntiCache( b );
			assertEquals( "AbstractLoader.isAntiCache doesn't return value passed to AbstractLoader.setAntiCache", b, _l.isAntiCache() );
		}

		public function testPrefixURL() : void
		{
			var prefix : String = "http://www.tweenpix.net/";
			var url : URLRequest = new URLRequest( "blog" );
			
			_l.setURL( url );
			_l.prefixURL( prefix );
			assertEquals( "AbstractLoader.getURL doesn't return value passed to AbstractLoader.setURL and AbstractLoader.prefixURL", prefix+url.url, _l.getURL().url);
		}
		
		public function testGetSetName() : void
		{
			var name : String = "MockAbstractLoader 4 AbstractLoaderTest";
			_l.setName(name)
			assertEquals( "AbstractLoader.getName doesn't return value passed to AbstractLoader.setName", name, _l.getName() );
		}
		
		public function testFireOnLoadStartEvent() : void
		{
			var url : URLRequest = new URLRequest( TestSettings.getInstance().testBinPath+"/URLLoaderStrategyTest.xml" );
			_l.load( url );	
			//_l.addEventListener( LoaderEvent.onLoadStartEVENT, this);
			_l.addListener(this);
			var t : Timer = new Timer( 100, 1 );
			t.addEventListener( TimerEvent.TIMER, addAsync( _onLoadStart, 100 ) );
			t.start();	
		}
		
		public function testFireOnLoadProgressEvent() : void
		{
			var url : URLRequest = new URLRequest( TestSettings.getInstance().testBinPath+"/URLLoaderStrategyTest.xml" );
			_l.load( url );	
			_l.addEventListener( LoaderEvent.onLoadProgressEVENT, this);
			var t : Timer = new Timer( 100, 1 );
			t.addEventListener( TimerEvent.TIMER, addAsync( _onLoadProgress, 100 ) );
			t.start();			
		}
		
		public function testFireOnLoadInitEvent() : void
		{
			var url : URLRequest = new URLRequest( TestSettings.getInstance().testBinPath+"/URLLoaderStrategyTest.xml" );
			_l.load( url );	
			_l.addEventListener( LoaderEvent.onLoadInitEVENT, this);
			var t : Timer = new Timer( 100, 1 );
			t.addEventListener( TimerEvent.TIMER, addAsync( _onLoadInit, 100 ) );
			t.start();			
		}
		/*
		public function testFireOnLoadTimeOutEVENT() : void
		{
			var url : URLRequest = new URLRequest( TestSettings.getInstance().testBinPath+"/URLLoaderStrategyTest.xml" );
			_l.load( url );	
			_l.setTimeOut( 10 );
			_l.addEventListener( LoaderEvent.onLoadTimeOutEVENT, this);
			var t : Timer = new Timer( 100, 1 );
			t.addEventListener( TimerEvent.TIMER, addAsync( _onLoadTimeOut, 100 ) );
			t.start();				
		}			
		*/
		public function testFireOnLoadErrorEvent() : void
		{
			var url : URLRequest = new URLRequest( TestSettings.getInstance().testBinPath+"/URLLoaderStrategyTest" );
			_l.load( url );	
			_l.addEventListener( LoaderEvent.onLoadErrorEVENT, this);
			var t : Timer = new Timer( 100, 1 );
			t.addEventListener( TimerEvent.TIMER, addAsync( _onLoadError, 100 ) );
			t.start();				
		}	
		
		// for async test
		private function _onLoadStart(event : TimerEvent) :void
		{
			_l.removeListener( this);
			assertTrue( "AbstractLoader.fireOnLoadStartEvent didn't called or new LoaderEvent( 'LoaderEvent.onLoadStartEVENT', this ) didn't broadcasted", _bOnStart );
		}
		
		private function _onLoadProgress(event : TimerEvent) :void
		{
			_l.removeEventListener(LoaderEvent.onLoadProgressEVENT, this);
			assertTrue( "AbstractLoader.fireOnLoadProgressEvent didn't called or new LoaderEvent( 'LoaderEvent.onLoadProgressEVENT', this ) didn't broadcasted", _bOnProgress );
		}	
		
		private function _onLoadInit(event : TimerEvent) :void
		{
			_l.removeEventListener(LoaderEvent.onLoadInitEVENT, this);			
			assertTrue( "AbstractLoader.fireOnLoadInitEvent didn't called or new LoaderEvent( 'LoaderEvent.onLoadInitEVENT', this ) didn't broadcasted", _bOnInit );
		}
		
		private function _onLoadTimeOut(event : TimerEvent) : void
		{
			_l.removeEventListener(LoaderEvent.onLoadTimeOutEVENT, this);	
			assertTrue( "AbstractLoader : new LoaderEvent( 'LoaderEvent.onLoadTimeOutEVENT', this ) didn't broadcasted", _bOnTimeOut );			
		}	
		
		private function _onLoadError(event : TimerEvent) :void
		{
			_l.removeEventListener(LoaderEvent.onLoadErrorEVENT, this);				
			assertTrue( "AbstractLoader.fireOnLoadErrorEvent didn't called or new LoaderEvent( 'LoaderEvent.onLoadErrorEVENT', this ) didn't broadcasted", _bOnError );
		}
				
		
		// implemented LoaderListener fonction
		public function onLoadStart( e : LoaderEvent ) :void
		{
			_bOnStart = true;
		}
		public function onLoadInit( e : LoaderEvent ) : void
		{
			_bOnInit = true;
		}
		public function onLoadProgress( e : LoaderEvent ) : void
		{
			_bOnProgress = true;
		}
		public function onLoadTimeOut( e : LoaderEvent ) : void
		{
			_bOnTimeOut = true;
		}
		public function onLoadError( e : LoaderEvent ) : void
		{
			_bOnError = true;
		}
		
		
		/*
		public function testAddASyncCommandListener () : void
		{
			var url : URLRequest = new URLRequest( TestSettings.getInstance().testBinPath+"/URLLoaderStrategyTest.xml" );
			_l.addASyncCommandListener( this );			
			_l.load( url );
		}
		*/
		
		public function onCommandEnd( e : Event ) : void
		{
			PixlibDebug.FATAL(e+"AbstractLoaderTest onCommandEnd");
		}
		
	}	
	
}