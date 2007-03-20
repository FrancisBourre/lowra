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
	import com.bourre.load.strategy.LoadStrategy;

	import flash.display.DisplayObject;
	import flash.events.*;
	import flash.net.*;
	import flash.utils.*;

	public class AbstractLoader 
		implements com.bourre.load.Loader
	{
		protected var abstractLoaderConstructorAccess : AbstractLoaderConstructorAccess = new AbstractLoaderConstructorAccess();

		private var _oEB : EventBroadcaster;
		private var _sName : String;
		private var _nTimeOut : Number;
		private var _oURL : URLRequest;
		private var _bAntiCache : Boolean;
		private var _sPrefixURL : String;
		
		private var _loadStrategy : LoadStrategy;
		private var _oContent : Object
		private var _nLastBytesLoaded : Number;
		private var _nTime : int;

		public function AbstractLoader( access : AbstractLoaderConstructorAccess, strategy : LoadStrategy = null )
		{
			_loadStrategy = strategy;
			_loadStrategy.setOwner( this );

			_oEB = new EventBroadcaster( this );
			_nTimeOut = 10000;
			_bAntiCache = false;
			_sPrefixURL = "";
		}

		public function execute( e : Event = null ) : void
		{
			load();
		}
		
		public function load( url : URLRequest = null ) : void
		{
			if ( url ) setURL( url );

			if ( getURL() )
			{
				_nLastBytesLoaded = 0;
				_nTime = getTimer();
				_loadStrategy.load( getURL() );

			} else
			{
				PixlibDebug.ERROR( this + ".load() can't retrieve file url." );
			}
		}
		
		protected function onLoadInit() : void
		{
			fireEventType( LoaderEvent.onLoadProgressEVENT );
			fireEventType( LoaderEvent.onLoadInitEVENT );
		}
		
		final public function getBytesLoaded() : uint
		{
			return _loadStrategy.getBytesLoaded();
		}
		
		final public function getBytesTotal() : uint
		{
			return _loadStrategy.getBytesTotal();
		}

		final public function getPerCent() : Number
		{
			var n : Number = Math.min( 100, Math.ceil( getBytesLoaded() / ( getBytesTotal() / 100 ) ) );
			return ( isNaN(n) ) ? 0 : n;
		}

		public function getURL() : URLRequest
		{
			return _bAntiCache ? new URLRequest( _sPrefixURL + _oURL.url + "?nocache=" + _getStringTimeStamp() ) : new URLRequest( _sPrefixURL + _oURL.url );
		}

		public function setURL( url : URLRequest ) : void
		{
			_oURL = url;
		}
		
		public function addASyncCommandListener( listener : ASyncCommandListener ) : Boolean
		{
			return _oEB.addEventListener( ASyncCommandEvent.onCommandEndEVENT, listener );
		}

		public function removeASyncCommandListener( listener : ASyncCommandListener ) : Boolean
		{
			return _oEB.removeEventListener( ASyncCommandEvent.onCommandEndEVENT, listener );
		}

		public function addListener( listener : LoaderListener ) : Boolean
		{
			return _oEB.addListener( listener );
		}

		public function removeListener( listener : LoaderListener ) : Boolean
		{
			return _oEB.removeListener( listener );
		}
		
		public function addEventListener( type : String, listener : Object, ...rest ) : Boolean
		{
			return _oEB.addEventListener.apply( _oEB, [type, listener, rest] );
		}
		
		public function removeEventListener( type : String, listener : Object ) : Boolean
		{
			return _oEB.removeEventListener( type, listener );
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

		final public function getTimeOut() : Number
		{
			return _nTimeOut;
		}

		final public function setTimeOut( n : Number ) : void
		{
			_nTimeOut = Math.max( 1000, n );
		}
		
		public function release() : void
		{
			_loadStrategy.release();
		}
		
		public function getContent() : DisplayObject
		{
			return _oContent as DisplayObject;
		}
		
		public function setContent( content : Object ) : void
		{
			_oContent = content;
		}
		
		final public function fireOnLoadProgressEvent() : void
		{
			fireEventType( LoaderEvent.onLoadProgressEVENT );
		}
		
		final public function fireOnLoadInitEvent() : void
		{
			onLoadInit();
		}
		
		final public function fireOnLoadStartEvent() : void
		{
			fireEventType( LoaderEvent.onLoadStartEVENT );
		}
		
		final public function fireOnLoadErrorEvent() : void
		{
			fireEventType( LoaderEvent.onLoadErrorEVENT );
		}
		
		final public function fireCommandEndEvent() : void
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
		protected function fireEventType( type : String ) : void
		{
			_oEB.broadcastEvent( getLoaderEvent( type ) );
		}

		protected function getLoaderEvent( type : String ) : LoaderEvent
		{
			return new LoaderEvent( type, this );
		}

		//
		private function _getStringTimeStamp() : String
		{
			var d : Date = new Date();
			return String( d.getTime() );
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

internal class AbstractLoaderConstructorAccess {}