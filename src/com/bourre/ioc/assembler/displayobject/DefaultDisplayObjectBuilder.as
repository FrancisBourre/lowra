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
	 
package com.bourre.ioc.assembler.displayobject 
{
	import com.bourre.collection.HashMap;	import com.bourre.core.CoreFactory;	import com.bourre.core.HashCodeFactory;	import com.bourre.encoding.Deserializer;	import com.bourre.error.IllegalArgumentException;	import com.bourre.events.EventBroadcaster;	import com.bourre.events.ValueObject;	import com.bourre.events.ValueObjectEvent;	import com.bourre.ioc.assembler.resource.Resource;	import com.bourre.ioc.assembler.resource.ResourceExpert;	import com.bourre.ioc.bean.BeanFactory;	import com.bourre.ioc.bean.BeanUtils;	import com.bourre.ioc.load.ApplicationLoader;	import com.bourre.ioc.load.FlashVarsUtil;	import com.bourre.ioc.parser.ContextNodeNameList;	import com.bourre.ioc.parser.ContextTypeList;	import com.bourre.load.FileLoader;	import com.bourre.load.GraphicLoader;	import com.bourre.load.GraphicLoaderEvent;	import com.bourre.load.GraphicLoaderLocator;	import com.bourre.load.Loader;	import com.bourre.load.LoaderEvent;	import com.bourre.load.QueueLoader;	import com.bourre.load.QueueLoaderEvent;	import com.bourre.log.PixlibDebug;	import com.bourre.log.PixlibStringifier;		import flash.display.DisplayObject;	import flash.display.DisplayObjectContainer;	import flash.display.LoaderInfo;	import flash.events.Event;	import flash.net.URLLoaderDataFormat;	import flash.net.URLRequest;	import flash.system.ApplicationDomain;	import flash.system.LoaderContext;	
	/**
	 *  Dispatched when a context element starts loading.
	 *  
	 *  @eventType com.bourre.ioc.assembler.displayobject.DisplayObjectBuilderEvent.onLoadStartEVENT
	 */
	[Event(name="onLoadStart", type="com.bourre.ioc.assembler.displayobject.DisplayObjectBuilderEvent")]
	
	/**
	 *  Dispatched when a context element loading is finished.
	 *  
	 *  @eventType com.bourre.ioc.assembler.displayobject.DisplayObjectBuilderEvent.onLoadInitEVENT
	 */
	[Event(name="onLoadInit", type="com.bourre.ioc.assembler.displayobject.DisplayObjectBuilderEvent")]
	
	/**
	 *  Dispatched during context element loading progression.
	 *  
	 *  @eventType com.bourre.ioc.assembler.displayobject.DisplayObjectBuilderEvent.onLoadProgressEVENT
	 */
	[Event(name="onLoadProgress", type="com.bourre.ioc.assembler.displayobject.DisplayObjectBuilderEvent")]
	
	/**
	 *  Dispatched when a timemout occurs during context element loading.
	 *  
	 *  @eventType com.bourre.ioc.assembler.displayobject.DisplayObjectBuilderEvent.onLoadTimeOutEVENT
	 */
	[Event(name="onLoadTimeOut", type="com.bourre.ioc.assembler.displayobject.DisplayObjectBuilderEvent")]
	
	/**
	 *  Dispatched when an error occurs during context element loading.
	 *  
	 *  @eventType com.bourre.ioc.assembler.displayobject.DisplayObjectBuilderEvent.onLoadErrorEVENT
	 */
	[Event(name="onLoadErrorEVENT", type="com.bourre.ioc.assembler.displayobject.DisplayObjectBuilderEvent")]
	
	/**
	 *  Dispatched when display list build is processing.
	 *  
	 *  @eventType com.bourre.ioc.assembler.displayobject.DisplayObjectBuilderEvent.onDisplayObjectBuilderLoadStartEVENT
	 */
	[Event(name="onDisplayObjectBuilderLoadStart", type="com.bourre.ioc.assembler.displayobject.DisplayObjectBuilderEvent")]
	
	/**
	 *  Dispatched when display list build is finished.
	 *  
	 *  @eventType com.bourre.ioc.assembler.displayobject.DisplayObjectBuilderEvent.onDisplayObjectBuilderLoadInitEVENT
	 */
	[Event(name="onDisplayObjectBuilderLoadInit", type="com.bourre.ioc.assembler.displayobject.DisplayObjectBuilderEvent")]
	
	/**
	 *  Dispatched when engine starts display list treatment.
	 *  
	 *  @eventType com.bourre.ioc.assembler.displayobject.DisplayObjectBuilderEvent.onDisplayObjectLoadStartEVENT
	 */
	[Event(name="onDisplayObjectLoadStart", type="com.bourre.ioc.assembler.displayobject.DisplayObjectBuilderEvent")]
	
	/**
	 *  Dispatched when display list treatment is finished. 
	 *  
	 *  @eventType com.bourre.ioc.assembler.displayobject.DisplayObjectBuilderEvent.onDisplayObjectLoadInitEVENT
	 */
	[Event(name="onDisplayObjectLoadInit", type="com.bourre.ioc.assembler.displayobject.DisplayObjectBuilderEvent")]
	
	/**
	 *  Dispatched when engine starts DLL list treatment.
	 *  
	 *  @eventType com.bourre.ioc.assembler.displayobject.DisplayObjectBuilderEvent.onDLLLoadStartEVENT
	 */
	[Event(name="onDLLLoadStart", type="com.bourre.ioc.assembler.displayobject.DisplayObjectBuilderEvent")]
	
	/**
	 *  Dispatched when DLL list treatment is finished. 
	 *  
	 *  @eventType com.bourre.ioc.assembler.displayobject.DisplayObjectBuilderEvent.onDLLLoadInitEVENT
	 */
	[Event(name="onDLLLoadInit", type="com.bourre.ioc.assembler.displayobject.DisplayObjectBuilderEvent")]
	
	/**
	 *  Dispatched when engine starts resources list treatment.
	 *  
	 *  @eventType com.bourre.ioc.assembler.displayobject.DisplayObjectBuilderEvent.onRSCLoadStartEVENT
	 */
	[Event(name="onRSCLoadStart", type="com.bourre.ioc.assembler.displayobject.DisplayObjectBuilderEvent")]
	
	/**
	 *  Dispatched when resources list treatment is finished. 
	 *  
	 *  @eventType com.bourre.ioc.assembler.displayobject.DisplayObjectBuilderEvent.onRSCLoadInitEVENT
	 */
	[Event(name="onRSCLoadInit", type="com.bourre.ioc.assembler.displayobject.DisplayObjectBuilderEvent")]
	
	/**
	 * Default display object builder implementation.
	 * 
	 * @author Francis Bourre
	 */
	public class DefaultDisplayObjectBuilder implements DisplayObjectBuilder
	{
		//--------------------------------------------------------------------
		// Constants
		//--------------------------------------------------------------------
		
		public static const SPRITE : String = ContextTypeList.SPRITE;
		public static const MOVIECLIP : String = ContextTypeList.MOVIECLIP;
		public static const TEXTFIELD : String = ContextTypeList.TEXTFIELD;

		
		//--------------------------------------------------------------------
		// Protected properties
		//--------------------------------------------------------------------
		
		/** @private */
		protected var _target : DisplayObjectContainer;
		
		/** @private */
		protected var _rootID : String;
		
		/** @private */
		protected var _oEB : EventBroadcaster;
		
		/** @private */
		protected var _dllQueue : QueueLoader;		
		/** @private */
		protected var _rscQueue : QueueLoader;
		
		/** @private */
		protected var _gfxQueue : QueueLoader;
		
		/** @private */
		protected var _mDisplayObject : HashMap;
		
		/** @private */
		protected var _glDisplayLoader : GraphicLoader;
		
		/** @private */
		protected var _bIsAntiCache : Boolean;

				
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
		
		/**
		 * Creates instance.
		 */
		public function DefaultDisplayObjectBuilder( rootTarget : DisplayObjectContainer = null )
		{
			if  ( rootTarget != null ) setRootTarget( rootTarget );

			_dllQueue = new QueueLoader( );			_rscQueue = new QueueLoader( );
			_gfxQueue = new QueueLoader( );
			
			_mDisplayObject = new HashMap( );
			
			_oEB = new EventBroadcaster( this, DisplayObjectBuilderListener );
			
			_bIsAntiCache = false;
		}

		/**
		 * @inheritDoc
		 */		public function setAntiCache( b : Boolean ) : void
		{
			_bIsAntiCache = b;
			
			_dllQueue.setAntiCache( b );			_rscQueue.setAntiCache( b );
			_gfxQueue.setAntiCache( b );
		}

		/**
		 * @inheritDoc
		 */		public function isAntiCache() : Boolean
		{
			return _bIsAntiCache;
		}

		/**
		 * Returns the root registration ID.
		 */
		public function getRootID() : String
		{
			return _rootID ? _rootID : generateRootID( );
		}

		/**
		 * @inheritDoc
		 */		public function size() : uint
		{
			return _dllQueue.size( ) + _gfxQueue.size( ) + _rscQueue.size( );
		}

		/**
		 * @inheritDoc
		 */
		public function setRootTarget( target : DisplayObjectContainer ) : void
		{
			if ( target is DisplayObjectContainer )
			{
				_target = target;
					
				try
				{
					var param : Object = LoaderInfo( _target.root.loaderInfo ).parameters;
					for ( var p : * in param ) 
					{
						if(!BeanFactory.getInstance( ).isRegistered( FlashVarsUtil.FLASHVARS + p ))
						{
							if( ApplicationLoader.DEBUG_LOADING_ENABLED )
								PixlibDebug.DEBUG( this + "::registred static flashvars ::" + p + " -> " + param[p] );
							
							BeanFactory.getInstance( ).register( FlashVarsUtil.FLASHVARS + p, param[ p ] );
						}
					}
				} catch ( e : Error )
				{
					//
				}
			} 			else
			{
				var msg : String = this + ".setRootTarget call failed. Argument is not a DisplayObjectContainer.";
				PixlibDebug.ERROR( msg );
				throw( new IllegalArgumentException( msg ) );
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function getRootTarget() : DisplayObjectContainer
		{
			return _target;
		}
		
		/**
		 * @inheritDoc
		 */
		public function getURLRequest( request : URLRequest, prefix : String = null ) : URLRequest
		{
			return ApplicationLoader.getURLRequest( request, prefix );
		}
		
		/**
		 * @inheritDoc
		 */
		public function buildDisplayLoader( valueObject : ValueObject ) : void
		{
			var displayLoaderInfo : DisplayLoaderInfo = valueObject as DisplayLoaderInfo;

			_glDisplayLoader = new GraphicLoader( null, -1, true );
			_glDisplayLoader.setURL( displayLoaderInfo.url );
			_glDisplayLoader.addEventListener( GraphicLoaderEvent.onLoadInitEVENT, onDisplayLoaderInit, displayLoaderInfo );
			_glDisplayLoader.addEventListener( GraphicLoaderEvent.onLoadErrorEVENT, qlOnLoadError );
			_glDisplayLoader.addEventListener( GraphicLoaderEvent.onLoadTimeOutEVENT, qlOnLoadTimeOut );
		}

		/**
		 * @inheritDoc
		 */
		public function buildDLL( valueObject : ValueObject ) : void
		{
			var info : DisplayObjectInfo = valueObject as DisplayObjectInfo;
			
			info.url = getURLRequest( info.url, FlashVarsUtil.getDLLPathKey( ) );

			var gl : GraphicLoader = new GraphicLoader( null, -1, false );
			_dllQueue.add( gl, ContextNodeNameList.DLL + HashCodeFactory.getNextKey(), info.url, new LoaderContext( false, ApplicationDomain.currentDomain ) );
		}
		
		/**
		 * @inheritDoc
		 */
		public function buildResource( valueObject : ValueObject) : void
		{
			var info : Resource = valueObject as Resource;
			var loader : FileLoader = new FileLoader( );
			
			if( info.type == URLLoaderDataFormat.BINARY )
			{
				loader.setDataFormat( URLLoaderDataFormat.BINARY );
			}
			
			info.url = getURLRequest( info.url, FlashVarsUtil.getResourcePathKey( ) );
			
			ResourceExpert.getInstance().register( info.id, info );
			
			_rscQueue.add( loader, info.id, info.url, new LoaderContext( false, ApplicationDomain.currentDomain ) );
		}
		
		/**
		 * @inheritDoc
		 */
		public function buildDisplayObject( valueObject : ValueObject ) : void
		{
			var info : DisplayObjectInfo = valueObject as DisplayObjectInfo;
			
			if ( !info.isEmptyDisplayObject( ) )
			{
				info.url = getURLRequest( info.url, FlashVarsUtil.getGFXPathKey( ) );
				
				var gl : GraphicLoader = new GraphicLoader( null, -1, info.isVisible );
				_gfxQueue.add( gl, info.ID, info.url, new LoaderContext( false, ApplicationDomain.currentDomain ) );
			}
			
			_mDisplayObject.put( info.ID, info );

			if ( info.parentID ) 
			{
				_mDisplayObject.get( info.parentID ).addChild( info );
			} 			else
			{
				_rootID = info.ID;
			}
		}
		
		/**
		 * Builds display list.
		 */
		public function buildDisplayList() : void
		{
			var bf : BeanFactory = BeanFactory.getInstance();
			
			if( !bf.isRegistered( getRootID() ) && !bf.isBeanRegistered( _target ) ) 
			{
				bf.register( getRootID( ), _target );
				
				if( !bf.isRegistered( BeanUtils.APPLICATION_CONTAINER_NAME ) )
				{
					bf.register( BeanUtils.APPLICATION_CONTAINER_NAME, getRootID( ) );
				}
			}
			else
			{
				PixlibDebug.WARN( this + "::display ID already registered :" + getRootID() );
			}
			
			_buildDisplayList( getRootID( ) );
			fireEvent( DisplayObjectBuilderEvent.onDisplayObjectBuilderLoadInitEVENT );
		}

		/**
		 * Starts processing.
		 */
		public function execute( e : Event = null ) : void
		{
			if ( _glDisplayLoader != null )
			{
				_glDisplayLoader.execute( );
			} 			else
			{
				fireEvent( DisplayObjectBuilderEvent.onDisplayObjectBuilderLoadStartEVENT );
				loadDLLQueue( );
			}
		}

		/**
		 * Triggered when display loader is loaded.
		 */
		public function onDisplayLoaderInit( e : GraphicLoaderEvent, displayLoaderInfo : DisplayLoaderInfo ) : void
		{
			var glLoader : GraphicLoader = e.getLoader( ) as GraphicLoader;
			
			glLoader.setTarget( getRootTarget( ) );
			
			_oEB.broadcastEvent( new ValueObjectEvent( DisplayObjectBuilderEvent.onDisplayLoaderInitEVENT, glLoader.getView( ), displayLoaderInfo ) );
			
			fireEvent( DisplayObjectBuilderEvent.onDisplayObjectBuilderLoadStartEVENT );
			
			loadDLLQueue( );
		}

		/**
		 * Loads DLL queue.( if any ).
		 * 
		 * <p>If queue is empty, pass to <code>loadRSCQueue()</code> method.</p>
		 * 
		 * @see #loadRSCQueue()
		 */
		public function loadDLLQueue() : void
		{
			if ( !(_executeQueueLoader( _dllQueue, onDLLLoadStart, onDLLLoadInit )) ) loadRSCQueue( );
		}
		
		/**
		 * Triggered when DLL queue starts loading.
		 */
		public function onDLLLoadStart( e : LoaderEvent ) : void
		{
			fireEvent( DisplayObjectBuilderEvent.onDLLLoadStartEVENT, e.getLoader( ) );
		}
		
		/**
		 * Triggered when DLL queue loading is finished.
		 */
		public function onDLLLoadInit( e : LoaderEvent ) : void
		{
			fireEvent( DisplayObjectBuilderEvent.onDLLLoadInitEVENT, e.getLoader( ) );
			loadRSCQueue( );
		}

		/**
		 * Loads Resources queue.( if any ).
		 * 
		 * <p>If queue is empty, pass to <code>loadDisplayObjectQueue()</code> method.</p>
		 * 
		 * @see #loadDisplayObjectQueue()
		 */
		public function loadRSCQueue() : void
		{
			if ( !(_executeRSCQueueLoader( _rscQueue, onRSCLoadStart, onRSCLoadInit )) ) loadDisplayObjectQueue( );
		}

		/**
		 * Triggered when Resources queue starts loading.
		 */		public function onRSCLoadStart( e : LoaderEvent ) : void
		{
			fireEvent( DisplayObjectBuilderEvent.onRSCLoadStartEVENT, e.getLoader( ) );
		}

		/**
		 * Triggered when Resources queue loading is finished.
		 */		public function onRSCLoadInit( e : LoaderEvent ) : void
		{
			fireEvent( DisplayObjectBuilderEvent.onRSCLoadInitEVENT, e.getLoader( ) );
			
			ResourceExpert.release();
			
			loadDisplayObjectQueue( );
		}

		/**
		 * Loads Display objects queue.( if any ).
		 * 
		 * <p>If queue is empty, pass to <code>buildDisplayList()</code> method.</p>
		 * 
		 * @see #buildDisplayList()
		 */
		public function loadDisplayObjectQueue() : void
		{
			if ( !(_executeQueueLoader( _gfxQueue, onDisplayObjectLoadStart, onDisplayObjectLoadInit )) ) buildDisplayList( );
		}

		/**
		 * Triggered when Display objects queue starts loading.
		 */
		public function onDisplayObjectLoadStart( e : LoaderEvent ) : void
		{
			fireEvent( DisplayObjectBuilderEvent.onDisplayObjectLoadStartEVENT, e.getLoader( ) );
		}

		/**
		 * Triggered when Display objects queue loading is finished.
		 */
		public function onDisplayObjectLoadInit( e : LoaderEvent ) : void
		{
			fireEvent( DisplayObjectBuilderEvent.onDisplayObjectLoadInitEVENT, e.getLoader( ) );
			
			buildDisplayList( );
		}

		/**
		 * Triggered when an element contains in queues starts loading.
		 */
		public function qlOnLoadStart( e : LoaderEvent ) : void
		{
			fireEvent( DisplayObjectBuilderEvent.onLoadStartEVENT, e.getLoader( ) );
		}

		/**
		 * Triggered when an element contains in queues stops loading.
		 */
		public function qlOnLoadInit( e : LoaderEvent ) : void
		{
			fireEvent( DisplayObjectBuilderEvent.onLoadInitEVENT, e.getLoader( ) );
		}

		/**
		 * Triggered when an element ( resources only ) contains in queues stops loading.
		 */
		public function qlOnRSCLoadInit( e : QueueLoaderEvent ) : void
		{
			var loader : FileLoader = FileLoader( e.getLoader( ) );
			var ID : String = loader.getName();
			var content : Object = loader.getContent();
			var resource : Resource = ResourceExpert.getInstance().locate( ID ) as Resource;
			
			if( resource.hasDeserializer() )
			{
				try
				{
					var deserializer : Deserializer = CoreFactory.buildInstance( resource.deserializerClass ) as Deserializer;
					content = deserializer.deserialize( content );
				}
				catch( err : Error )
				{
					PixlibDebug.ERROR( this + "::" + err.message );
				}
			}
			
			BeanFactory.getInstance( ).register( loader.getName( ), content );
			
			fireEvent( DisplayObjectBuilderEvent.onLoadInitEVENT, e.getLoader( ) );
		}

		/**
		 * Triggered during element, contained in queues, loading progession.
		 */
		public function qlOnLoadProgress( e : LoaderEvent ) : void
		{
			fireEvent( DisplayObjectBuilderEvent.onLoadProgressEVENT, e.getLoader( ) );
		}

		/**
		 * Triggered when a timout occurs during element, contained in 
		 * queues, loading.
		 */
		public function qlOnLoadTimeOut( e : LoaderEvent ) : void
		{
			fireEvent( DisplayObjectBuilderEvent.onLoadTimeOutEVENT, e.getLoader( ) );
		}

		/**
		 * Triggered when an error occurs during element, contained in 
		 * queues, fail.
		 */
		public function qlOnLoadError( e : LoaderEvent ) : void
		{
			fireEvent( DisplayObjectBuilderEvent.onLoadErrorEVENT, e.getLoader( ), e.getErrorMessage( ) );
		}

		/**
		 * @inheritDoc
		 */
		public function addListener( listener : DisplayObjectBuilderListener ) : Boolean
		{
			return _oEB.addListener( listener );
		}

		/**
		 * @inheritDoc
		 */
		public function removeListener( listener : DisplayObjectBuilderListener ) : Boolean
		{
			return _oEB.removeListener( listener );
		}

		/**
		 * @inheritDoc
		 */
		public function addEventListener( type : String, listener : Object, ... rest ) : Boolean
		{
			return _oEB.addEventListener.apply( _oEB, rest.length > 0 ? [ type, listener ].concat( rest ) : [ type, listener ] );
		}

		/**
		 * @inheritDoc
		 */
		public function removeEventListener( type : String, listener : Object ) : Boolean
		{
			return _oEB.removeEventListener( type, listener );
		}

		/**
		 * Returns the string representation of this instance.
		 * @return the string representation of this instance
		 */
		public function toString() : String
		{
			return PixlibStringifier.stringify( this );
		}

		
		//--------------------------------------------------------------------
		// Protected methods
		//--------------------------------------------------------------------
		
		/**
		 * Generates an unique registration ID for root object.
		 */
		protected function generateRootID() : String
		{
			_rootID = HashCodeFactory.getKey( this );
			return _rootID;
		}
		
		/**
		 * Broadcasts event.
		 */
		protected function fireEvent( type : String, loader : Loader = null, errorMessage : String = null ) : void
		{
			var e : DisplayObjectBuilderEvent = new DisplayObjectBuilderEvent( type, loader, errorMessage );
			_oEB.broadcastEvent( e );
		}

		/**
		 * Creates empty display object. ( container ).
		 */
		protected function _buildEmptyDisplayObject( info : DisplayObjectInfo ) : Boolean
		{
			try
			{
				var oParent : DisplayObjectContainer = BeanFactory.getInstance( ).locate( info.parentID ) as DisplayObjectContainer;

				var oDo : DisplayObject = CoreFactory.buildInstance( info.type ) as DisplayObject;

				if ( !(oDo is DisplayObject) )
				{
					var msg : String = this + ".buildDisplayList() failed. '" + info.type + "' doesn't extend DisplayObject.";
					PixlibDebug.ERROR( msg );
					throw new IllegalArgumentException( msg );
				}
				
				oDo.name = info.ID;
				
				oParent.addChild( oDo );
				BeanFactory.getInstance( ).register( info.ID, oDo );

				_oEB.broadcastEvent( new DisplayObjectEvent( DisplayObjectEvent.onBuildDisplayObjectEVENT, oDo ) );
				return true;
			} catch ( e : Error )
			{
				return false;
			}
			
			return false;
		}

		/**
		 * Builds the display list as it is defined in xml context tree.
		 */
		protected function _buildDisplayObject( info : DisplayObjectInfo ) : Boolean
		{
			try
			{
				var gl : GraphicLoader = GraphicLoaderLocator.getInstance( ).getGraphicLoader( info.ID );
				var parent : DisplayObjectContainer = BeanFactory.getInstance( ).locate( info.parentID ) as DisplayObjectContainer;
				
				gl.setTarget( parent );
				if ( info.isVisible ) gl.show( );
				BeanFactory.getInstance( ).register( info.ID, gl.getView( ) );
	
				_oEB.broadcastEvent( new DisplayObjectEvent( DisplayObjectEvent.onBuildDisplayObjectEVENT, gl.getView( ) ) );
				return true;
			} catch ( e : Error )
			{
				return false;
			}
			
			return false;
		}
		
		
		//--------------------------------------------------------------------
		// Private implementation
		//--------------------------------------------------------------------

		private function _executeRSCQueueLoader( ql : QueueLoader, startCallback : Function, endCallback : Function ) : Boolean
		{
			if ( ql.size( ) > 0 )
			{
				ql.addEventListener( QueueLoaderEvent.onItemLoadStartEVENT, qlOnLoadStart );
				ql.addEventListener( QueueLoaderEvent.onItemLoadInitEVENT, qlOnRSCLoadInit );
				ql.addEventListener( QueueLoaderEvent.onLoadProgressEVENT, qlOnLoadProgress );
				ql.addEventListener( QueueLoaderEvent.onLoadTimeOutEVENT, qlOnLoadTimeOut );
				ql.addEventListener( QueueLoaderEvent.onLoadErrorEVENT, qlOnLoadError );
				ql.addEventListener( QueueLoaderEvent.onLoadStartEVENT, startCallback );
				ql.addEventListener( QueueLoaderEvent.onLoadInitEVENT, endCallback );
				ql.execute( );

				return true;
			} 			else
			{
				return false;
			}
		}

		private function _executeQueueLoader( ql : QueueLoader, startCallback : Function, endCallback : Function ) : Boolean
		{
			if ( ql.size( ) > 0 )
			{
				ql.addEventListener( QueueLoaderEvent.onItemLoadStartEVENT, qlOnLoadStart );
				ql.addEventListener( QueueLoaderEvent.onItemLoadInitEVENT, qlOnLoadInit );
				ql.addEventListener( QueueLoaderEvent.onLoadProgressEVENT, qlOnLoadProgress );
				ql.addEventListener( QueueLoaderEvent.onLoadTimeOutEVENT, qlOnLoadTimeOut );
				ql.addEventListener( QueueLoaderEvent.onLoadErrorEVENT, qlOnLoadError );
				ql.addEventListener( QueueLoaderEvent.onLoadStartEVENT, startCallback );
				ql.addEventListener( QueueLoaderEvent.onLoadInitEVENT, endCallback );
				ql.execute( );

				return true;
			} 			else
			{
				return false;
			}
		}

		private function _buildDisplayList( ID : String ) : void
		{
			var info : DisplayObjectInfo = _mDisplayObject.get( ID );

			if ( info != null )
			{
				if ( ID != getRootID( ) )
				{
					if ( info.isEmptyDisplayObject( ) )
					{
						if ( !_buildEmptyDisplayObject( info ) ) return ;
					} 					else
					{
						if ( !_buildDisplayObject( info ) ) return;
					}
				}
				
				// recursivity
				if ( info.hasChild( ) )
				{
					var aChild : Array = info.getChild( );
					var l : int = aChild.length;
					for ( var i : int = 0 ; i < l ; i++ ) _buildDisplayList( aChild[i].ID );
				}
			}
		}
	}
}