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
	import com.bourre.error.IllegalArgumentException;
	import com.bourre.load.strategy.LoaderStrategy;
	import com.bourre.log.PixlibDebug;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;	
	
	/**
	 *  Dispatched when loader starts loading.
	 *  
	 *  @eventType com.bourre.load.GraphicLoaderEvent.onLoadStartEVENT
	 */
	[Event(name="onLoadStart", type="com.bourre.load.GraphicLoaderEvent")]
	
	/**
	 *  Dispatched when loading is finished.
	 *  
	 *  @eventType com.bourre.load.GraphicLoaderEvent.onLoadInitEVENT
	 */
	[Event(name="onLoadInit", type="com.bourre.load.GraphicLoaderEvent")]
	
	/**
	 *  Dispatched during loading progression.
	 *  
	 *  @eventType com.bourre.load.GraphicLoaderEvent.onLoadProgressEVENT
	 */
	[Event(name="onLoadProgress", type="com.bourre.load.GraphicLoaderEvent")]
	
	/**
	 *  Dispatched when a timeout occurs during loading.
	 *  
	 *  @eventType com.bourre.load.GraphicLoaderEvent.onLoadTimeOutEVENT
	 */
	[Event(name="onLoadTimeOut", type="com.bourre.load.GraphicLoaderEvent")]
	
	/**
	 *  Dispatched when an error occurs during loading.
	 *  
	 *  @eventType com.bourre.load.GraphicLoaderEvent.onLoadErrorEVENT
	 */
	[Event(name="onLoadError", type="com.bourre.load.GraphicLoaderEvent")]
	
	/**
	 * The GraphicLoader class is used to load SWF files or image (JPG, PNG, 
	 * or GIF) files. 
	 * 
	 * @example
	 * <pre class="prettyprint">
	 * 
	 * var loader : GraphicLoader = new GraphicLoader( mcContainer, -1, true );
	 * loader.load( new URLRequest( "logo.swf" );
	 * </pre>
	 * 
	 * @author 	Francis Bourre
	 */
	public class GraphicLoader extends AbstractLoader
	{
		//--------------------------------------------------------------------
		// Private properties
		//--------------------------------------------------------------------
				
		private var _target : DisplayObjectContainer;
		private var _index : int;
		private var _bAutoShow : Boolean;
		private var _bMustUnregister : Boolean;
		private var _oContext : LoaderContext;
		private var _oBitmapContainer : Sprite;
		
		
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
		
		/**
		 * Creates new <code>GraphicLoader</code> instance.
		 * 
		 * @param	target		(optional) Container of loaded display object
		 * @param	index		(optional) Index of loaded display object in target 
		 * 						display list
		 * @param	autoShow	(optional) Loaded object visibility
		 */		
		public function GraphicLoader( target : DisplayObjectContainer = null, index : int = -1, autoShow : Boolean = true )
		{
			super( new LoaderStrategy() );

			_target = target;
			_index = index;
			_bAutoShow = autoShow;
			_bMustUnregister = false;
		}
		
		/**
		 * Returns the container of loaded object.
		 * 
		 * @return The container of loaded object.
		 */
		public function getTarget() : DisplayObjectContainer
		{
			return _target;
		}
		
		/**
		 * Sets the container of loaded display object.
		 * 
		 * @param	target	Container of loaded display object
		 */
		public function setTarget( target : DisplayObjectContainer ) : void
		{
			_target = target ;

			if ( _target != null )
			{
				if ( _index != -1 )
				{
					_target.addChildAt( getView(), _index );

				} else
				{
					_target.addChild( getView() );
				}
			} 
		}
		
		/**
		 * Returns a GraphicLoaderEvent event for loader instance.
		 * 
		 * @return A GraphicLoaderEvent event for loader instance.
		 */
		override protected function getLoaderEvent( type : String, errorMessage : String = "" ) : LoaderEvent
		{
			return new GraphicLoaderEvent( type, this, errorMessage );
		}
		
		/**
		 * @inheritDoc
		 */
		override public function load( url : URLRequest = null, context : LoaderContext = null ) : void
		{
			if ( context ) setContext( context );
			super.load( url, getContext() );
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function onInitialize() : void
		{
			if ( getName() != null ) 
			{
				if ( !(GraphicLoaderLocator.getInstance().isRegistered(getName())) )
				{
					_bMustUnregister = true;
					GraphicLoaderLocator.getInstance().register( getName(), this );

				} else
				{
					_bMustUnregister = false;
					var msg : String = this + " can't be registered to " + GraphicLoaderLocator.getInstance() 
										+ " with '" + getName() + "' name. This name already exists.";
					PixlibDebug.ERROR( msg );
					fireOnLoadErrorEvent( msg );
					throw new IllegalArgumentException( msg );
				}
			}

			if ( _target ) setTarget( _target );
			
			if ( _bAutoShow ) 
			{
				show();

			} else
			{
				hide();
			}

			super.onInitialize();
		}
		
		/**
		 * Defines the new content ( display object ) of the loader.
		 */
		override public function setContent( content : Object ) : void
		{	
			if ( content is Bitmap )
			{
				_oBitmapContainer = new Sprite();
				_oBitmapContainer.addChild( content as Bitmap );

			} else
			{
				_oBitmapContainer = null;
			}
				
			super.setContent( content );
			
			if( getName() != null )
			{
				try
				{
					getView().name = getName();
				}
				catch( e : Error )
				{
					//timeline based object
				}
			}
		}
		
		/**
		 * Shows the display object.
		 */
		public function show() : void
		{
			getView().visible = true;
		}
		
		/**
		 * Hides the display object.
		 */
		public function hide() : void
		{
			getView().visible = false;
		}
		
		/**
		 * Returns <code>true</code> if display object is visible.
		 * 
		 * @return <code>true</code> if display object is visible.
		 */
		public function isVisible() : Boolean
		{
			return getView().visible;
		}
		
		/**
		 * 
		 */
		public function setAutoShow( b : Boolean ) : void
		{
			_bAutoShow = b;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function release() : void
		{
			if ( getContent() && _target && _target.contains( getView() ) ) _target.removeChild( getView() );

			if ( _bMustUnregister ) 
			{
				GraphicLoaderLocator.getInstance().unregister( getName() );
				_bMustUnregister = false;
			}

			super.release();
		}
		
		/**
		 * Returns the display object.
		 * 
		 * @return The display object.
		 */
		public function getView() : DisplayObjectContainer
		{
			return _oBitmapContainer ? _oBitmapContainer : getContent() as DisplayObjectContainer;
		}
		
		/**
		 * Returns the <code>applicationDomain</code> of loaded display object.
		 * 
		 * @return The <code>applicationDomain</code> of loaded display object.
		 */
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