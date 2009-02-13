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
	 * The QueueLoader class is a composite loader class  wich enables to 
	 * enqueue differents kinf of Loaders and then, load the entire queue.
	 * 
	 * @Example
	 * <pre class="prettyprint">
	 * 
	 * var q : QueueLoader = new QueueLoader();
	 * q.add( new FileLoader(), "info", new URLRequest( "info.txt" ) );
	 * q.add( new XMLLoader( ), "config", new URLRequest( "config.xml" ) );
	 * q.addEventListener( QueueLoaderEvent.onLoadInitEVENT, onQueueComplete );
	 * q.load(); 
	 * </pre>
	 * 
	 * @author 	Francis Bourre	 * @author 	Cedric Nehemie
	 * 
	 * @see Loader
	 */
	public class QueueLoader extends AbstractLoader 
	{
		/** Store the loader elements. */
		protected var _q : Queue;
		
		/** Current loader used when queue starts loading process. */
		protected var _currentLoader : Loader;

		private static var _KEY : int = 0 ;
		
		
		/**
		 * Creates new <code>QueueLoader</code> instance.
		 */
		public function QueueLoader()
		{
			_q = new Queue( Loader );
		}
		
		/**
		 * Clears all items from queue.
		 */
		public function clear() : void
		{
			_q.clear();
		}
		
		/**
		 * Returns the loader used when queue starts loading process.
		 * 
		 * @return The loader used when queue starts loading process.
		 */
		public function getCurrentLoader() : Loader
		{
			return _currentLoader;
		}
		
		/**
		 * Starts loading the entire queue elements.
		 * 
		 * <p>Arguments are ignored as url and context are defined for each element.
		 * 
		 * @param	url		Ignored
		 * @param	content	Ignored
		 * 
		 * @see #add()
		 */
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
		
		/**
		 * Releases instance and all registered listeners.
		 * <br />Queue is clear.
		 */
		override public function release() : void
		{
			clear();
			super.release();
		}
		
		/**
		 * Returns <code>true</code> if queue is empty.
		 * 
		 * @return <code>true</code> if queue is empty.
		 */
		public function isEmpty() : Boolean
		{
			return _q.isEmpty();
		}
		
		/**
		 * Returns an array containing all the elements in this queue.
		 * Obeys the general contract of the <code>Collection.toArray</code>
		 * method.
		 *
		 * @return  <code>Array</code> containing all of the elements
		 * 			in this queue.
		 * @see		Collection#toArray() Collection.toArray()
		 */
		public function toArray() : Array
		{
			return _q.toArray();
		}
		
		/**
		 * Returns the number of elements in this queue (its cardinality).
		 *
		 * @return <code>Number</code> of elements in this queue (its cardinality).
		 */
		public function size() : uint
		{
			return _q.size();
		}
		
		/**
		 * Adds passed-in loader in loading queue.
		 * 
		 * @param	loader	Concrete loader instance to add into queue
		 * @param	name	An identifier for this loader.<br />
		 * 					If name is <code>null</code> a auto generated id is defined;<br/>
		 * 					If name is <code>null<code> url argument is ignored, so be sure to 
		 * 					defined it directly within the passed-in loader.
		 * @param	url		URL to load.<br />
		 * 					Ignored if <code>name</code> is <code>null</code>
		 * @param	context	(optional) Context to use for passed-in loader.
		 * 
		 * @return	<code>true</code> if loader was successfully added in queue.<br />
		 * 			( eq loader name is not <code>null</code> after identifier checking ).
		 * 
		 * @example Complete sub loader definition
		 * <pre class="prettyprint">
		 * 
		 * var gl : GraphicLoader = new GraphicLoader( container );
		 * gl.setURL( new URLRequest( "logo.jpg" ) );
		 * 
		 * var q : QueueLoader : new QueueLoader();
		 * q.add( gl );
		 * q.load();
		 * </pre>
		 * 
		 * @example Shorter
		 * var q : QueueLoader = new QueueLoader();
		 * q.add( new GraphicLoader( container ), "logo", new URLRequest( "logo.jpg" ) );
		 * q.load();
		 * </pre>
		 */
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
		
		/**
		 * Process next element in queue.
		 */
		public function loadNextEntry() : void
		{
			removeListeners() ;
			
			_currentLoader = _q.poll() as Loader ;

			if ( isAntiCache() ) _currentLoader.setAntiCache( true );
			if ( _sPrefixURL ) _currentLoader.prefixURL( _sPrefixURL );

			addListeners() ;

			_currentLoader.execute() ;
		}
		
		/**
		 * Registers listeners for current loader in queue.
		 */
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
		
		/**
		 * Unregisters listeners for current loader in queue.
		 */
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
		
		/**
		 * Triggered when a loader ( in queue ) starts loading.
		 * 
		 * <p>Fires event type : <code>QueueLoaderEvent.onItemLoadStartEVENT</code></p>
		 * 
		 * @param	e		Event received
		 * @param	rest	Optional arguments
		 */
		public function onLoaderLoadStart( e : LoaderEvent, ... rest ) : void
		{
			fireEventType( QueueLoaderEvent.onItemLoadStartEVENT ) ;
		}
		
		/**
		 * Triggered when a loader ( in queue ) is finished.
		 * 
		 * <p>Fires event type : <code>QueueLoaderEvent.onItemLoadInitEVENT</code></p>
		 * 
		 * <p>Process next element in queue.</p>
		 * 
		 * @param	e		Event received
		 * @param	rest	Optional arguments
		 */
		public function onLoaderLoadInit( e : LoaderEvent, ... rest ) : void
		{
			fireEventType( QueueLoaderEvent.onItemLoadInitEVENT ) ;
			_processQueue();
		}
		
		/**
		 * Triggered during loading progression
		 * 
		 * <p>Fires event type : <code>QueueLoaderEvent.onLoadProgress</code></p>
		 * 
		 * @param	e	Event received
		 */
		public function onLoaderLoadProgress( e : LoaderEvent, ... rest ) : void
		{
			fireEventType( e.type );
		}
		
		/**
		 * Triggered when a timeout limit occur
		 * 
		 * <p>Fires event type : <code>QueueLoaderEvent.onLoadTimeOutEVENT</code></p>
		 * 
		 * @param	e	Event received
		 */
		public function onLoaderLoadTimeOut( e : LoaderEvent, ... rest ) : void
		{
			fireEventType( e.type );
			_processQueue();
		}
		
		/**
		 * Triggered when an error occur
		 * 
		 * <p>Fires event type : <code>QueueLoaderEvent.onLoadErrorEVENT</code></p>
		 * 
		 * @param	e	Event received
		 */
		public function onLoaderLoadError( e : LoaderEvent, ... rest ) : void
		{
			fireEventType( e.type, e.getErrorMessage() );
			_processQueue();
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function getLoaderEvent( type : String, errorMessage : String = "" ) : LoaderEvent
		{
			return new QueueLoaderEvent( type, this, errorMessage );
		}
		
		private function _onLoadStart() : void
		{
			fireOnLoadStartEvent();
		}
		
		/**
		 * Checks if there is a next element to load.
		 */
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