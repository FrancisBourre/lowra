package com.bourre.ioc.assembler.displayobject 
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	
	import com.bourre.collection.HashMap;
	import com.bourre.core.CoreFactory;
	import com.bourre.error.IllegalArgumentException;
	import com.bourre.error.IllegalStateException;
	import com.bourre.events.EventBroadcaster;
	import com.bourre.events.ValueObject;
	import com.bourre.ioc.bean.BeanFactory;
	import com.bourre.ioc.parser.ContextNodeNameList;
	import com.bourre.ioc.parser.ContextTypeList;
	import com.bourre.load.GraphicLoader;
	import com.bourre.load.GraphicLoaderEvent;
	import com.bourre.load.GraphicLoaderLocator;
	import com.bourre.load.Loader;
	import com.bourre.load.LoaderEvent;
	import com.bourre.load.QueueLoader;
	import com.bourre.load.QueueLoaderEvent;
	import com.bourre.log.PixlibDebug;
	import com.bourre.log.PixlibStringifier;	

	public class DefaultDisplayObjectBuilder 
		implements DisplayObjectBuilder
	{
		protected var _target						: DisplayObjectContainer;
		protected var _oEB 						: EventBroadcaster;
		protected var _dllQueue 					: QueueLoader;
		protected var _gfxQueue 					: QueueLoader;
		protected var _mDisplayObject				: HashMap;
		protected var _glDisplayLoader 			: GraphicLoader;

		public static const SPRITE : String = ContextTypeList.SPRITE;
		public static const MOVIECLIP : String = ContextTypeList.MOVIECLIP;
		public static const TEXTFIELD : String = ContextTypeList.TEXTFIELD;

		public function DefaultDisplayObjectBuilder( rootTarget : DisplayObjectContainer = null )
		{
			if  ( rootTarget != null ) setRootTarget( rootTarget );

			_dllQueue = new QueueLoader();
			_gfxQueue = new QueueLoader();
			_mDisplayObject = new HashMap();

			_oEB = new EventBroadcaster( this, DisplayObjectBuilderListener );
		}
		
		public function size() : uint
		{
			return _dllQueue.size() + _gfxQueue.size();
		}

		public function setRootTarget( target : DisplayObjectContainer ) : void
		{
			if ( BeanFactory.getInstance().isRegistered( ContextNodeNameList.ROOT ) )
			{
				var msg : String = this + ".setRootTarget call failed. Root is already registered.";
				PixlibDebug.ERROR( msg );
				throw( new IllegalStateException( msg ) );

			} else
			{
				_target = target;
				BeanFactory.getInstance().register( ContextNodeNameList.ROOT, _target );
	
				try
				{
					var param : Object = LoaderInfo( _target.root.loaderInfo ).parameters;
					for ( var p : * in param ) BeanFactory.getInstance().register( "flashvars::" + p,  param[ p ] );

				} catch ( e : Error )
				{
					//
				}

				_mDisplayObject.put( ContextNodeNameList.ROOT, new DisplayObjectInfo ( ContextNodeNameList.ROOT ) );
			}
		}

		public function getRootTarget() : DisplayObjectContainer
		{
			return _target;
		}

		public function buildDisplayLoader( valueObject : ValueObject ) : void
		{
			var displayLoaderInfo : DisplayLoaderInfo = valueObject as DisplayLoaderInfo;

			_glDisplayLoader = new GraphicLoader( null, -1, true );
			_glDisplayLoader.setURL( displayLoaderInfo.url );
			_glDisplayLoader.addEventListener( GraphicLoaderEvent.onLoadInitEVENT, onDisplayLoaderInit, displayLoaderInfo );
			_glDisplayLoader.addEventListener( GraphicLoaderEvent.onLoadErrorEVENT, qlOnLoadError );
			_glDisplayLoader.addEventListener( GraphicLoaderEvent.onLoadTimeOutEVENT, qlOnLoadTimeOut );
		}

		public function buildDLL ( valueObject : ValueObject ) : void
		{
			var info : DisplayObjectInfo = valueObject as DisplayObjectInfo;

			var gl : GraphicLoader = new GraphicLoader( null, -1, false );
			_dllQueue.add( gl, "DLL" + _dllQueue.size(), info.url, new LoaderContext( false, ApplicationDomain.currentDomain ) );
		}
		
		public function buildDisplayObject( valueObject : ValueObject ) : void
		{
			var info : DisplayObjectInfo = valueObject as DisplayObjectInfo;

			if ( !info.isEmptyDisplayObject() )
			{
				var gl : GraphicLoader = new GraphicLoader( null, -1, info.isVisible );
				_gfxQueue.add( gl, info.ID, info.url, new LoaderContext( false, ApplicationDomain.currentDomain ) );
			}
			
			_mDisplayObject.put( info.ID, info );
			if ( _mDisplayObject.containsKey( info.parentID ) ) _mDisplayObject.get( info.parentID ).addChild( info );
		}

		public function execute( e : Event = null ) : void
		{
			fireEvent( DisplayObjectBuilderEvent.onDisplayObjectBuilderLoadStartEVENT );
			
			if ( _glDisplayLoader != null )
			{
				_glDisplayLoader.execute();

			} else
			{
				loadDLLQueue();
			}
		}

		protected function fireEvent( type : String, loader : Loader = null, errorMessage : String = null ) : void
		{
			var e : DisplayObjectBuilderEvent = new DisplayObjectBuilderEvent( type, loader, errorMessage );
			_oEB.broadcastEvent( e );
		}

		public function onDisplayLoaderInit( e : GraphicLoaderEvent, displayLoaderInfo : DisplayLoaderInfo ) : void
		{
			( e.getLoader() as GraphicLoader ).setTarget( getRootTarget() );
			loadDLLQueue();
		}

		public function loadDLLQueue() : void
		{
			if ( !(_executeQueueLoader( _dllQueue, onDLLLoadStart, onDLLLoadInit )) ) loadDisplayObjectQueue();
		}

		public function onDLLLoadStart( e : LoaderEvent ) : void
		{
			fireEvent( DisplayObjectBuilderEvent.onDLLLoadStartEVENT, e.getLoader() );
		}
		
		public function onDLLLoadInit( e : LoaderEvent ) : void
		{
			fireEvent( DisplayObjectBuilderEvent.onDLLLoadInitEVENT, e.getLoader() );
			loadDisplayObjectQueue();
		}

		public function loadDisplayObjectQueue() : void
		{
			if ( !(_executeQueueLoader( _gfxQueue, onDisplayObjectLoadStart, onDisplayObjectLoadInit )) ) buildDisplayList();
		}
		
		public function onDisplayObjectLoadStart( e : LoaderEvent ) : void
		{
			fireEvent( DisplayObjectBuilderEvent.onDisplayObjectLoadStartEVENT, e.getLoader() );
		}
		
		public function onDisplayObjectLoadInit( e : LoaderEvent ) : void
		{
			fireEvent( DisplayObjectBuilderEvent.onDisplayObjectLoadInitEVENT, e.getLoader() );
			buildDisplayList();
		}
		
		private function _executeQueueLoader( ql : QueueLoader, startCallback : Function, endCallback : Function ) : Boolean
		{
			if ( ql.size() > 0 )
			{
				ql.addEventListener( QueueLoaderEvent.onItemLoadStartEVENT, qlOnLoadStart );
				ql.addEventListener( QueueLoaderEvent.onItemLoadInitEVENT, qlOnLoadInit );
				ql.addEventListener( QueueLoaderEvent.onLoadProgressEVENT, qlOnLoadProgress );
				ql.addEventListener( QueueLoaderEvent.onLoadTimeOutEVENT, qlOnLoadTimeOut );
				ql.addEventListener( QueueLoaderEvent.onLoadErrorEVENT, qlOnLoadError );
				ql.addEventListener( QueueLoaderEvent.onLoadStartEVENT, startCallback );
				ql.addEventListener( QueueLoaderEvent.onLoadInitEVENT, endCallback );
				ql.execute();

				return true;

			} else
			{
				return false;
			}
		}
		
		public function buildDisplayList() : void
		{
			_buildDisplayList( ContextNodeNameList.ROOT );
			fireEvent( DisplayObjectBuilderEvent.onDisplayObjectBuilderLoadInitEVENT );
		}

		private function _buildDisplayList( ID : String ) : void
		{
			var info : DisplayObjectInfo = _mDisplayObject.get( ID );

			if ( info != null )
			{
				if ( ID != ContextNodeNameList.ROOT )
				{
					if ( info.isEmptyDisplayObject() )
					{
						if ( !_buildEmptyDisplayObject( info ) ) return ;

					} else
					{
						if ( !_buildDisplayObject( info ) ) return;
					}
				}

				// recursivity
				if ( info.hasChild() )
				{
					var aChild : Array = info.getChild();
					var l : int = aChild.length;
					for ( var i : int = 0 ; i < l ; i++ ) _buildDisplayList( aChild[i].ID );
				}
			}
		}

		protected function _buildEmptyDisplayObject( info : DisplayObjectInfo ) : Boolean
		{
			try
			{
				var oParent : DisplayObjectContainer = BeanFactory.getInstance().locate( info.parentID ) as DisplayObjectContainer;

				var oDo : DisplayObject = CoreFactory.buildInstance( info.type ) as DisplayObject;

				if ( !(oDo is DisplayObject) )
				{
					var msg : String = this + ".buildDisplayList() failed. '" + info.type + "' doesn't extend DisplayObject.";
					PixlibDebug.ERROR( msg );
					throw new IllegalArgumentException( msg );
				}

				oParent.addChild( oDo );
				BeanFactory.getInstance().register( info.ID, oDo );

				_oEB.broadcastEvent( new DisplayObjectEvent( DisplayObjectEvent.onBuildDisplayObjectEVENT, oDo ) );
				return true;

			} catch ( e : Error )
			{
				return false;
			}
			
			return false;
		}

		protected function _buildDisplayObject( info : DisplayObjectInfo ) : Boolean
		{
			try
			{
				var gl : GraphicLoader = GraphicLoaderLocator.getInstance().getGraphicLoader( info.ID );
				var parent : DisplayObjectContainer = BeanFactory.getInstance().locate( info.parentID ) as DisplayObjectContainer;
				
				gl.setTarget( parent );
				if ( info.isVisible ) gl.show();
				BeanFactory.getInstance().register( info.ID, gl.getView() );
	
				_oEB.broadcastEvent( new DisplayObjectEvent( DisplayObjectEvent.onBuildDisplayObjectEVENT, gl.getView() ) );
				return true;

			} catch ( e : Error )
			{
				return false;
			}
			
			return false;
		}


		// QueueLoader callbacks
		public function qlOnLoadStart( e : LoaderEvent ) : void
		{
			fireEvent( DisplayObjectBuilderEvent.onLoadStartEVENT, e.getLoader() );
		}

		public function qlOnLoadInit( e : LoaderEvent ) : void
		{
			fireEvent( DisplayObjectBuilderEvent.onLoadInitEVENT, e.getLoader() );
		}

		public function qlOnLoadProgress( e : LoaderEvent ) : void
		{
			fireEvent( DisplayObjectBuilderEvent.onLoadProgressEVENT, e.getLoader() );
		}

		public function qlOnLoadTimeOut( e : LoaderEvent ) : void
		{
			fireEvent( DisplayObjectBuilderEvent.onLoadTimeOutEVENT, e.getLoader() );
		}

		public function qlOnLoadError( e : LoaderEvent ) : void
		{
			fireEvent( DisplayObjectBuilderEvent.onLoadErrorEVENT, e.getLoader(), e.getErrorMessage() );
		}

		/**
		 * Event system
		 */
		public function addListener( listener : DisplayObjectBuilderListener ) : Boolean
		{
			return _oEB.addListener( listener );
		}

		public function removeListener( listener : DisplayObjectBuilderListener ) : Boolean
		{
			return _oEB.removeListener( listener );
		}

		public function addEventListener( type : String, listener : Object, ... rest ) : Boolean
		{
			return _oEB.addEventListener.apply( _oEB, rest.length > 0 ? [ type, listener ].concat( rest ) : [ type, listener ] );
		}

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
	}
}