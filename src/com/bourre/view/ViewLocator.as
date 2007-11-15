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

	import com.bourre.collection.HashMap;
	import com.bourre.core.Locator;
	import com.bourre.log.PixlibStringifier;
	import com.bourre.plugin.*;

	import flash.display.MovieClip;
	import com.bourre.error.NullPointerException;

	public class ViewLocator 
		implements Locator
	{
		protected static var _M : HashMap = new HashMap();
		
		protected var _owner : Plugin;
		protected var _m : HashMap;
		
		public function ViewLocator( access : PrivateConstructorAccess, owner : Plugin = null ) 
		{
			_owner = owner;
			_m = new HashMap();
		}
		
		public static function getInstance( owner : Plugin = null ) : ViewLocator
		{
			if(owner==null) owner = NullPlugin.getInstance()
			if ( !(ViewLocator._M.containsKey( owner )) ) ViewLocator._M.put( owner, new ViewLocator(new PrivateConstructorAccess(), owner) );
			return ViewLocator._M.get( owner );
		}
		
		public function getOwner() : Plugin
		{
			return _owner;
		}
		
		public function getLogger() : PluginDebug
		{
			return PluginDebug.getInstance( getOwner() );
		}
		
		public function isRegistered( key : String ) : Boolean 
		{
			return _m.containsKey( key );
		}
	
		public function locate( key : String ) : Object
		{
			if ( !(isRegistered( key )) ) getLogger().error( "Can't locate AbstractView instance with '" + key + "' name in " + this );
			return _m.get( key );
		}
		
		public function getView( key : String ) : AbstractView
		{
			var v : Object = locate( key ) ;
			
			if( v == null ) 
				throw new NullPointerException ( "Can't locate AbstractView instance with '" + key + "' name in " + this );
			return v as AbstractView;
		}
		
		public function registerView( key : String, o : AbstractView ) : Boolean
		{
			if( key == null ) 
				throw new NullPointerException ( "Cannot register a view with a null name" );
			if( o == null ) 
				throw new NullPointerException ( "Cannot register a null view" );
					
			if ( isRegistered( key ) )
			{
				getLogger().fatal( "MovieClipHelper instance is already registered with '" + key + "' name in " + this );
				return false;
				
			} else
			{
				_m.put( key, o );
				return true;
			}
		}
		
		public function unregisterView( key : String ) : void
		{
			_m.remove( key );
		}
		
		public function release() : void
		{
			var a : Array = _m.getValues();
			var l : uint = a.length;
			while( -- l > - 1 ) ( a[ l ] as AbstractView ).release();
			_m.clear();
		}
	
		/**
		 * Returns the string representation of this instance.
		 * @return the string representation of this instance
		 */
		public function toString() : String 
		{
			return PixlibStringifier.stringify( this ) + (_owner?", owner: "+_owner:"No owner.");
		}
	}
}
internal class PrivateConstructorAccess {}