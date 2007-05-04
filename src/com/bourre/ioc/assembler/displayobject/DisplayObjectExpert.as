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
	
	public class DisplayObjectExpert
	{
		private static var _oI					: DisplayObjectExpert ;
		private var _target						: Sprite ;
		private var _oEB 						: EventBroadcaster ;
		private var _dllQueue 					: QueueLoader ;
		private var _gfxQueue 					: QueueLoader ;
		private var _mGraphicLoader				: HashMap ;
		private var _mEmptyDisplayObject		: HashMap ;
		private var _mDisplayObject				: HashMap ;
		
		public static var onLoadInitEVENT		: String = LoaderEvent.onLoadInitEVENT ; 
		public static var onLoadProgressEVENT	: String = LoaderEvent.onLoadProgressEVENT ; 
		public static var onTimeOutEVENT		: String = LoaderEvent.onLoadTimeOutEVENT ; 
		public static var onLoadCompleteEVENT	: String = QueueLoaderEvent.onLoadCompleteEVENT; 
		public static const ROOT_KEY			: String = "root" ;
			
		public static function getInstance():DisplayObjectExpert
		{
			if ( !(DisplayObjectExpert._oI is DisplayObjectExpert) ) 
				DisplayObjectExpert._oI = new DisplayObjectExpert( new PrivateConstructorAccess() );

			return DisplayObjectExpert._oI;
		}
		
		public static function release():void
		{
			if ( DisplayObjectExpert._oI is DisplayObjectExpert ) DisplayObjectExpert._oI = null;
		}
		
		public function setRootTarget (target:Sprite) : void
		{
			if(_target is Sprite)
				throw (new Error()) ;
			else
				_target = target ;
			
			BeanFactory.getInstance().register(DisplayObjectExpert.ROOT_KEY, _target) ;
			
			var o:DisplayObjectInfo = new DisplayObjectInfo (DisplayObjectExpert.ROOT_KEY, null, 0, true, null, "Sprite") ;
			_mDisplayObject.put(DisplayObjectExpert.ROOT_KEY, o) ;
		}
		
		public function DisplayObjectExpert(access:PrivateConstructorAccess)
		{
			_dllQueue = new QueueLoader();
			_gfxQueue = new QueueLoader();
			//_mEmptyMovieClip = new HashMap();
			_mDisplayObject = new HashMap();
			_oEB = EventBroadcaster.getInstance() ;
		}
		
		/*public function buildDLL (url:String) : void
		{
			_dllQueue.add( new GraphicLoader(_level0, _dllQueue.length(), false),"DLL", url) ;
		}*/
		
		public function buildGraphicLoader (name:String, parentID:String, depth:int, isVisible:Boolean, url:String, type:String="Movieclip") : void
		{
			var o:DisplayObjectInfo = new DisplayObjectInfo(name, parentID, depth, isVisible, url, type) ;
			
			var gl:GraphicLoader = new GraphicLoader(null, depth, false) ;
			
			_gfxQueue.add(gl, name, new URLRequest(url)) ;
			
			_mDisplayObject.put(name, o) ;
			if (_mDisplayObject.containsKey(parentID))
				_mDisplayObject.get(parentID).addChild(o) ;
		}
		
		public function buildEmptyDisplayObject(ID:String, parentID:String = null, depth:int=0,type:String="Movieclip"):void
		{
			if (parentID == null)
				parentID = DisplayObjectExpert.ROOT_KEY ;
				
			var o:DisplayObjectInfo = new DisplayObjectInfo(ID, parentID, depth, false,null, type) ;
			_mDisplayObject.put(ID, o) ;

			if (_mDisplayObject.containsKey(parentID))
				_mDisplayObject.get(parentID).addChild(o) ;
			
		}
		
		public function load () : void
		{
			_loadDLLQueue() ;
		}
		
		private function _loadDLLQueue():void
		{
			if (_dllQueue.size() > 0 )
			{
				_dllQueue.addEventListener(DisplayObjectExpert.onLoadInitEVENT, _onDLLLoad) ;
				_dllQueue.addEventListener(DisplayObjectExpert.onLoadProgressEVENT, this) ;
				_dllQueue.addEventListener(DisplayObjectExpert.onTimeOutEVENT, this) ;
				_dllQueue.addEventListener(DisplayObjectExpert.onLoadCompleteEVENT, _loadDisplayObjectQueue) ;
				_dllQueue.execute() ;
			}
			else
				_loadDisplayObjectQueue() ;
		}
		
		private function _onDLLLoad(e:GraphicLoaderEvent):void
		{
			_oEB.broadcastEvent(e) ;
			GraphicLoaderLocator.getInstance().unregister(e.getName()) ;
		}
		
		private function _loadDisplayObjectQueue():void
		{
			if (_gfxQueue.size() >0)
			{
				_gfxQueue.addEventListener(DisplayObjectExpert.onLoadInitEVENT, this) ;
				_gfxQueue.addEventListener(DisplayObjectExpert.onLoadProgressEVENT, this) ;
				_gfxQueue.addEventListener(DisplayObjectExpert.onTimeOutEVENT, this) ;
				_gfxQueue.addEventListener(DisplayObjectExpert.onLoadCompleteEVENT, onLoad) ;
				_gfxQueue.execute() ;
			}
			else
				onLoad(new LoaderEvent(DisplayObjectExpert.onLoadCompleteEVENT, _gfxQueue)) ;
			
		}
		
		public function onLoad (e : LoaderEvent):void
		{
			if (_mDisplayObject.containsKey(DisplayObjectExpert.ROOT_KEY))
			{
				displayObjectsTreatment(DisplayObjectExpert.ROOT_KEY) ;
			}
			
			_oEB.broadcastEvent(e) ;
		}

		
		private function displayObjectsTreatment(ID:String):void
		{
			var objInfo:DisplayObjectInfo = _mDisplayObject.get(ID) ;
			
			if (ID != DisplayObjectExpert.ROOT_KEY)
			{
				if (objInfo.isEmptyDisplayObject())
				{
					//catch the parent in the beanfactory
					var oParent:DisplayObjectContainer = BeanFactory.getInstance().locate(objInfo.parentID) as DisplayObjectContainer;
					//cast the object according to its type
					var obj:Sprite ;
					if (objInfo.type == "Movieclip")
						obj = new MovieClip() ;
					else
						obj = new Sprite() ;
					obj.name = ID ;
					//add the object on its parent
					oParent.addChild(obj) ;
					//register the object in the beanfactory
					BeanFactory.getInstance().register(ID, obj) ;
					_oEB.broadcastEvent(new DisplayObjectEvent(obj)) ;
				}
				else
				{
					//catch the object loaded
					var GL:GraphicLoader = GraphicLoaderLocator.getInstance().getGraphicLoader(ID) ;
					//catch the parent
					var parent:DisplayObjectContainer = BeanFactory.getInstance().locate(objInfo.parentID)as DisplayObjectContainer ;
					//attach the object loaded on its parent
					GL.setTarget(parent) ;
					//make the object visible if specified
					if (objInfo.isVisible) GL.show() ;
					//register the object in the beanfactory
					BeanFactory.getInstance().register(ID, GL) ;
					_oEB.broadcastEvent(new DisplayObjectEvent(GL.getView())) ;
				}
			}
			
			
			//if the object treated must have child(s), call back the function for each one
			if (objInfo.hasChild())
			{
				var childs:Array = new Array () ;
				childs = objInfo.getChild() ;
				for (var i:int = 0 ; i < childs.length ; i++)
					displayObjectsTreatment(childs[i].ID) ;
			}
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
			//onLoad(e) ;
			_oEB.broadcastEvent( e );
		}
		
		/**
		 * Event system
		 */
		public function addListener( oL : DisplayObjectExpertListener ) : void
		{
			_oEB.addListener( oL );
		}
	
		public function removeListener( oL : DisplayObjectExpertListener ) : void
		{
			_oEB.removeListener( oL );
		}
	
		public function addEventListener( e : String, oL:*, f : Function ) : void
		{
			_oEB.addEventListener.apply( _oEB, arguments );
		}
	
		public function removeEventListener( e : String, oL:* ) : void
		{
			_oEB.removeEventListener( e, oL );
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