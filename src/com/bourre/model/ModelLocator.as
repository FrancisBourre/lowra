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
package com.bourre.model
{
	import com.bourre.collection.ArrayIterator;
	import com.bourre.collection.HashMap;
	import com.bourre.collection.Iterator;
	import com.bourre.core.AbstractLocator;
	import com.bourre.error.PrivateConstructorException;
	import com.bourre.plugin.NullPlugin;
	import com.bourre.plugin.Plugin;
	import com.bourre.plugin.PluginDebug;	

	/**
	 * The ModelLocator class is a locator for 
	 * <code>AbstractModel</code> object.
	 * 
	 * <p>A locator is unique for a <code>Plugin</code> instance.</p>
	 * 
	 * @see AbstractModel
	 * 
	 * @author Francis Bourre
	 */
	final public class ModelLocator extends AbstractLocator
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
		 * Returns the unique <code>ModelLocator</code> instance for 
		 * passed-in <code>Plugin</code>.
		 * 
		 * @return The unique <code>ModelLocator</code> instance.
		 */
		public static function getInstance( owner : Plugin = null ) : ModelLocator
		{
			if ( owner == null ) owner = NullPlugin.getInstance();

			if ( !(ModelLocator._M.containsKey( owner )) ) 
				ModelLocator._M.put( owner, new ModelLocator(new ConstructorAccess() , owner ) );

			return ModelLocator._M.get( owner );
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
		 * Returns <code>AbstractModel</code> registered with passed-in 
		 * key identifier.
		 * 
		 * @param	key	Model registration ID
		 * 
		 * @throws 	<code>NoSuchElementException</code> — There is no model
		 * 			associated with the passed-in key
		 */
		public function getModel( key : String ) : AbstractModel
		{
			return locate( key ) as AbstractModel;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function release() : void
		{
			var i : Iterator = new ArrayIterator( _m.getValues() );
			while( i.hasNext() ) i.next().release();
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
		function ModelLocator( access : ConstructorAccess, owner : Plugin = null ) 
		{
			_owner = owner;
			super( AbstractModel, null, PluginDebug.getInstance( getOwner() ) );
			
			if ( !(access is ConstructorAccess) ) throw new PrivateConstructorException();
		}
				
	}
}
internal class ConstructorAccess {}