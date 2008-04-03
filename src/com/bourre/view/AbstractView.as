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
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.geom.Point;
	
	import com.bourre.error.IllegalArgumentException;
	import com.bourre.error.NoSuchElementException;
	import com.bourre.events.EventBroadcaster;
	import com.bourre.events.StringEvent;
	import com.bourre.load.GraphicLoader;
	import com.bourre.load.GraphicLoaderLocator;
	import com.bourre.log.PixlibStringifier;
	import com.bourre.plugin.NullPlugin;
	import com.bourre.plugin.Plugin;
	import com.bourre.plugin.PluginDebug;
	import com.bourre.structures.Dimension;		

	public class AbstractView 
	{
		public static const onInitViewEVENT : String = "onInitView";
		public static const onReleaseViewEVENT : String = "onReleaseView";

		public var view : DisplayObject;

		protected var _gl : GraphicLoader;
		protected var _sName:String;
		protected var _oEB:EventBroadcaster;
		protected var _owner : Plugin;

		public function AbstractView( owner : Plugin = null, name : String = null, mc : DisplayObject = null ) 
		{
			_oEB = new EventBroadcaster( this );

			setOwner( owner );
			if ( name != null ) _initAbstractView( name, mc, null );
		}

		public function handleEvent( e : Event ) : void
		{
			//
		}

		protected function onInitView() : void
		{
			notifyChanged( new StringEvent( AbstractView.onInitViewEVENT, this, getName() ) );
		}

		protected function onReleaseView() : void
		{
			notifyChanged( new StringEvent( AbstractView.onReleaseViewEVENT, this, getName() ) );
		}

		public function getOwner() : Plugin
		{
			return _owner;
		}

		public function setOwner( owner : Plugin ) : void
		{
			_owner = owner ? owner : NullPlugin.getInstance();
		}

		public function getLogger() : PluginDebug
		{
			return PluginDebug.getInstance( getOwner() );
		}

		public function notifyChanged( e : Event ) : void
		{
			_getBroadcaster().broadcastEvent( e );
		}

		public function registerGraphicLoader( glName : String, name : String = null ) : void
		{
			_initAbstractView( glName, null, (( name && (name != getName()) ) ? name : null) );
		}

		public function registerView( mc : DisplayObject, name : String = null ) : void
		{
			_initAbstractView( getName(), mc, (( name && (name != getName()) ) ? name : null) );
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
			view.visible = true;
		}

		public function hide() : void
		{
			view.visible = false;
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

		public function setSize( size : Dimension ) : void
		{
			view.width = size.width;
			view.height = size.height;
		}

		public function setSizeWH( w : Number, h : Number ) : void
		{
			view.width = w;
			view.height = h;
		}

		public function getSize () : Dimension
		{
			return new Dimension( view.width, view.height );
		}

		public function getName() : String
		{
			return _sName;
		}

		public function canResolveUI ( label : String ) : Boolean
		{
			try
			{
				return resolveUI( label, true ) is DisplayObject;

			} catch ( e : Error )
			{
				return false;
			}

			return false;
		}

		public function resolveUI( label : String, tryToResolveUI : Boolean = false ) : DisplayObject 
		{
			var target : DisplayObject = this.view;

			var a : Array = label.split( "." );
			var l : int = a.length;

			for ( var i : int = 0; i < l; i++ )
			{
				var name : String = a[ i ];
				if ( target is DisplayObjectContainer && (target as DisplayObjectContainer).getChildByName( name ) != null )
				{
					target = (target as DisplayObjectContainer).getChildByName( name );

				} else
				{
					var msg : String;
					if ( !tryToResolveUI ) 
					{
						msg = this + ".resolveUI(" + label + ") failed.";
						getLogger().error( msg );
						throw new NoSuchElementException( msg );
					}
					return null;
				}
			}

			return target;
		}

		public function canResolveFunction ( label : String ) : Boolean
		{
			try
			{
				return resolveFunction( label ) is Function;

			} catch ( e : Error )
			{
				return false;
			}

			return false;
		}
		
		public function resolveFunction( label : String  ) : Function
		{
			var a : Array = label.split( "." );
			var f : String = a.pop();
			var target : DisplayObjectContainer  = resolveUI( a.join('.')) as DisplayObjectContainer ; 
			
			if ( target.hasOwnProperty( f ) &&  target[f] is Function  )
			{
				return target[f] ;

			} else
			{
				getLogger().error( this + ".resolveFunction(" + label + ") failed." );
				return null;
			}
			
		}
		
		public function release() : void
		{
			_getBroadcaster().removeAllListeners();
			ViewLocator.getInstance( getOwner() ).unregister( getName() );

			if( view != null )
			{
				if ( view.parent != null ) view.parent.removeChild( view );
				view = null;
			}

			if ( _gl != null ) _gl.release();

			onReleaseView();
			
			_sName = null;
		}

		public function addListener( listener : ViewListener ) : Boolean
		{
			return _oEB.addListener( listener );
		}

		public function removeListener( listener : ViewListener ) : Boolean
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

		public function isVisible() : Boolean
		{
			return view.visible;
		}

		public function setName( name : String ) : void
		{
			var vl : ViewLocator = ViewLocator.getInstance( getOwner() );

			if ( name != null && !( vl.isRegistered( name ) ) )
			{
				if ( getName() != null && vl.isRegistered( getName() ) ) vl.unregister( getName() );
				if ( vl.register( name, this ) ) _sName = name;

			} else
			{
				var msg : String = this + ".setName() failed. '" + name + "' is already registered in ViewLocator.";
				getLogger().error( msg );
				throw new IllegalArgumentException( msg );
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
		private function _initAbstractView( glName : String, oView : DisplayObject, mvhName : String ) : void
		{	
			if ( oView != null )
			{
				this.view = oView;

			} else
			{
				if( GraphicLoaderLocator.getInstance().isRegistered( glName ) )
				{
					_gl = GraphicLoaderLocator.getInstance().getGraphicLoader( glName );

					if ( _gl != null )
					{
						this.view = _gl.getView();

					} else
					{
						getLogger().error( "Invalid arguments for " + this + " constructor." );
						return;
					}
				}
			}

			setName( mvhName?mvhName:glName );
			onInitView();
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