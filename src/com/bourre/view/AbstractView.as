package com.bourre.view
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

	import com.bourre.events.EventBroadcaster;
	import com.bourre.load.GraphicLoader;
	import com.bourre.load.GraphicLoaderLocator;
	import com.bourre.log.PixlibStringifier;
	import com.bourre.structures.Point;
	import com.bourre.plugin.IPlugin;
	import com.bourre.plugin.PluginDebug;

	import flash.events.Event;
	import flash.display.DisplayObjectContainer;

	public class AbstractView 
	{
		protected var abstractViewConstructorAccess : AbstractViewConstructorAccess = new AbstractViewConstructorAccess();
		
		public static var onInitEVENT : String = "onInit";
		
		public var view : DisplayObjectContainer;
		
		protected var _gl : GraphicLoader;
		protected var _sName:String;
		protected var _oEB:EventBroadcaster;
		protected var _owner : IPlugin;
		
		public function AbstractView( access : AbstractViewConstructorAccess, owner : IPlugin = null, name : String = null, mc : DisplayObjectContainer = null ) 
		{
			_oEB = new EventBroadcaster( this );
			
			if ( owner ) setOwner( owner );
			if ( name ) _initMovieClipHelperView( name, mc, null );
		}
		
		protected function onInit() : void
		{
			//notifyChanged( new StringEvent( AbstractMovieClipHelper.onInitEVENT, getName() ) );
		}
		
		public function getOwner() : IPlugin
		{
			return _owner;
		}
		
		public function setOwner( owner : IPlugin ) : void
		{
			_owner = owner;
		}
		
		public function getLogger() : PluginDebug
		{
			return PluginDebug.getInstance( getOwner() );
		}
		
		public function notifyChanged( e : Event ) : void
		{
			_getBroadcaster().broadcastEvent( e );
		}
		
		public function registerGraphicLib( glName : String, name : String ) : void
		{
			_initMovieClipHelperView( glName, null, (( name && (name != getName()) ) ? name : null) );
		}
		
		public function registerView( mc : DisplayObjectContainer, name : String ) : void
		{
			_initMovieClipHelperView( getName(), mc, (( name && (name != getName()) ) ? name : null) );
		}
		
		public function setVisible( b : Boolean ) : void
		{
			if ( b )
			{
				show();
			} else
			{
				hide();
			}
		}
		
		public function show() : void
		{
			if (_gl) 
			{
				_gl.show();
			} else 
			{
				view.visible = true;
			}
		}
		
		public function hide() : void
		{
			if (_gl) 
			{
				_gl.hide();
			} else 
			{
				view.visible = false;
			}
		}
		
		public function move( x : Number, y : Number ) : void
		{
			view.x = x;
			view.y = y;
		}
		
		public function getPosition() : Point
		{
			return new Point( view.x, view.y );
		}
		
		public function setSize( w : Number, h : Number ) : void
		{
			view.width = w;
			view.height = h;
		}
		
		public function getSize() : Point
		{
			return new Point( view.width, view.height );
		}
		
		public function getName() : String
		{
			return _sName;
		}
		
		public function canResolveUI ( label : String ) : Boolean
		{
			// TODO return ( (eval( view + "." + label )) != undefined );
			return false;
		}
		
		public function resolveUI ( label : String ) : DisplayObjectContainer
		{
			// TODO var o = eval( view + "." + label );
			// if ( !o ) getLogger().error( "Can't resolve '" + label + "' UI in " + this + ".view" );
			// return o;
			
			return null;
		}
		
		public function release() : void
		{
			_getBroadcaster().removeAllListeners();
			ViewLocator.getInstance( getOwner() ).unregisterMovieClipHelper( getName() );
			view.parent.removeChild( view );
			view = null;
			_gl.release();
			_sName = null;
		}
		
		public function addListener( listener : Object ) : void
		{
			_getBroadcaster().addListener( listener );
		}
		
		public function removeListener( listener : Object ) : void
		{
			_getBroadcaster().removeListener( listener );
		}
		
		public function addEventListener( e : String, listener : Object, f : Function ) : void
		{
			_getBroadcaster().addEventListener.apply( _getBroadcaster(), arguments );
		}
		
		public function removeEventListener( e : String, listener : Object ) : void
		{
			_getBroadcaster().removeEventListener( e, listener );
		}
		
		public function isVisible() : Boolean
		{
			if ( _gl ) 
			{
				return _gl.isVisible();
			} else 
			{
				return view.visible;
			}
		}
		
		public function setName( name : String ) : void
		{
			var vl : ViewLocator = ViewLocator.getInstance( getOwner() );
			
			if ( !( vl.isRegistered( name ) ) )
			{
				if ( vl.isRegistered( getName() ) ) vl.unregisterMovieClipHelper( getName() );
				if ( vl.registerView( name, this ) ) _sName = name;
				
			} else
			{
				getLogger().error( this + ".setName() failed. '" + name + "' is already registered in MovieClipHelperLocator." );
			}
		}
			
		/**
		 * Returns the string representation of this instance.
		 * @return the string representation of this instance
		 */
		public function toString() : String 
		{
			return PixlibStringifier.stringify( this );
		}
		
		//
		private function _initMovieClipHelperView( glName : String, oView : DisplayObjectContainer, mvhName : String ) : void
		{
			if ( oView )
			{
				this.view = oView;
				
			} else
			{
				_gl = GraphicLoaderLocator.getInstance().getGraphicLoader( glName );
				if ( _gl )
				{
					this.view = _gl.getView();
				} else
				{
					getLogger().error( "Invalid arguments for " + this + " constructor." );
					return;
				}
			}
			
			setName( mvhName?mvhName:glName );
			onInit();
		}
		
		protected function _getBroadcaster() : EventBroadcaster
		{
			return _oEB;
		}
		
		protected function _firePrivateEvent( e : Event ) : void
		{
			getOwner().firePrivateEvent( e );
		}
	}
}

internal class AbstractViewConstructorAccess {}