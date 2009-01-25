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
	import com.bourre.error.PrivateConstructorException;
	import com.bourre.plugin.NullPlugin;
	import com.bourre.plugin.Plugin;
	import com.bourre.plugin.PluginDebug;	

	/**
	 * The ViewLocator class is a locator for 
	 * <code>AbstractView</code> object.
	 * 
	 * <p>Locator is unique for a <code>Plugin</code> instance.</p>
	 * 
	 * @see AbstractView
	 * 
	 * @author Francis Bourre
	 */
	final public class ViewLocator extends AbstractLocator
	{
		//--------------------------------------------------------------------
		// Private properties
		//--------------------------------------------------------------------
		
		private static const _M : HashMap = new HashMap();

		private var _owner : Plugin;
		
		
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
		
		/**
		 * Returns the unique <code>ViewLocator</code> instance for 
		 * passed-in <code>Plugin</code>.
		 * 
		 * @return The unique <code>ViewLocator</code> instance.
		 */
		public static function getInstance( owner : Plugin = null ) : ViewLocator
		{
			if ( owner == null ) owner = NullPlugin.getInstance();

			if ( !( ViewLocator._M.containsKey( owner ) ) ) 
				ViewLocator._M.put( owner, new ViewLocator( new ConstructorAccess(), owner ) );

			return ViewLocator._M.get( owner );
		}
		
		/**
		 * Returns the plugin owner of this locator.
		 * 
		 * @return The plugin owner of this locator.
		 */
		public function getOwner() : Plugin
		{
			return _owner;
		}
		
		/**
		 * Returns <code>AbstractView</code> registered with passed-in 
		 * key identifier.
		 * 
		 * @param	key	View registration ID
		 * 
		 * @throws 	<code>NoSuchElementException</code> — There is no view
		 * 			associated with the passed-in key
		 */
		public function getView( key : String ) : AbstractView
		{
			return locate( key ) as AbstractView;
		}
		
		/**
		 * @inheritDoc
		 * 
		 * @throws 	<code>NullPointerException</code> — Key or object 
		 * 			are <code>null</code>
		 */
		override public function register( key : String, o : Object ) : Boolean
		{
			if( key == null ) 
				throw new NullPointerException ( "Cannot register a view with a null name" );

			if( o == null ) 
				throw new NullPointerException ( "Cannot register a null view" );

			return super.register( key, o );
		}
		
		/**
		 * @inheritDoc
		 */
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
		
		
		//--------------------------------------------------------------------
		// Private implementation
		//--------------------------------------------------------------------
		
		/** @private */
		function ViewLocator( access : ConstructorAccess, owner : Plugin = null ) 
		{
			_owner = owner;
			super( AbstractView, null, PluginDebug.getInstance( getOwner() ) );
			
			if ( !(access is ConstructorAccess) ) throw new PrivateConstructorException();
		}		
	}
}
internal class ConstructorAccess {}