package com.bourre.ioc.assembler.displayobject
{
	import com.bourre.events.EventBroadcaster;
	import com.bourre.collection.HashMap;
	import com.bourre.load.QueueLoader;
	import com.bourre.load.GraphicLoader;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import com.bourre.ioc.bean.BeanFactory;
	import flash.display.DisplayObject;
	import com.bourre.load.LoaderEvent;
	import com.bourre.load.GraphicLoaderLocator;
	import com.bourre.load.GraphicLoaderEvent;
	import flash.display.Sprite;
	import com.bourre.load.QueueLoaderEvent;
	import flash.net.URLRequest;
	import com.bourre.log.PixlibStringifier;
	import com.bourre.log.PixlibDebug;
	import com.bourre.ioc.bean.BeanEvent;
	import com.bourre.ioc.bean.BeanFactoryListener;
	import com.bourre.ioc.parser.ContextNodeNameList;
	import flash.events.Event;
	
	public class DisplayObjectExpert
	{
		private static var _oI					: DisplayObjectExpert ;
		private var _target						: Sprite ;
		private var _oEB 						: EventBroadcaster ;
		private var _dllQueue 					: QueueLoader ;
		private var _gfxQueue 					: QueueLoader ;
		private var _mGraphicLoader				: HashMap ;
		private var _mDisplayObject				: HashMap ;
		
		public static var onLoadInitEVENT		: String = QueueLoaderEvent.onLoadInitEVENT ; 
		public static var onLoadProgressEVENT	: String = QueueLoaderEvent.onLoadProgressEVENT ; 
		public static var onTimeOutEVENT		: String = QueueLoaderEvent.onLoadTimeOutEVENT ; 
		public static var onLoadCompleteEVENT	: String = QueueLoaderEvent.onLoadCompleteEVENT; 
		
		public static const SPRITE : String = "Sprite";
		public static const MOVIECLIP : String = "MovieClip";
			
		public static function getInstance() : DisplayObjectExpert
		{
			if ( !(DisplayObjectExpert._oI is DisplayObjectExpert) ) 
				DisplayObjectExpert._oI = new DisplayObjectExpert( new PrivateConstructorAccess() );

			return DisplayObjectExpert._oI;
		}
		
		public static function release() : void
		{
			if ( DisplayObjectExpert._oI is DisplayObjectExpert ) DisplayObjectExpert._oI = null;
		}
		
		public function setRootTarget ( target : Sprite ) : void
		{
			/*if(_target is Sprite)
				throw (new Error()) ;
			else*/
			_target = target ;
			BeanFactory.getInstance().register( ContextNodeNameList.ROOT, _target ) ;
			_mDisplayObject.put( ContextNodeNameList.ROOT, new DisplayObjectInfo ( ContextNodeNameList.ROOT ) ) ;
		}
		
		public function DisplayObjectExpert(access:PrivateConstructorAccess)
		{
			_dllQueue = new QueueLoader();
			_gfxQueue = new QueueLoader();
			_mDisplayObject = new HashMap();

			_oEB = new EventBroadcaster( this );
		}
		
		/*public function buildDLL (url:String) : void
		{
			_dllQueue.add( new GraphicLoader(_level0, _dllQueue.length(), false),"DLL", url) ;
		}*/
		
		public function buildGraphicLoader ( 	ID : String, 
												url : String,
												parentID : String = null, 
												depth : int = -1, 
												isVisible : Boolean = true, 
												type : String="Movieclip" ) : void
		{
			var info : DisplayObjectInfo = new DisplayObjectInfo( ID, parentID, depth, isVisible, url, type );
			
			var gl:GraphicLoader = new GraphicLoader( null, depth, false );
			_gfxQueue.add( gl, ID, new URLRequest( url ) ) ;

			_mDisplayObject.put( ID, info ) ;

			if ( _mDisplayObject.containsKey( parentID ) )
				_mDisplayObject.get( parentID ).addChild( info ) ;
		}
		
		public function buildEmptyDisplayObject( 	ID : String, 
													parentID : String = null, 
													depth : int = -1,
													isVisible : Boolean = true, 
													type:String = "Movieclip" ) : void
		{
			if ( parentID == null ) parentID = ContextNodeNameList.ROOT ;
				
			var info : DisplayObjectInfo = new DisplayObjectInfo( ID, parentID, depth, isVisible, null, type ) ;
			_mDisplayObject.put( ID, info ) ;

			if ( _mDisplayObject.containsKey( parentID ) )
				_mDisplayObject.get( parentID ).addChild( info );
			
		}
		
		public function load () : void
		{
			_loadDisplayObjectQueue();
		}
		
		/*private function _loadDLLQueue() : void
		{
			if ( _dllQueue.size() > 0 )
			{
				_dllQueue.addEventListener( DisplayObjectExpert.onLoadInitEVENT, _onDLLLoad );
				_dllQueue.addEventListener( DisplayObjectExpert.onLoadProgressEVENT, this );
				_dllQueue.addEventListener( DisplayObjectExpert.onTimeOutEVENT, this );
				_dllQueue.addEventListener( DisplayObjectExpert.onLoadCompleteEVENT, _loadDisplayObjectQueue );
				_dllQueue.execute() ;
			}
			else
				_loadDisplayObjectQueue();
		}
		
		private function _onDLLLoad( e : GraphicLoaderEvent ) : void
		{
			_oEB.broadcastEvent( e );
		}*/
		
		private function _loadDisplayObjectQueue() : void
		{
			if ( _gfxQueue.size() > 0 )
			{
				_gfxQueue.addEventListener(DisplayObjectExpert.onLoadInitEVENT, this) ;
				_gfxQueue.addEventListener(DisplayObjectExpert.onLoadProgressEVENT, this) ;
				_gfxQueue.addEventListener(DisplayObjectExpert.onTimeOutEVENT, this) ;
				_gfxQueue.addEventListener(DisplayObjectExpert.onLoadCompleteEVENT, this) ;
				_gfxQueue.execute() ;
			}
			else
			{
				buildDisplayList();
				_oEB.broadcastEvent( new QueueLoaderEvent( QueueLoaderEvent.onLoadCompleteEVENT, _gfxQueue ) );
			}
		}
		
		protected function buildDisplayList() : void
		{
			displayObjectsTreatment( ContextNodeNameList.ROOT );
		}

		private function displayObjectsTreatment( ID : String ) : void
		{
			var info : DisplayObjectInfo = _mDisplayObject.get( ID );
			
			if ( ID != ContextNodeNameList.ROOT )
			{
				if ( info.isEmptyDisplayObject() )
				{
					_buildEmptyDisplayObject( info );
				}
				else
				{
					_buildDisplayObject( info );
				}
			}

			// recursivity
			if ( info.hasChild() )
			{
				var aChild : Array = info.getChild();
				var l : int = aChild.length;
				for ( var i : int = 0 ; i < l ; i++ ) displayObjectsTreatment( aChild[i].ID );
			}
		}
		
		private function _buildEmptyDisplayObject( info : DisplayObjectInfo ) : void
		{
			var oParent : DisplayObjectContainer = BeanFactory.getInstance().locate( info.parentID ) as DisplayObjectContainer;
			var oDo : Sprite = ( info.type == "Movieclip" ) ? new MovieClip() : new Sprite();
			oParent.addChild( oDo ) ;
			BeanFactory.getInstance().register( info.ID, oDo ) ;
PixlibDebug.INFO( "_buildEmptyDisplayObject(" + info.ID + ", " + oDo + ")" );
			_oEB.broadcastEvent( new DisplayObjectEvent( oDo ) ) ;
		}
		
		private function _buildDisplayObject( info : DisplayObjectInfo ) : void
		{
			var gl : GraphicLoader = GraphicLoaderLocator.getInstance().getGraphicLoader( info.ID ) ;
			var parent : DisplayObjectContainer = BeanFactory.getInstance().locate( info.parentID ) as DisplayObjectContainer;
			gl.setTarget( parent );
			if ( info.isVisible ) gl.show();
			BeanFactory.getInstance().register( info.ID, gl.getView() );

			_oEB.broadcastEvent( new DisplayObjectEvent( gl.getView() ) ) ;
		}
		
		public function onLoadInit( e : LoaderEvent ) : void
		{
			_oEB.broadcastEvent( e );
		}
	
		public function onLoadProgress( e : LoaderEvent ) : void
		{
			_oEB.broadcastEvent( e );
		}
	
		public function onTimeOut( e : LoaderEvent ) : void
		{
			_oEB.broadcastEvent( e );
		}
		
		public function onLoadTimeOut( e : LoaderEvent ) : void
		{
			_oEB.broadcastEvent( e );
		}
		
		public function onLoadComplete( e : LoaderEvent ) : void
		{
			buildDisplayList();
			_oEB.broadcastEvent( e );
		}

		/**
		 * Event system
		 */
		public function addListener( listener : DisplayObjectExpertListener ) : Boolean
		{
			return _oEB.addListener( listener );
		}

		public function removeListener( listener : DisplayObjectExpertListener ) : Boolean
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

internal class PrivateConstructorAccess {}