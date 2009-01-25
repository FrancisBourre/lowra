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
	import com.bourre.collection.Queue;
	import com.bourre.error.NullPointerException;
	import com.bourre.log.PixlibDebug;
	
	import flash.net.URLRequest;
	import flash.system.LoaderContext;	

	/**
	 * The QueueLoader class.
	 * 
	 * <p>TODO Documentation.</p>
	 * 
	 * @author 	Francis Bourre	 * @author 	Cedric Nehemie
	 */
	public class QueueLoader extends AbstractLoader 
	{
		protected var _q : Queue;
		protected var _currentLoader : Loader;

		private static var _KEY : int = 0 ;

		public function QueueLoader()
		{
			_q = new Queue( Loader );
		}

		public function clear() : void
		{
			_q.clear();
		}

		public function getCurrentLoader() : Loader
		{
			return _currentLoader;
		}

		override public function load( url : URLRequest = null, context : LoaderContext = null ) : void
		{
			registerLoaderToPool( this );

			var a : Array = _q.toArray();
			var l : Number = a.length;

			while( --l > -1 )
			{
				var loader : Loader = a[l];
				if ( !( loader.getURL() ) )
				{
					var msg : String = this + " encounters Loader instance without url property, load fails.";
					PixlibDebug.ERROR( msg );
					throw NullPointerException( msg );
					return;
				}
			}
			
			_onLoadStart();
			_processQueue() ;
		}

		override public function release() : void
		{
			clear();
			super.release();
		}

		public function isEmpty() : Boolean
		{
			return _q.isEmpty();
		}

		public function toArray() : Array
		{
			return _q.toArray();
		}

		public function size() : uint
		{
			return _q.size();
		}

		public function add( loader : Loader, name : String, url : URLRequest = null, context : LoaderContext = null ) : Boolean
		{
			if ( name != null ) 
			{
				loader.setName( name );

				if ( url )
				{
					loader.setURL( url );
					if ( context && loader is GraphicLoader ) ( loader as GraphicLoader ).setContext( context );

				} else if ( !loader.getURL().url )
				{
					PixlibDebug.WARN( this + ".add failed, you passed Loader argument without any url property." );
				}

			} else if( !(loader.getName()) )
			{
				PixlibDebug.WARN( "You passed Loader argument without any name property in " + this + ".add()." );
			}

			if ( loader.getName() == null ) loader.setName( 'library' + QueueLoader._KEY++ );

			_q.add(loader);
			return loader.getName()!= null;
		}

		public function loadNextEntry() : void
		{
			removeListeners() ;
			
			_currentLoader = _q.poll() as Loader ;

			if ( isAntiCache() ) _currentLoader.setAntiCache( true );
			if ( _sPrefixURL ) _currentLoader.prefixURL( _sPrefixURL );

			addListeners() ;

			_currentLoader.execute() ;
		}
		
		protected function addListeners() : void
		{
			if ( _currentLoader )
			{
				_currentLoader.addEventListener(LoaderEvent.onLoadInitEVENT, 	onLoaderLoadInit);
				_currentLoader.addEventListener(LoaderEvent.onLoadProgressEVENT,onLoaderLoadProgress);
				_currentLoader.addEventListener(LoaderEvent.onLoadTimeOutEVENT, onLoaderLoadTimeOut);
				_currentLoader.addEventListener(LoaderEvent.onLoadStartEVENT, 	onLoaderLoadStart);
				_currentLoader.addEventListener(LoaderEvent.onLoadErrorEVENT,   onLoaderLoadError);
			}
		}
		
		protected function removeListeners() : void
		{
			if ( _currentLoader )
			{
				_currentLoader.removeEventListener(LoaderEvent.onLoadInitEVENT, 	onLoaderLoadInit);
				_currentLoader.removeEventListener(LoaderEvent.onLoadProgressEVENT, onLoaderLoadProgress);
				_currentLoader.removeEventListener(LoaderEvent.onLoadTimeOutEVENT, 	onLoaderLoadTimeOut);
				_currentLoader.removeEventListener(LoaderEvent.onLoadStartEVENT, 	onLoaderLoadStart);
				_currentLoader.removeEventListener(LoaderEvent.onLoadErrorEVENT, 	onLoaderLoadError);
			}
		}

		public function onLoaderLoadStart( e : LoaderEvent, ... rest ) : void
		{
			fireEventType( QueueLoaderEvent.onItemLoadStartEVENT ) ;
		}

		public function onLoaderLoadInit( e : LoaderEvent, ... rest ) : void
		{
			fireEventType( QueueLoaderEvent.onItemLoadInitEVENT ) ;
			_processQueue();
		}

		public function onLoaderLoadProgress( e : LoaderEvent, ... rest ) : void
		{
			fireEventType( e.type );
		}

		public function onLoaderLoadTimeOut( e : LoaderEvent, ... rest ) : void
		{
			fireEventType( e.type );
			_processQueue();
		}

		public function onLoaderLoadError( e : LoaderEvent, ... rest ) : void
		{
			fireEventType( e.type, e.getErrorMessage() );
			_processQueue();
		}

		override protected function getLoaderEvent( type : String, errorMessage : String = "" ) : LoaderEvent
		{
			return new QueueLoaderEvent( type, this, errorMessage );
		}

		private function _onLoadStart() : void
		{
			fireOnLoadStartEvent();
		}

		protected function _processQueue() : void
		{
			if ( isEmpty() )
			{
				removeListeners() ;
				fireOnLoadInitEvent();

			} else
			{
				loadNextEntry() ;
			}
		}		
	}
}