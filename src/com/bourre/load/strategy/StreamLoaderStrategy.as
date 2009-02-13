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
	import com.bourre.load.strategy.LoadStrategy;
	import com.bourre.log.PixlibDebug;
	import com.bourre.log.PixlibStringifier;
	
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	import flash.net.URLStream;
	import flash.system.LoaderContext;	

	/**
	 * The URLStreamStrategy class define a loading strategy using 
	 * URLStream loader.
	 * 
	 * @author 	Romain Ecarnot
	 * 
	 * @see	com.bourre.load.StreamLoader
	 */
	public class StreamLoaderStrategy implements LoadStrategy
	{
		//--------------------------------------------------------------------
		// Protected properties
		//--------------------------------------------------------------------
		
		/** @private */		
		protected var _owner : Loader;
		
		/** @private */	
		protected var _loader : URLStream;
		/** @private */	
		protected var _bytesLoaded : uint;
		
		/** @private */	
		protected var _bytesTotal : uint;
		
		
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
		
		/**
		 * Creates new <code>StreamStrategy</code> instance.
		 */
		public function StreamLoaderStrategy( )
		{
			_bytesLoaded = 0;
			_bytesTotal = 0;
		}
		
		/**
		 * @inheritDoc
		 */
		public function load( request : URLRequest = null, context : LoaderContext = null ) : void
		{
			_loader = new URLStream( );
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
		
		/** @private */
		protected function _onProgress( e : ProgressEvent ) : void
		{
			_bytesLoaded = e.bytesLoaded;
			_bytesTotal = e.bytesTotal;
			if ( _owner ) _owner.fireOnLoadProgressEvent();
		}
		
		/** @private */
		protected function _onComplete( e : Event ) : void 
		{
			if ( _owner ) 
			{
				_owner.setContent( _loader );
	        	_owner.fireOnLoadInitEvent();
			}
	    }
		
		/** @private */
	    protected function _onOpen( event : Event ) : void
	    {
	    	if ( _owner ) _owner.fireOnLoadStartEvent();
	    }
		
		/** @private */
	    protected function _onSecurityError( e : SecurityErrorEvent ) : void 
	    {
			if ( _owner ) _owner.fireOnLoadErrorEvent( e.text );
	    }
		
		/** @private */
	    protected function _onHttpStatus( e : HTTPStatusEvent ) : void 
	    {
			//
	    }
		
		/** @private */
	    protected function _onIOError( e : IOErrorEvent ) : void 
	    {
			if ( _owner ) _owner.fireOnLoadErrorEvent( e.text );
	    }
	}
}
