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

	import com.bourre.collection.Queue;
	import flash.events.Event;
	import com.bourre.log.PixlibDebug;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	
	public class QueueLoader 
		extends AbstractLoader 
	{
		private var _q : Queue;
		private var _currentLoader:Loader ;
		private static var _KEY:int=0 ;
		
		public function QueueLoader()
		{
			_q = new Queue();
		}
		
		public function clear() : void
		{
			_q.clear();
		}
		
		public function add( loader : Loader, name : String, url : URLRequest, context : LoaderContext = null ) : Boolean
		{
			if ( name ) 
			{
				loader.setName( name );
				
				if ( url )
				{
					loader.setURL( url );
					if( context )
					{
						loader.setContext( context );
					}
				} else if ( loader.getURL().url )
				{
					PixlibDebug.WARN( this + ".add failed, you passed Loader argument without any url property." );
				}

			} else if( !(loader.getName()) )
			{
				PixlibDebug.WARN( "You passed Loader argument without any name property in " + this + ".enqueue()." );
			}
			
			if (loader.getName() == null) loader.setName( 'library' + QueueLoader._KEY++);
			
			_q.add(loader);
			return loader.getName()!= null;
		}
		
		public function onLoaderLoadStart( e : LoaderEvent, ... rest ) : void
		{
			
		}
		
		public function onLoaderLoadInit( e : LoaderEvent, ... rest ) : void
		{
			fireEventType(LoaderEvent.onLoadInitEVENT) ;
			if (isEmpty())
			{
				onLoaderLoadComplete(new LoaderEvent(LoaderEvent.onLoadInitEVENT, this)) ;
			}
			else
			{
				loadNextEntry() ;
			}
		}
		
		public function onLoaderLoadProgress( e : LoaderEvent, ... rest ) : void
		{
			
		}
		
		public function onLoaderLoadComplete (e : LoaderEvent, ... rest ) : void
		{
			_currentLoader.removeEventListener  (LoaderEvent.onLoadInitEVENT,		onLoaderLoadInit) ;
			_currentLoader.removeEventListener  (LoaderEvent.onLoadProgressEVENT, 	onLoaderLoadProgress) ;
			_currentLoader.removeEventListener  (LoaderEvent.onLoadTimeOutEVENT, 	onLoaderLoadTimeOut) ;
			_currentLoader.removeEventListener  (LoaderEvent.onLoadStartEVENT, 		onLoaderLoadStart) ;
			fireEventType						(QueueLoaderEvent.onLoadCompleteEVENT) ;
		}
		
		public function onLoaderLoadTimeOut( e : LoaderEvent, ... rest ) : void
		{
			
		}
		
		public function onLoaderLoadError( e : LoaderEvent, ... rest ) : void
		{
			
		}
		
		protected override function getLoaderEvent( type : String ) : LoaderEvent
		{
			return new QueueLoaderEvent( type, this );
		}
		
		public override function load( url : URLRequest = null, context : LoaderContext = null ) : void
		{
			release();

			super.load( url, context );
		}
		
		public function loadNextEntry() : void
		{
			if (_currentLoader)
			{
				_currentLoader.removeEventListener(LoaderEvent.onLoadInitEVENT, 	onLoaderLoadInit) ;
				_currentLoader.removeEventListener(LoaderEvent.onLoadProgressEVENT, onLoaderLoadProgress) ;
				_currentLoader.removeEventListener(LoaderEvent.onLoadTimeOutEVENT, 	onLoaderLoadTimeOut) ;
				_currentLoader.removeEventListener(LoaderEvent.onLoadStartEVENT, 	onLoaderLoadStart) ;
			}
			_currentLoader = _q.poll() as Loader ;
			if (_sPrefixURL)
				_currentLoader.prefixURL(_sPrefixURL) ;
			_currentLoader.addEventListener(LoaderEvent.onLoadInitEVENT, 	onLoaderLoadInit) ;
			_currentLoader.addEventListener(LoaderEvent.onLoadProgressEVENT,onLoaderLoadProgress) ;
			_currentLoader.addEventListener(LoaderEvent.onLoadTimeOutEVENT, onLoaderLoadTimeOut) ;
			_currentLoader.addEventListener(LoaderEvent.onLoadStartEVENT, 	onLoaderLoadStart) ;
			
			_currentLoader.execute() ;
		}
		
		public override function release() : void
		{
			//

			super.release();
		}
		
		private function _onLoadStart() : void
		{
			fireEventType( QueueLoaderEvent.onLoadStartEVENT );
		}
		
		public override function execute( e : Event = null ) : void
		{
			var a : Array = _q.toArray();
			var l : Number = a.length;
			
			while( --l > -1 )
			{
				var loader: Loader = a[l];
				if ( !( loader.getURL() ) )
				{
					PixlibDebug.ERROR( this + " encounters Loader instance without url property, load fails." );
					return;
				}
			}
			
			_onLoadStart();

			loadNextEntry() ;		
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
		
	}
}