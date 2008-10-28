package com.bourre.media.sound
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
	 * @author Aigret Axel
	 * @version 1.0
	 */
	import flash.errors.IOError;
	import flash.events.*;
	import flash.media.Sound;
	import flash.media.SoundLoaderContext;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	
	import com.bourre.load.Loader;
	import com.bourre.load.strategy.LoadStrategy;
	import com.bourre.log.PixlibStringifier;	

	public class SoundURLStrategy 
		implements LoadStrategy
	{
		private var _owner : com.bourre.load.Loader;
		private var _loader : Sound;
		private var _bytesLoaded : uint;
		private var _bytesTotal : uint;

		public function SoundURLStrategy()
		{
			_bytesLoaded = 0;
			_bytesTotal = 0;
		}

		public function load( request : URLRequest = null, context : LoaderContext = null ) : void
		{
			_initLoaderStrategy();
			_loader.load( request , context as SoundLoaderContext );
			if(_owner) _owner.setContent( _loader );
		}

		public function getBytesLoaded() : uint
		{
			return _bytesLoaded;
		}

		public function isBuffering () : Boolean
	  	{
	  		return _loader.isBuffering ;
	  	}

		public function getBytesTotal() : uint
		{
			return _bytesTotal;
		}

		public function setOwner( owner : com.bourre.load.Loader ) : void
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
		        _loader.removeEventListener( Event.INIT, _onInit );
		        _loader.removeEventListener( Event.UNLOAD, _onUnLoad );
				try // for local close file
				{
					_loader.close();
				}catch( e : IOError ) 
				{ 
					
				}
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
		protected function _initLoaderStrategy() : void
		{
			_loader = new Sound();
			_loader.addEventListener( ProgressEvent.PROGRESS, _onProgress );
			_loader.addEventListener( Event.COMPLETE, _onComplete );
			_loader.addEventListener( Event.OPEN, _onOpen );
			_loader.addEventListener( SecurityErrorEvent.SECURITY_ERROR, _onSecurityError );
			_loader.addEventListener( HTTPStatusEvent.HTTP_STATUS, _onHttpStatus );
			_loader.addEventListener( IOErrorEvent.IO_ERROR, _onIOError );
	        _loader.addEventListener( Event.INIT, _onInit );
	        _loader.addEventListener( Event.UNLOAD, _onUnLoad );
		}

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
				// we send a on init in case of complete , we dont have init in sound
				_owner.fireOnLoadInitEvent();
			}
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
	    	//
			
		}

	    protected function _onUnLoad( e : Event ) : void 
	    {
			//
		}
	}
}