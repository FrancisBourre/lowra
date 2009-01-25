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
	 * The URLLoaderStrategy class define a loading strategy using 
	 * Lowra URL loader.
	 * 
	 * @author 	Francis Bourre
	 */
	public class URLLoaderStrategy implements LoadStrategy
	{
		//--------------------------------------------------------------------
		// Constants
		//--------------------------------------------------------------------
		
		/**
		 * Specifies that downloaded data is received as raw binary data. 
		 */	
		public static const BINARY : String = URLLoaderDataFormat.BINARY;
		
		/**
		 * Specifies that downloaded data is received as text. 
		 */
		public static const TEXT : String = URLLoaderDataFormat.TEXT;
		
		/**
		 * Specifies that downloaded data is received as URL-encoded variables. 
		 */
		public static const VARIABLES : String = URLLoaderDataFormat.VARIABLES;
		
		
		//--------------------------------------------------------------------
		// Protected properties
		//--------------------------------------------------------------------
		
		/** @private */		
		protected var _owner : Loader;
		
		/** @private */	
		protected var _loader : URLLoader;
		
		/** @private */	
		protected var _bytesLoaded : uint;
		
		/** @private */	
		protected var _bytesTotal : uint;
		
		/** @private */	
		protected var _sDataFormat : String;
		
		
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
				
		public static function isValidDataFormat( dataFormat : String ) : Boolean
		{
			return (dataFormat == URLLoaderStrategy.TEXT || 
					dataFormat == URLLoaderStrategy.BINARY || 
					dataFormat == URLLoaderStrategy.VARIABLES);
		}
		
		/**
		 * Creates new <code>URLLoaderStrategy</code> instance.
		 * 
		 * @param	dataFormat	(optional) Downloaded data format
		 * 
		 * @see #setDataFormat()
		 */
		public function URLLoaderStrategy( dataFormat : String = null )
		{
			_bytesLoaded = 0;
			_bytesTotal = 0;

			setDataFormat( dataFormat );
		}
		
		/**
		 * Sets how the downloaded data is received.
		 * 
		 * <p>If the value of the dataFormat property is 
		 * <code>URLLoaderDataFormat.TEXT</code>, 
		 * the received data is a string containing the text of 
		 * the loaded file.</p>
		 * <p>If the value of the dataFormat property is 
		 * <code>URLLoaderDataFormat.BINARY</code>, the received data is 
		 * a ByteArray object containing the raw binary data.</p>
		 * <p>If the value of the dataFormat property is 
		 * <code>URLLoaderDataFormat.VARIABLES</code>, the received data is 
		 * a URLVariables object containing the URL-encoded variables.</p>
		 * 
		 * <p>The default is <code>URLLoaderStrategy.TEXT</code></p>
		 * 
		 * @param	dataFormat	Downloaded data format
		 */
		public function setDataFormat( dataFormat : String ) : void
		{
			_sDataFormat = dataFormat;
		}
		
		/**
		 * @inheritDoc
		 */
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
		
		/**
		 * @inheritDoc
		 */
		public function getBytesLoaded() : uint
		{
			return _bytesLoaded;
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
		public function setOwner( owner : Loader ) : void
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
