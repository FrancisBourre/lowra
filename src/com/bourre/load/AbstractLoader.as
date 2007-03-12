package com.bourre.load
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
	 * @author Francis Bourre
	 * @version 1.0
	 */

	import com.bourre.commands.*;
	import com.bourre.log.*;
	import com.bourre.error.ProtectedConstructorException;
	import com.bourre.events.EventBroadcaster;
	
	import flash.events.Event;
	import flash.utils.getQualifiedClassName;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.events.ProgressEvent;
	import flash.utils.getTimer;
	import flash.display.DisplayObject;

	public class AbstractLoader 
		implements Loader
	{
		private var _oEB : EventBroadcaster;
		private var _sName : String;
		private var _nTimeOut : Number;
		private var _sURL : String;
		private var _bAntiCache : Boolean;
		private var _sPrefixURL : String;
		
		private var _oLoader : URLLoader;
		private var _oContent : DisplayObject
		private var _nLastBytesLoaded : Number;
		private var _nTime : int;

		public function AbstractLoader()
		{
			var qualifiedClassName : String = getQualifiedClassName( this );
			if ( qualifiedClassName == "com.bourre.loading::AbstractLoader" )
				throw new ProtectedConstructorException( "Instantiation failed. " + qualifiedClassName 
				+ " is an abstract class, you must extend it before using it" );
				
			_oEB = new EventBroadcaster( this );
			_nTimeOut = 10000;
			_bAntiCache = false;
			_sPrefixURL = "";
		}

		public function execute( e : Event = null ) : void
		{
			load();
		}
		
		public function load( url : String = null ) : void
		{
			if ( url ) setURL( url );

			if ( getURL() )
			{
				_nLastBytesLoaded = 0;
				_nTime = getTimer();
				
				//CommandManagerMS.getInstance().remove(_dOnLoadProgress);
				//CommandManagerMS.getInstance().push( _dOnLoadProgress, 50);
				
				var request : URLRequest = new URLRequest( getURL() ) ;
			
				_oLoader = new URLLoader();
				_oLoader.addEventListener( ProgressEvent.PROGRESS, _onProgress );
				_oLoader.addEventListener( Event.COMPLETE, _onComplete );
				_oLoader.load( request ) ;
				
			} else
			{
				PixlibDebug.ERROR( this + ".load() can't retrieve file url." );
			}
		}
		
		public function onLoadInit() : void
		{
			fireEventType( LoaderEvent.onLoadProgressEVENT );
			fireEventType( LoaderEvent.onLoadInitEVENT );
		}
		
		public function getBytesLoaded() : uint
		{
			return _oLoader.bytesLoaded;
		}
		
		public function getBytesTotal() : uint
		{
			return _oLoader.bytesTotal;
		}

		public function getPerCent() : Number
		{
			var n : Number = Math.min( 100, Math.ceil( getBytesLoaded() / ( getBytesTotal() / 100 ) ) );
			return ( isNaN(n) ) ? 0 : n;
		}

		public function getURL() : String
		{
			return _bAntiCache ? _sPrefixURL + _sURL + "?nocache=" + _getStringTimeStamp() : _sPrefixURL + _sURL;
		}

		public function setURL( sURL : String ) : void
		{
			_sURL = sURL;
		}
		
		final public function addASyncCommandListener( listener : ASyncCommandListener ) : void
		{
			_oEB.addEventListener( ASyncCommandEvent.onCommandEndEVENT, listener );
		}

		final public function removeASyncCommandListener( listener : ASyncCommandListener ) : void
		{
			_oEB.removeEventListener( ASyncCommandEvent.onCommandEndEVENT, listener );
		}

		public function addListener( listener : LoaderListener ) : void
		{
			_oEB.addListener( listener );
		}

		public function removeListener( listener : LoaderListener ) : void
		{
			_oEB.removeListener( listener );
		}
		
		public function addEventListener( type : String, listener : Object, ...rest ) : void
		{
			_oEB.addEventListener.apply( _oEB, [type, listener, rest] );
		}
		
		public function removeEventListener( type : String, listener : Object ) : void
		{
			_oEB.removeEventListener( type, listener );
		}
		
		public function fireEventType( type : String ) : void
		{
			_oEB.broadcastEvent( getLoaderEvent( type ) );
		}

		public function getName() : String
		{
			return _sName;
		}

		public function setName( sName : String ) : void
		{
			_sName = sName;
		}

		public function setAntiCache( b : Boolean ) : void
		{
			_bAntiCache = b;
		}
		
		public function isAntiCache() : Boolean
		{
			return _bAntiCache;
		}

		public function prefixURL( sURL : String ) : void
		{
			_sPrefixURL = sURL;
		}

		public function getTimeOut() : Number
		{
			return _nTimeOut;
		}

		public function setTimeOut( n : Number ) : void
		{
			_nTimeOut = Math.max( 1000, n );
		}
		
		public function release() : void
		{
			_oLoader.close();
		}
		
		public function getContent() : DisplayObject
		{
			return _oContent;
		}
		
		public function setContent( o : DisplayObject ) : void
		{
			_oContent = o;
		}
		
		public function fireCommandEndEvent() : void
		{
			
		}

		/**
		 * Returns the string representation of this instance.
		 * @return the string representation of this instance
		 */
		public function toString() : String 
		{
			return PixlibStringifier.stringify( this );
		}

		//
		virtual protected function getLoaderEvent( type : String ) : LoaderEvent
		{
			return new LoaderEvent( type, this );
		}
		
		private function _getStringTimeStamp() : String
		{
			var d : Date = new Date();
			return String( d.getTime() );
		}
		
		private function _onProgress( event : ProgressEvent ) : void
		{
			trace("progressHandler loaded:" + event.bytesLoaded + " total: " + event.bytesTotal);
		}
		
		private function _onComplete( event : Event ) : void 
		{
            trace("completeHandler: " + _oLoader.data);
    
            //var vars:URLVariables = new URLVariables(loader.data);
            //trace("The answer is " + vars.answer);
        }
        
        private function _checkTimeOut( nLastBytesLoaded : Number, nTime : Number ) : void 
		{
			if ( nLastBytesLoaded != _nLastBytesLoaded)
			{
				_nLastBytesLoaded = nLastBytesLoaded;
				_nTime = nTime;
			}
			else if ( nTime - _nTime  > _nTimeOut)
			{
				fireEventType( LoaderEvent.onLoadTimeOutEVENT );
				release();
				PixlibDebug.ERROR( this + " load timeout with url : '" + getURL() + "'." );
			}
		}
	}
}