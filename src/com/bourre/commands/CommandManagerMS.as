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
package com.bourre.commands
{
	import com.bourre.error.PrivateConstructorException;	
	
	/**
	 * The CommandManagerMS class defines singleton access to 
	 * <code>CommandMS</code> object.
	 * 
	 * @author 	Francis Bourre
	 * 
	 * @see CommandMS
	 */
	public class CommandManagerMS extends CommandMS
	{
		private static var _oI : CommandManagerMS;
		
		/**
		 * Returns singleton instance of <code>CommandManagerMS</code>
		 * 
		 * @return The singleton instance of <code>CommandManagerMS</code>
		 */
		public static function getInstance() : CommandManagerMS
		{
			if ( !(CommandManagerMS._oI is CommandManagerMS) ) CommandManagerMS._oI = new CommandManagerMS( new ConstructorAccess() );
			return CommandManagerMS._oI;
		}
		
		/**
		 * Releases instance.
		 */
		public static function release() : void
		{
			CommandManagerMS._oI.removeAll();
			CommandManagerMS._oI = null;
		}
		
		/**
		 * @private
		 */
		public function CommandManagerMS ( access : ConstructorAccess )
		{
			if ( !(access is ConstructorAccess) ) throw new PrivateConstructorException( );
		}
	}
}
internal class ConstructorAccess {}