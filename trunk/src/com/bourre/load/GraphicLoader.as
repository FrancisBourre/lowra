package com.bourre.load
{
	import flash.display.*;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	
	import com.bourre.error.IllegalArgumentException;
	import com.bourre.load.strategy.LoaderStrategy;
	import com.bourre.log.*;	

	public class GraphicLoader extends AbstractLoader
	{
		private var _target : DisplayObjectContainer;
		private var _index : int;
		private var _bAutoShow : Boolean;
		private var _bMustUnregister : Boolean;
		private var _oContext : LoaderContext;
		private var _oBitmapContainer : Sprite;

		public function GraphicLoader( target : DisplayObjectContainer = null, index : int = -1, autoShow : Boolean = true )
		{
			super( new LoaderStrategy() );

			_target = target;
			_index = index;
			_bAutoShow = autoShow;
			_bMustUnregister = false;
		}

		public function getTarget() : DisplayObjectContainer
		{
			return _target;
		}

		public function setTarget( target : DisplayObjectContainer ) : void
		{
			var b : Boolean = isVisible();
			hide();
			_target = target ;
			if (b) show();
		}

		override protected function getLoaderEvent( type : String, errorMessage : String = "" ) : LoaderEvent
		{
			return new GraphicLoaderEvent( type, this, errorMessage );
		}

		override public function load( url : URLRequest = null, context : LoaderContext = null ) : void
		{
			if ( context ) setContext( context );
			super.load( url, getContext() );
		}

		override protected function onInitialize() : void
		{
			if ( getName() != null ) 
			{
				if ( !(GraphicLoaderLocator.getInstance().isRegistered(getName())) )
				{
					_bMustUnregister = true;
					GraphicLoaderLocator.getInstance().register( getName(), this );

				} 
				else
				{
					_bMustUnregister = false;
					var msg : String = this + " can't be registered to " + GraphicLoaderLocator.getInstance() 
										+ " with '" + getName() + "' name. This name already exists.";
					PixlibDebug.ERROR( msg );
					fireOnLoadErrorEvent( msg );
					throw new IllegalArgumentException( msg );
				}
			}
			
			if ( _bAutoShow && getTarget() != null ) show();
			super.onInitialize();
		}
		
		override public function setContent( content : Object ) : void
		{	
			if ( content is Bitmap )
			{
				_oBitmapContainer = new Sprite();
				_oBitmapContainer.addChild( content as Bitmap );
			}
			else
			{
				_oBitmapContainer = null;
			} 
			super.setContent( content );
		}
		
		public function show() : void
		{
			if ( _target != null )
			{
				if ( _index != -1 )
				{
					_target.addChildAt( getView(), _index );
					
				} 
				else
				{
					_target.addChild( getView() );
				}
			} 
			else
			{
				PixlibDebug.DEBUG( this + ".show() failed. No specified target." );
			}
		}
		
		public function hide() : void
		{
			if (_target != null && _target.contains( getView() )) 
				_target.removeChild( getView() );
		}
		
		public function isVisible() : Boolean
		{
			var result : Boolean;
			try
			{
				result = _target.contains( getView() );
			} 
			catch( e : Error )
			{
				result = false;
			}
			return result ;
		}
		
		public function setAutoShow( b : Boolean ) : void
		{
			_bAutoShow = b;
		}
		
		override public function release() : void
		{
			if ( getContent() && _target.contains( getView() ) ) _target.removeChild( getView() );

			if ( _bMustUnregister ) 
			{
				GraphicLoaderLocator.getInstance().unregister( getName() );
				_bMustUnregister = false;
			}

			super.release();
		}
		
		public function getView() : DisplayObjectContainer
		{
			return _oBitmapContainer ? _oBitmapContainer : getContent() as DisplayObjectContainer;
		}
		
		public function getApplicationDomain() : ApplicationDomain
		{
			return ( getStrategy() as LoaderStrategy ).getContentLoaderInfo().applicationDomain;
		}
		
		final public function setContext ( context : LoaderContext ):void
		{
			_oContext = context;
		}
		
		final public function getContext () : LoaderContext
		{
			return _oContext;
		}
	}
}