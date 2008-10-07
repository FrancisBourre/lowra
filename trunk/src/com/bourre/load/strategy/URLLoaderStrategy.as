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
	import com.bourre.log.PixlibDebug;
	import com.bourre.log.PixlibStringifier;
	
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;	
	
	/**
	 * @author Francis Bourre
	 * @version 1.0
	 */
	public class URLLoaderStrategy 
		implements LoadStrategy
	{
		public static const BINARY : String = URLLoaderDataFormat.BINARY;
		public static const TEXT : String = URLLoaderDataFormat.TEXT;
		public static const VARIABLES : String = URLLoaderDataFormat.VARIABLES;

		protected var _owner : Loader;
		protected var _loader : URLLoader;
		protected var _bytesLoaded : uint;
		protected var _bytesTotal : uint;
		protected var _sDataFormat : String;

		public static function isValidDataFormat( dataFormat : String ) : Boolean
		{
			return (dataFormat == URLLoaderStrategy.TEXT || 
					dataFormat == URLLoaderStrategy.BINARY || 
					dataFormat == URLLoaderStrategy.VARIABLES);
		}

		public function URLLoaderStrategy( dataFormat : String = null )
		{
			_bytesLoaded = 0;
			_bytesTotal = 0;

			setDataFormat( dataFormat );
		}

		public function setDataFormat( dataFormat : String ) : void
		{
			_sDataFormat = dataFormat;
		}

		public function load( request : URLRequest = null, context : LoaderContext = null ) : void
		{
			_loader = new URLLoader( );
			_loader.dataFormat = URLLoaderStrategy.isValidDataFormat( _sDataFormat ) ? _sDataFormat : URLLoaderStrategy.TEXT;

			_loader.addEventListener( ProgressEvent.PROGRESS, _onProgress );
			_loader.addEventListener( Event.COMPLETE, _onComplete );
			_loader.addEventListener( Event.OPEN, _onOpen );
			_loader.addEventListener( SecurityErrorEvent.SECURITY_ERROR, _onSecurityError );
			_loader.addEventListener( HTTPStatusEvent.HTTP_STATUS, _onHttpStatus );
			_loader.addEventListener( IOErrorEvent.IO_ERROR, _onIOError );

			if ( context != null ) PixlibDebug.WARN( this + ".load() doesn't support LoaderContext argument." ); 
			_loader.load( request ) ;
		}

		public function getBytesLoaded() : uint
		{
			return _bytesLoaded;
		}

		public function getBytesTotal() : uint
		{
			return _bytesTotal;
		}

		public function setOwner( owner : Loader ) : void
		{
			_owner = owner;
		}

		public function release() : void
		{
			if ( _loader ) 
			{
				_loader.removeEventListener( ProgressEvent.PROGRESS, _onProgress );
				_loader.removeEventListener( Event.COMPLETE, _onComplete );
				_loader.removeEventListener( Event.OPEN, _onOpen );
				_loader.removeEventListener( SecurityErrorEvent.SECURITY_ERROR, _onSecurityError );
				_loader.removeEventListener( HTTPStatusEvent.HTTP_STATUS, _onHttpStatus );
				_loader.removeEventListener( IOErrorEvent.IO_ERROR, _onIOError );

				try 
				{
        			_loader.close();

    			} catch( error : Error ) {}
			}
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
		protected function _onProgress( e : ProgressEvent ) : void
		{
			_bytesLoaded = e.bytesLoaded;
			_bytesTotal = e.bytesTotal;
			if ( _owner ) _owner.fireOnLoadProgressEvent();
		}

		protected function _onComplete( e : Event ) : void 
		{
			if ( _owner ) 
			{
				_owner.setContent( _loader.data );
	        	_owner.fireOnLoadInitEvent();
			}
	    }

	    protected function _onOpen( event : Event ) : void
	    {
	    	if ( _owner ) _owner.fireOnLoadStartEvent();
	    }

	    protected function _onSecurityError( e : SecurityErrorEvent ) : void 
	    {
			if ( _owner ) _owner.fireOnLoadErrorEvent( e.text );
	    }

	    protected function _onHttpStatus( e : HTTPStatusEvent ) : void 
	    {
			//
	    }

	    protected function _onIOError( e : IOErrorEvent ) : void 
	    {
			if ( _owner ) _owner.fireOnLoadErrorEvent( e.text );
	    }
	}
}
