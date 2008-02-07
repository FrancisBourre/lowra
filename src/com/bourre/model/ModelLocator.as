package com.bourre.model
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
	import com.bourre.core.AbstractLocator;
	import com.bourre.plugin.NullPlugin;
	import com.bourre.plugin.Plugin;
	import com.bourre.plugin.PluginDebug;	

	final public class ModelLocator 
		extends AbstractLocator
	{
		protected static var _M : HashMap = new HashMap();

		protected var _owner : Plugin;

		public function ModelLocator( access : PrivateConstructorAccess, owner : Plugin = null ) 
		{
			_owner = owner;
			super( AbstractModel, null, PluginDebug.getInstance( getOwner() ) );
		}

		public static function getInstance( owner : Plugin = null ) : ModelLocator
		{
			if(owner==null) owner = NullPlugin.getInstance();
			if ( !(ModelLocator._M.containsKey( owner )) ) ModelLocator._M.put( owner, new ModelLocator(new PrivateConstructorAccess() , owner) );
			return ModelLocator._M.get( owner );
		}

		public function getOwner() : Plugin
		{
			return _owner;
		}

		public function getModel( key : String ) : AbstractModel
		{
			return locate( key ) as AbstractModel;
		}

		override public function release() : void
		{
			var a : Array = _m.getValues();
			var l : uint = a.length;
			while( -- l > - 1 ) ( a[ l ] as AbstractModel ).release();
			super.release();
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
internal class PrivateConstructorAccess {}