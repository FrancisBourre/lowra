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

	import com.bourre.load.strategy.LoaderStrategy;
	import com.bourre.log.*;

	import flash.display.*;
	import flash.net.URLRequest;

	public class GraphicLoader 
		extends AbstractLoader
	{
		private var _target : DisplayObjectContainer;
		private var _index : int;
		private var _bAutoShow : Boolean;
		private var _bMustUnregister : Boolean;
	
		public function GraphicLoader( target : DisplayObjectContainer = null, index : int = -1, bAutoShow : Boolean = true )
		{
			super( new LoaderStrategy() );
			
			_target = target;
			_index = index;
			_bAutoShow = bAutoShow;
			_bMustUnregister = false;
		}
		
		public function setTarget(target:DisplayObjectContainer):void
		{
			var b:Boolean = isVisible() ;
			hide();
			_target = target ;
			if (b) show () ;
		}

		protected override function getLoaderEvent( type : String ) : LoaderEvent
		{
			return new GraphicLoaderEvent( type, this );
		}
		
		public override function load( url : URLRequest = null ) : void
		{
			release();

			super.load( url );
		}
		
		protected override function onLoadInit() : void
		{
			if ( getName() ) 
			{
				if ( !(GraphicLoaderLocator.getInstance().isRegistered(getName())) )
				{
					_bMustUnregister = true;
					GraphicLoaderLocator.getInstance().register( getName(), this );
				} else
				{
					_bMustUnregister = false;
					PixlibDebug.ERROR( 	this + " can't be registered to " + GraphicLoaderLocator.getInstance() 
										+ " with '" + getName() + "' name. This name already exists." );
				}
			}
			
			super.onLoadInit();
			if ( _bAutoShow ) show();
		}
		
		public function show() : void
		{
			if (_target != null )
			{
				if ( _index != -1 )
				{
					_target.addChildAt( getContent() as DisplayObject, _index );
					
				} else
				{
					_target.addChild( getContent() as DisplayObject );
				}
			}
			else
				PixlibDebug.DEBUG(this+".show() failed. No specified target.") ;
		}
		
		public function hide() : void
		{
			if (_target != null && _target.contains(getContent() as DisplayObject)) 
				_target.removeChild( getContent() as DisplayObject );
		}
		
		public function isVisible() : Boolean
		{
			var result:Boolean ;
			try
			{
				result = _target.contains( getContent() as DisplayObject );
			} 
			catch(e:Error)
			{
				result = false;
			}
			return result ;
		}
		
		public function set autoShow( b : Boolean ) : void
		{
			_bAutoShow = b;
		}
		public override function release() : void
		{
			if ( getContent() && _target.contains( getContent() as DisplayObject ) )_target.removeChild( getContent() as DisplayObject );

			if ( _bMustUnregister ) 
			{
				GraphicLoaderLocator.getInstance().unregister( getName() );
				_bMustUnregister = false;
			}

			super.release();
		}
		
		public function getView() : DisplayObjectContainer
		{
			return super.getContent() as DisplayObjectContainer;
		}
	}
}