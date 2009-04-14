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
 
package com.bourre.utils 
{
	import com.bourre.error.PrivateConstructorException;
	import com.bourre.log.PixlibDebug;
	
	import flash.net.SharedObject;	

	/**
	 * The SharedObjectUtils class provide simple methods 
	 * to save data on the local machine.
	 * 
	 * <p>The AS3 version don't handle remote SharedObject. It's not in its main goal.</p>
	 * 
	 * @author	Francis Bourre
	 * @author	Cédric Néhémie
	 * 
	 * @see		http://livedocs.macromedia.com/flex/2/langref/flash/net/SharedObject.html
	 */
	public class SharedObjectUtils
	{
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
				
		/**
		 * Get a value stored in a local SharedObject.
		 * 
		 * <p>If an error occurs the function return a null value.</p>
		 * 
		 * @param	 sCookieName	Name of the cookie.
		 * @param	 sObjectName	Field to retreive.
		 * @return	 The value stored in the field or <code>null</code>.
		 */
		public static function loadLocal( sCookieName : String, sObjectName : String ) : *
		{	
			try
			{
				var save:SharedObject = SharedObject.getLocal(sCookieName, "/");
				return save.data[sObjectName];
			}
			catch(e:Error)
			{
				PixlibDebug.ERROR ( e );
				return null;
			}
		}
		
		/**
		 * Save a data in a local SharedObject.
		 * 
		 * <p>If an error occurs the function die silently and no value is saved.</p>
		 * 
		 * @param	sCookieName	Name of the cookie.
		 * @param	sObjectName	Field to retreive.
		 * @param	refValue	Value to save.
		 * @return	<code>true</code> if the data have been saved.
		 */
		public static function saveLocal( 	sCookieName : String, sObjectName : String, refValue : * ) : Boolean
		{
			try
			{
				var save:SharedObject = SharedObject.getLocal( sCookieName , "/");
				save.data[sObjectName] = refValue;
				save.flush();
				return true;
			}
			catch(e:Error)
			{
				PixlibDebug.ERROR ( e );
			}
			return false;
		}
		
		/**
		 * Clear all values stored in a local SharedObject.
		 * 
		 * <p>If an error occurs the function die silently and return false.</p>
		 * 
		 * @param	sCookieName Name of the cookie.
		 * @return	<code>true</code> if the data have been cleared.
		 */
		public static function clearLocal( sCookieName : String ) : Boolean
		{
			try
			{
				var save:SharedObject = SharedObject.getLocal( sCookieName , "/");
				save.clear();
				return true;
			}
			catch( e : Error )
			{
				PixlibDebug.ERROR ( e );
			}
			return false;
		}
		
		
		//--------------------------------------------------------------------
		// Private implementation
		//--------------------------------------------------------------------
		
		/** @private */		
		function SharedObjectUtils( access : PrivateConstructorAccess )
		{
			if ( !(access is PrivateConstructorAccess) ) throw new PrivateConstructorException();
		}
	}
}

internal class PrivateConstructorAccess {}