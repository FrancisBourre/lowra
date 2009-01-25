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
package com.bourre.log
{
	import com.bourre.error.PrivateConstructorException;		

	/**
	 * The PixlibStringifier class is the main access point to 
	 * string representation processing of an object.
	 * 
	 * <p>Defines custom stringifier process using <code>Stringifier</code> interface 
	 * and concrete implementations.</p>
	 * 
	 * @example
	 * <pre class="prettyprint">
	 * 
	 * PixlibStringifier.setStringifier( new BasicStringifier() );
	 * PixlibStringifier.stringify( myInstance );
	 * </pre>
	 * 
	 * @see Stringifier	 * @see BasicStringifier
	 * 
	 * @author Francis Bourre
	 */
	public class PixlibStringifier
	{
		//--------------------------------------------------------------------
		// Private properties
		//--------------------------------------------------------------------

		private static var _STRINGIFIER : Stringifier = new BasicStringifier( );

		
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
		
		/**
		 * Sets the concrete stringifier to use for process.
		 * 
		 * @param	o Stringifier concrete implementation
		 * 
		 * @see BasicStringifier
		 */
		public static function setStringifier( o : Stringifier ) : void
		{
			PixlibStringifier._STRINGIFIER = o;
		}
		
		/**
		 * Returns the current used stringifier.
		 */
		public static function getStringifier() : Stringifier
		{
			return PixlibStringifier._STRINGIFIER;
		}
		
		/**
		 * Process stringify processing.
		 * 
		 * @param	target	Object to stringify
		 */
		public static function stringify( target : * ) : String 
		{
			return PixlibStringifier._STRINGIFIER.stringify( target );
		}

		
		//--------------------------------------------------------------------
		// Private implementation
		//--------------------------------------------------------------------
		
		/** @private */
		function PixlibStringifier( access : ConstructorAccess )
		{
			if ( !(access is ConstructorAccess) ) throw new PrivateConstructorException( );
		}		
	}
}

internal class ConstructorAccess 
{
}