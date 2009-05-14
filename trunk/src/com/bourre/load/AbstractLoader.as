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
 
package com.bourre.load
{
	import com.bourre.commands.ASyncCommand;
	import com.bourre.commands.ASyncCommandListener;
	import com.bourre.commands.AbstractSyncCommand;
	import com.bourre.error.IllegalStateException;
	import com.bourre.error.NullPointerException;
	import com.bourre.events.EventBroadcaster;
	import com.bourre.load.strategy.LoadStrategy;
	import com.bourre.log.PixlibDebug;
	
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;	

	/**
	 *  Dispatched when loader starts loading.
	 *  
	 *  @eventType com.bourre.load.LoaderEvent.onLoadStartEVENT
	 */
	[Event(name="onLoadStart", type="com.bourre.load.LoaderEvent")]

	/**
	 *  Dispatched when loading is finished.
	 *  
	 *  @eventType com.bourre.load.LoaderEvent.onLoadInitEVENT
	 */
	[Event(name="onLoadInit", type="com.bourre.load.LoaderEvent")]

	/**
	 *  Dispatched during loading progression.
	 *  
	 *  @eventType com.bourre.load.LoaderEvent.onLoadProgressEVENT
	 */
	[Event(name="onLoadProgress", type="com.bourre.load.LoaderEvent")]

	/**
	 *  Dispatched when a timeout occurs during loading.
	 *  
	 *  @eventType com.bourre.load.LoaderEvent.onLoadTimeOutEVENT
	 */
	[Event(name="onLoadTimeOut", type="com.bourre.load.LoaderEvent")]

	/**
	 *  Dispatched when an error occurs during loading.
	 *  
	 *  @eventType com.bourre.load.LoaderEvent.onLoadErrorEVENT
	 */
	[Event(name="onLoadError", type="com.bourre.load.LoaderEvent")]

	/**
	 * The AbstractLoader class gives abstract implementation of a 
	 * loader object.
	 * 
	 * @author 	Francis Bourre
	 */
	public class AbstractLoader implements 	com.bourre.load.Loader, ASyncCommand
	{
		static private var _oPool : Dictionary = new Dictionary( );

		/**
		 * @private
		 * 
		 * Allow to avoid gc on local loader.
		 */
		static protected function registerLoaderToPool( o : Loader ) : void
		{
			if( _oPool[ o ] == null )
			{
				_oPool[ o ] = true;
			} 
			else
			{
				PixlibDebug.WARN( o + " is already registered in the loading pool" );
			}
		}

		/**
		 * @private
		 */
		static protected function unregisterLoaderFromPool( o : Loader ) : void
		{
			if( _oPool[ o ] != null )
			{
				delete _oPool[ o ];
			} 
			else
			{
				PixlibDebug.WARN( o + " is not registered in the loading pool" );
			}
		}

		private var _oEB : EventBroadcaster;
		private var _sName : String;
		private var _nTimeOut : Number;
		private var _bAntiCache : Boolean;

		private var _loadStrategy : LoadStrategy;
		private var _oContent : Object;
		private var _bIsRunning : Boolean;
		private var _nLastBytesLoaded : Number;
		private var _nTime : int;
		
		private var _oURL : URLRequest;
		
		protected var _sPrefixURL : String;
		protected var _sURL : String;
		
		/**
		 * Creates new <code>AbstractLoader</code> instance.
		 * 
		 * @param	strategy	Loading strategy to use in this loader.
		 */
		public function AbstractLoader( strategy : LoadStrategy = null )
		{
			_loadStrategy = (strategy != null) ? strategy : new NullLoadStrategy( );
			_loadStrategy.setOwner( this );
			
			_oEB = new EventBroadcaster( this, LoaderListener );
			_nTimeOut = 10000;
			_bAntiCache = false;
			_sPrefixURL = "";
			_bIsRunning = false;
		}

		/**
		 * Execute the request according to the current command data.
		 * 
		 * @see load()
		 */
		public function execute( e : Event = null ) : void
		{
			load( );
		}

		/**
		 * @inheritDoc
		 */
		public function getStrategy() : LoadStrategy
		{
			return _loadStrategy;
		}

		/**
		 * @inheritDoc
		 */
		public function load( url : URLRequest = null, context : LoaderContext = null ) : void
		{
			if ( url ) setURL( url );

			if ( getURL( ).url.length > 0 )
			{
				_nLastBytesLoaded = 0;
				_nTime = getTimer( );

				registerLoaderToPool( this );
				
				_bIsRunning = true;
				
				_loadStrategy.load( getURL( ), context );
			} 
			else
			{
				var msg : String = this + ".load() can't retrieve file url.";
				PixlibDebug.ERROR( msg );
				throw new NullPointerException( msg );
			}
		}

		/**
		 * @protected
		 */
		protected function onInitialize() : void
		{
			fireEventType( LoaderEvent.onLoadProgressEVENT );
			fireEventType( LoaderEvent.onLoadInitEVENT );
		}

		/**
		 * @copy com.bourre.events.EventBroadcaster#setListenerType()
		 */
		final protected function setListenerType( type : Class ) : void
		{
			_oEB.setListenerType( type );
		}

		/**
		 * Returns the number of bytes loaded.
		 * 
		 * @return The number of bytes loaded
		 */
		public function getBytesLoaded() : uint
		{
			return _loadStrategy.getBytesLoaded( );
		}

		/**
		 * Returns the total number of bytes to load.
		 * 
		 * @return The total number of bytes to load
		 */
		public function getBytesTotal() : uint
		{
			return _loadStrategy.getBytesTotal( );
		}

		/**
		 * @inheritDoc
		 */
		final public function getPerCent() : Number
		{
			var n : Number = Math.min( 100, Math.ceil( getBytesLoaded( ) / ( getBytesTotal( ) / 100 ) ) );
			return ( isNaN( n ) ) ? 0 : n;
		}

		/**
		 * Returns <code>true</code> if all bytes are loaded.
		 * 
		 * @return	<code>true</code> if all bytes are loaded.
		 */
		final public function isLoaded( ) : Boolean
		{
			return ( getBytesLoaded( ) / getBytesTotal( ) ) == 1 ;
		}

		/**
		 * @inheritDoc
		 */
		public function getURL() : URLRequest
		{
			if(_oURL) _oURL.url = _bAntiCache ? _sPrefixURL + _sURL + "?nocache=" + _getStringTimeStamp() : _sPrefixURL + _sURL;
			return _oURL;
		}
		
		/**
		 * @inheritDoc
		 */
		public function setURL( url : URLRequest ) : void
		{
			_oURL = url;
			_sURL = _oURL.url;
		}

		/**
		 * @inheritDoc
		 */
		final public function addASyncCommandListener( listener : ASyncCommandListener, ... rest ) : Boolean
		{
			return _oEB.addEventListener( AbstractSyncCommand.onCommandEndEVENT, listener );
		}

		/**
		 * @inheritDoc
		 */
		final public function removeASyncCommandListener( listener : ASyncCommandListener ) : Boolean
		{
			return _oEB.removeEventListener( AbstractSyncCommand.onCommandEndEVENT, listener );
		}

		/**
		 * @copy com.bourre.events.Broadcaster#addListener()
		 */
		public function addListener( listener : LoaderListener ) : Boolean
		{
			return _oEB.addListener( listener );
		}

		/**
		 * @copy com.bourre.events.Broadcaster#removeListener()
		 */
		public function removeListener( listener : LoaderListener ) : Boolean
		{
			return _oEB.removeListener( listener );
		}

		/**
		 * @copy com.bourre.events.Broadcaster#addEventListener()
		 */
		public function addEventListener( type : String, listener : Object, ... rest ) : Boolean
		{
			return _oEB.addEventListener.apply( _oEB, rest.length > 0 ? [ type, listener ].concat( rest ) : [ type, listener ] );
		}

		/**
		 * @copy com.bourre.events.Broadcaster#removeEventListener()
		 */
		public function removeEventListener( type : String, listener : Object ) : Boolean
		{
			return _oEB.removeEventListener( type, listener );
		}

		/**
		 * @inheritDoc
		 */
		public function getName() : String
		{
			return _sName;
		}

		/**
		 * @inheritDoc
		 */
		public function setName( sName : String ) : void
		{
			_sName = sName;
		}

		/**
		 * @inheritDoc
		 */
		public function setAntiCache( b : Boolean ) : void
		{
			_bAntiCache = b;
		}

		/**
		 * Returns <code>true</code> if 'anticache' system is on.
		 * 
		 * @return <code>true</code> if 'anticache' system is on.
		 */
		public function isAntiCache() : Boolean
		{
			return _bAntiCache;
		}

		/**
		 * @inheritDoc
		 */
		public function prefixURL( sURL : String ) : void
		{
			_sPrefixURL = sURL;
		}

		/**
		 * Returns the loading timeout limit
		 * 
		 * @see #setTimeOut()
		 */
		final public function getTimeOut() : Number
		{
			return _nTimeOut;
		}

		/**
		 * Sets a loading timeout limit.
		 */
		final public function setTimeOut( n : Number ) : void
		{
			_nTimeOut = Math.max( 1000, n );
		}

		/**
		 * Releases instance and all registered listeners.
		 */
		public function release() : void
		{
			_loadStrategy.release( );
			_oEB.removeAllListeners( );
		}

		/**
		 * Returns loaded content.
		 * 
		 * @return The loaded content
		 */		public function getContent() : Object
		{
			return _oContent;
		}

		/**
		 * @inheritDoc
		 */
		public function setContent( content : Object ) : void
		{	
			_oContent = content;
		}

		/**
		 * @inheritDoc
		 */
		public function fireOnLoadProgressEvent() : void
		{
			fireEventType( LoaderEvent.onLoadProgressEVENT );
		}

		/**
		 * @inheritDoc
		 */
		final public function fireOnLoadInitEvent() : void
		{
			_bIsRunning = false;
			onInitialize( );
			unregisterLoaderFromPool( this );
		}

		/**
		 * @inheritDoc
		 */
		public function fireOnLoadStartEvent() : void
		{
			fireEventType( LoaderEvent.onLoadStartEVENT );
		}

		/**
		 * @inheritDoc
		 */
		public function fireOnLoadErrorEvent( message : String = "" ) : void
		{
			fireEventType( LoaderEvent.onLoadErrorEVENT, message );
		}

		/**
		 * @inheritDoc
		 */
		public function fireOnLoadTimeOut() : void
		{
			unregisterLoaderFromPool( this );
			fireEventType( LoaderEvent.onLoadTimeOutEVENT );
		}

		/**
		 * @inheritDoc
		 */
		final public function fireCommandEndEvent() : void
		{
			fireEventType( AbstractSyncCommand.onCommandEndEVENT );
		}

		/**
		 * Dispatches event using passed-in type and optional error message.
		 * 
		 * @param	type			Event type so dispatch
		 * @param	errorMessage	(optional) Error message to carry
		 * 
		 * @see #fireEvent()
		 */
		protected function fireEventType( type : String, errorMessage : String = "" ) : void
		{
			fireEvent( getLoaderEvent( type, errorMessage ) );
		}
		
		/**
		 * Dispatched passed-in event to all registered listeners.
		 * 
		 * @param	e	Event to dispatch
		 */
		protected function fireEvent( e : Event ) : void
		{
			_oEB.broadcastEvent( e );
		}

		/**
		 * Returns a loader event for current loader instance.
		 * 
		 * @param	type	Event type to dispatch
		 * 
		 * @return A loader event for current loader instance.
		 */
		protected function getLoaderEvent( type : String, errorMessage : String = "" ) : LoaderEvent
		{
			return new LoaderEvent( type, this, errorMessage );
		}

		//
		private function _getStringTimeStamp() : String
		{
			var d : Date = new Date( );
			return String( d.getTime( ) );
		}

		/**
		 * @inheritDoc
		 */
		public function run() : void
		{
			if ( !isRunning( ) )
			{
				_bIsRunning = true;
				execute( );
			} 
			else
			{
				var msg : String = this + ".run() called wheras an operation is currently running";
				PixlibDebug.ERROR( msg );
				throw new IllegalStateException( msg );
			}
		}

		/**
		 * @inheritDoc
		 */
		public function isRunning() : Boolean
		{
			return _bIsRunning;
		}

        // TODO check if _checkTimeOut is important
//        private function _checkTimeOut( nLastBytesLoaded : Number, nTime : Number ) : void 
//		{
//			if ( nLastBytesLoaded != _nLastBytesLoaded)
//			{
//				_nLastBytesLoaded = nLastBytesLoaded;
//				_nTime = nTime;
//			}
//			else if ( nTime - _nTime  > _nTimeOut)
//			{
//				fireOnLoadTimeOut();
//				release();
//				PixlibDebug.ERROR( this + " load timeout with url : '" + getURL() + "'." );
//			}
//		}
	}
}

import com.bourre.load.Loader;
import com.bourre.load.strategy.LoadStrategy;

import flash.net.URLRequest;
import flash.system.LoaderContext;

internal class NullLoadStrategy 
	implements LoadStrategy
{
	public function load( request : URLRequest = null, context : LoaderContext = null  ) : void 
	{
	}

	public function getBytesLoaded() : uint 
	{ 
		return 0; 
	}

	public function getBytesTotal() : uint 
	{ 
		return 0; 
	}

	public function setOwner( owner : Loader ) : void 
	{
	}

	public function release() : void 
	{
	}
}