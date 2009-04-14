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
package com.bourre.load.strategy
{
	import com.bourre.load.Loader;
	import com.bourre.log.PixlibStringifier;
	
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;	

	/**
	 * The LoaderStrategy class define a loading strategy using Adobe 
	 * com.bourre.load.Loader loader.
	 * 
	 * @author 	Francis Bourre
	 */
	public class LoaderStrategy implements LoadStrategy
	{
		//--------------------------------------------------------------------
		// Protected properties
		//--------------------------------------------------------------------
		
		/** @private */		
		protected var _owner : com.bourre.load.Loader;
		
		/** @private */	
		protected var _loader : flash.display.Loader;
		
		/** @private */	
		protected var _bytesLoaded : uint;
		
		/** @private */	
		protected var _bytesTotal : uint;
		
		
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
		
		/**
		 * Creates new <code>LoaderStrategy</code> instance.
		 */		
		public function LoaderStrategy()
		{
			_bytesLoaded = 0;
			_bytesTotal = 0;
		}
		
		/**
		 * @inheritDoc
		 */
		public function load( request : URLRequest = null, context : LoaderContext = null ) : void
		{
			_initLoaderStrategy();
			_loader.load( request, context );
		}
		
		/**
		 * Loads from binary data stored in a ByteArray object. 
		 * 
		 * @param	bytes	A ByteArray object.
		 * @param	context	A LoaderContext object.
		 */
		public function loadBytes( bytes : ByteArray, context : LoaderContext = null ) : void
		{
			_initLoaderStrategy();
			_loader.loadBytes( bytes, context );
		}
		
		/**
		 * @inheritDoc
		 */
		public function getBytesLoaded() : uint
		{
			return _bytesLoaded;
		}
		
		/**
		 * Returns informations about loaded content.
		 */
		public function getContentLoaderInfo () : LoaderInfo
	  	{
	  		return _loader.contentLoaderInfo;
	  	}
		
		/**
		 * @inheritDoc
		 */
		public function getBytesTotal() : uint
		{
			return _bytesTotal;
		}
		
		/**
		 * @inheritDoc
		 */
		public function setOwner( owner : com.bourre.load.Loader ) : void
		{
			_owner = owner;
		}
		
		/**
		 * @inheritDoc
		 */
		public function release() : void
		{
			if ( _loader ) 
			{
				_loader.contentLoaderInfo.removeEventListener( ProgressEvent.PROGRESS, _onProgress );
				_loader.contentLoaderInfo.removeEventListener( Event.COMPLETE, _onComplete );
				_loader.contentLoaderInfo.removeEventListener( Event.OPEN, _onOpen );
				_loader.contentLoaderInfo.removeEventListener( SecurityErrorEvent.SECURITY_ERROR, _onSecurityError );
				_loader.contentLoaderInfo.removeEventListener( HTTPStatusEvent.HTTP_STATUS, _onHttpStatus );
				_loader.contentLoaderInfo.removeEventListener( IOErrorEvent.IO_ERROR, _onIOError );
		        _loader.contentLoaderInfo.removeEventListener( Event.INIT, _onInit );
		        _loader.contentLoaderInfo.removeEventListener( Event.UNLOAD, _onUnLoad );

				try 
				{
        			_loader.close();

    			} catch( error : Error ) {}
			}
		}

		/**
		 * Returns the string representation of this instance.
		 * 
		 * @return the string representation of this instance
		 */
		public function toString() : String 
		{
			return PixlibStringifier.stringify( this );
		}
		

		//--------------------------------------------------------------------
		// Protected methods
		//--------------------------------------------------------------------
				
		protected function _initLoaderStrategy() : void
		{
			_loader = new flash.display.Loader();
			_loader.contentLoaderInfo.addEventListener( ProgressEvent.PROGRESS, _onProgress );
			_loader.contentLoaderInfo.addEventListener( Event.COMPLETE, _onComplete );
			_loader.contentLoaderInfo.addEventListener( Event.OPEN, _onOpen );
			_loader.contentLoaderInfo.addEventListener( SecurityErrorEvent.SECURITY_ERROR, _onSecurityError );
			_loader.contentLoaderInfo.addEventListener( HTTPStatusEvent.HTTP_STATUS, _onHttpStatus );
			_loader.contentLoaderInfo.addEventListener( IOErrorEvent.IO_ERROR, _onIOError );
	        _loader.contentLoaderInfo.addEventListener( Event.INIT, _onInit );
	        _loader.contentLoaderInfo.addEventListener( Event.UNLOAD, _onUnLoad );
		}

		protected function _onProgress( e : ProgressEvent ) : void
		{
			_bytesLoaded = e.bytesLoaded;
			_bytesTotal = e.bytesTotal;

			if ( _owner ) _owner.fireOnLoadProgressEvent();
		}
		
		protected function _onComplete( e : Event ) : void 
		{
			if ( _owner ) _owner.fireOnLoadInitEvent();
		}
		
	    protected function _onOpen( e : Event ) : void
	    {
	    	if ( _owner ) _owner.fireOnLoadStartEvent();
	    }

	    protected function _onSecurityError( e : SecurityErrorEvent ) : void 
	    {
	    	release();
			if ( _owner ) _owner.fireOnLoadErrorEvent( e.text );
	    }

	    protected function _onHttpStatus( e : HTTPStatusEvent ) : void 
	    {
	    	//
	    }
		
	    protected function _onIOError( e : IOErrorEvent ) : void 
	    {
	    	release();
			if ( _owner ) _owner.fireOnLoadErrorEvent( e.text );
	    }
		
	    protected function _onInit( e : Event ) : void 
	    {
			if ( _owner ) _owner.setContent( _loader.content );
		}

	    protected function _onUnLoad( e : Event ) : void 
	    {
			//
		}
	}
}