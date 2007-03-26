package com.bourre.load.strategy
{
	import flexunit.framework.TestCase;

	import com.bourre.TestSettings;	
	import com.bourre.commands.ASyncCommandListener;
	import com.bourre.load.*;
	import com.bourre.load.strategy.*;
	
	import com.bourre.log.PixlibDebug;
	import com.bourre.log.Logger;
	import com.bourre.utils.FlashInspectorLayout;		
	
	import flash.events.Event;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.net.URLRequest;	
		
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

	public class URLLoaderStrategyTest
		extends TestCase
		implements Loader
	{
		
		private var _URLls 			: URLLoaderStrategy;	
		private var _urlRqt 		: URLRequest;
		private var _testBinPath	: String;
		
		private var _bOnStart 		: Boolean;
		private var _bOnProgress	: Boolean;
		private var _bOnComplete	: Boolean;
		private var	_bOnError		: Boolean;

		public override function setUp() : void
		{
			Logger.getInstance().addLogListener( FlashInspectorLayout.getInstance(), PixlibDebug.CHANNEL );
			
			_URLls = new URLLoaderStrategy();
			_urlRqt = new URLRequest();			
			_testBinPath = TestSettings.getInstance().testBinPath;
			
			_bOnStart 		= false;
	    	_bOnProgress    = false;	
	    	_bOnComplete 	= false;	
	    	_bOnError 		= false;
		}
		
		public function testConstruct() : void
		{
			assertNotNull( "URLLoaderStrategy constructor returns null", _URLls );
			assertEquals("URLLoaderStrategy.getBytesLoaded() doesn't be at 0 before the first loading", _URLls.getBytesLoaded(), 0);
			assertEquals("URLLoaderStrategy.getBytesTotal() doesn't be at 0 before the first loading", _URLls.getBytesTotal(), 0);
			assertTrue("URLLoaderStrategy.getBytesLoaded() doesn't return a type 'uint'", _URLls.getBytesLoaded() is uint);
			assertTrue("URLLoaderStrategy.getBytesTotal() doesn't return a type 'uint'", _URLls.getBytesTotal() is uint);							
		}	
		
		public function testOnStart() : void
		{
			_urlRqt.url = _testBinPath+"/URLLoaderStrategyTest.xml";
			_URLls.setOwner(this);
			_URLls.load( _urlRqt );
			
			var t : Timer = new Timer( 100, 1 );
			t.addEventListener( TimerEvent.TIMER, addAsync( _onStart, 100 ) );
			t.start();			
		}
		public function testOnProgress() : void
		{
			_urlRqt.url = _testBinPath+"/URLLoaderStrategyTest.xml";
			_URLls.setOwner(this);
			_URLls.load( _urlRqt );
						
			var t : Timer = new Timer( 100, 1 );
			t.addEventListener( TimerEvent.TIMER, addAsync( _onProgress, 100 ) );
			t.start();				
		}	
	
		public function testOnComplete() : void
		{
			_urlRqt.url = _testBinPath+"/URLLoaderStrategyTest.xml";
			_URLls.setOwner(this);
			_URLls.load( _urlRqt );
						
			var t : Timer = new Timer( 1000, 1 );
			t.addEventListener( TimerEvent.TIMER, addAsync( _onComplete, 1000 ) );
			t.start();				
		}			

		public function testOnError() : void
		{
			_urlRqt.url =  "../URLLoaderStrategyTest" ;
			_URLls.setOwner(this);
			_URLls.load( _urlRqt );

			var t : Timer = new Timer( 100, 1 );
			t.addEventListener( TimerEvent.TIMER, addAsync( _onError, 100 ) );
			t.start();			
		}
		
		private function testRelease():void
		{
			_urlRqt.url = _testBinPath+"/URLLoaderStrategyTest.xml";
			_URLls.load( _urlRqt );
			_URLls.release();

			var t : Timer = new Timer( 100, 1 );			
			t.addEventListener( TimerEvent.TIMER, addAsync( _onLoadWithLoadStrategyRelease, 100 ) );			
			t.start();
		}
				
		
		private function _onStart( event : TimerEvent ) : void
		{
			assertTrue( "URLLoaderStrategy didn't call fireOnLoadStartEvent() on its _owner", _bOnStart );
		}
		
		private function _onProgress( event : TimerEvent ) : void
		{
			assertTrue( "URLLoaderStrategy didn't call fireOnLoadProgressEvent() on its _owner ", _bOnProgress );
		}		

		private function _onComplete( event : TimerEvent ) : void
		{
			assertTrue( "URLLoaderStrategy didn't call setContent( _loader.content ) on its _owner", _bOnComplete );	
		}				
			
		private function _onError( event : TimerEvent ) : void
		{
			assertTrue( "URLLoaderStrategy didn't call fireOnLoadErrorEvent() on its _owner", _bOnError );
		}		
		
		private function _onLoadWithLoadStrategyRelease( event : TimerEvent ) : void
		{
			assertFalse( "URLLoaderStrategy release() but can be load again", _bOnStart );
		}	

		

	
		// méthodes implémentés (Loader)
		// utiles pour les tests				    
	    public function fireOnLoadStartEvent() : void
	    {
	    	_bOnStart = true;	    		    	
	    }
		public function fireOnLoadProgressEvent() : void
		{
			_bOnProgress = true ;
		}
	    public function fireOnLoadInitEvent() : void
	    {    
			_bOnComplete = true;   	
	    }
		public function fireOnLoadErrorEvent() : void
		{ 				
			_bOnError = true;		
		}

		
		
		// inutiles pour les tests mais obligatiores ("implements Loader")
		public function setContent( content : Object ) : void
		{
		}		
		
		public function load( url : URLRequest = null  ) : void
		{
		}
		
		public function getURL() : URLRequest
		{
			return _urlRqt;
		}
		
		public function setURL( url : URLRequest ) : void
		{
		}
		
		public function prefixURL( prefixURL : String ) : void
		{	
		}
		
		public function getName() : String
		{
			return "String";
		}
		
		public function setName( name : String ) : void
		{	
		}
		
		public function getPerCent() : Number
		{
			return 0;
		}
		
		public function addListener( listener : LoaderListener ) : Boolean
		{
			return true ;
		}
		
		
		public function removeListener( listener : LoaderListener ) : Boolean
		{
			return true ;
		}
		
		public function addEventListener( type : String, listener : Object, ...rest ) : Boolean
		{
			return true;
		}
		public function removeEventListener( type : String, listener : Object ) : Boolean
		{
			return true;
		}
		
		public function setAntiCache( b : Boolean ) : void
		{
		}
		
		// méthodes implémentés (ASyncCommandListener)	
		public function addASyncCommandListener( listener : ASyncCommandListener ) : Boolean
		{
			return true;
		}
		
		public function removeASyncCommandListener( listener : ASyncCommandListener ) : Boolean
		{		
			return true;			
		}

		public function fireCommandEndEvent() : void
		{	
		}
		
		// méthodes implémentés (Command)	
		public function execute( e : Event = null ) : void
		{
		}		
				
	}
}