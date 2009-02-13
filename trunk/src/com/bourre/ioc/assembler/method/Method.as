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
package com.bourre.ioc.assembler.method
{
	import com.bourre.events.ValueObject;
	import com.bourre.log.PixlibStringifier;	

	/**
	 * Method class.
	 * 
	 * @author Francis Bourre
	 */
	public class Method implements ValueObject
	{
		//--------------------------------------------------------------------
		// Public properties
		//--------------------------------------------------------------------
		
		/**
		 * Identifier of property owner.
		 * 
		 * @default null
		 */		
		public var ownerID		: String;
		
		/**
		 * Name of property.
		 * 
		 * @default null
		 */	
		public var name			: String;
		
		/**
		 * Arguments of property.
		 * 
		 * @default null
		 */	
		public var arguments	: Array;
		
		
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
		
		/**
		 * Creates instance.
		 */		
		public function Method ( ownerID : String, name : String, args : Array )
		{
			this.ownerID	= ownerID;
			this.name		= name ;
			this.arguments 	= args ;
		}

		/**
		 * Returns the string representation of this instance.
		 * @return the string representation of this instance
		 */
		public function toString() : String
		{
			return PixlibStringifier.stringify( this ) 	+ "("
							+ "ownerID:" 	+ ownerID 	+ ", "
							+ "name:" 		+ name 		+ ", "
							+ "arguments:[" + arguments + "])";
		}
	}
}