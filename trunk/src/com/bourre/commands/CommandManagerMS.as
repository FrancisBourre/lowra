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
	/**
	 * The CommandManagerMS class.
	 * 
	 * <p>TODO Documentation.</p>
	 * 
	 * @author 	Francis Bourre
	 */
	public class CommandManagerMS 
		extends CommandMS
	{
		private static var _oI : CommandManagerMS;

		public static function getInstance() : CommandManagerMS
		{
			if ( !(CommandManagerMS._oI is CommandManagerMS) ) CommandManagerMS._oI = new CommandManagerMS( new ConstructorAccess() );
			return CommandManagerMS._oI;
		}

		public static function release() : void
		{
			CommandManagerMS._oI.removeAll();
			CommandManagerMS._oI = null;
		}

		public function CommandManagerMS ( o : ConstructorAccess ) {}
	}
}
internal class ConstructorAccess {}