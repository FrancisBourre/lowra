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
package com.bourre.view
{
	import com.bourre.collection.ArrayIterator;
	import com.bourre.collection.HashMap;
	import com.bourre.collection.Iterator;
	import com.bourre.core.AbstractLocator;
	import com.bourre.error.NullPointerException;
	import com.bourre.plugin.NullPlugin;
	import com.bourre.plugin.Plugin;
	import com.bourre.plugin.PluginDebug;	

	/**
	 * @author Francis Bourre
	 * @version 1.0
	 */
	final public class ViewLocator 
		extends AbstractLocator
	{
		private static const _M : HashMap = new HashMap();

		private var _owner : Plugin;

		public function ViewLocator( access : ConstructorAccess, owner : Plugin = null ) 
		{
			_owner = owner;
			super( AbstractView, null, PluginDebug.getInstance( getOwner() ) );
		}

		public static function getInstance( owner : Plugin = null ) : ViewLocator
		{
			if ( owner == null ) owner = NullPlugin.getInstance();

			if ( !( ViewLocator._M.containsKey( owner ) ) ) 
				ViewLocator._M.put( owner, new ViewLocator( new ConstructorAccess(), owner ) );

			return ViewLocator._M.get( owner );
		}

		public function getOwner() : Plugin
		{
			return _owner;
		}

		public function getView( key : String ) : AbstractView
		{
			return locate( key ) as AbstractView;
		}

		override public function register( key : String, o : Object ) : Boolean
		{
			if( key == null ) 
				throw new NullPointerException ( "Cannot register a view with a null name" );

			if( o == null ) 
				throw new NullPointerException ( "Cannot register a null view" );

			return super.register( key, o );
		}

		override public function release() : void
		{
			var i : Iterator = new ArrayIterator( _m.getValues() );
			while ( i.hasNext() ) i.next().release();
			super.release();
			_owner = null ;
		}

		/**
		 * Returns the string representation of this instance.
		 * @return the string representation of this instance
		 */
		override public function toString() : String 
		{
			return super.toString() + (_owner?", owner: "+_owner:"No owner.");
		}
	}
}
internal class ConstructorAccess {}