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
 
package com.bourre.ioc.assembler.property
{
	import com.bourre.events.ValueObject;
	import com.bourre.log.PixlibStringifier;	
	
	/**
	 * Property class.
	 * 
	 * @author Francis Bourre
	 */
	public class Property implements ValueObject
	{
		//--------------------------------------------------------------------
		// Public properties
		//--------------------------------------------------------------------
		
		/**
		 * Property owner.
		 * 
		 * @default null
		 */		
		public var ownerID : String;
		
		/**
		 * Property name.
		 * 
		 * @default null
		 */	
		public var name : String;
		
		/**
		 * Property value.
		 * 
		 * @default null
		 */	
		public var value : String;
		
		/**
		 * Property type.
		 * 
		 * @default null
		 */	
		public var type : String;
		
		/**
		 * Property reference.
		 * 
		 * @default null
		 */	
		public var ref : String;
		
		/**
		 * Method name to call if <code>ref</code> id defined.
		 * 
		 * @default null
		 */	
		public var method : String;
		
		
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
		
		/**
		 * Creates instance.
		 */
		public function Property( 	ownerID : String, 
									name 	: String = null, 
									value 	: String = null, 
									type 	: String = null, 
									ref 	: String = null, 
									method 	: String = null 
								)
		{
			this.ownerID = ownerID;
			this.name = name;
			this.value = value;
			this.type = type;
			this.ref = ref;
			this.method = method;
		}

		/**
		 * Returns the string representation of this instance.
		 * @return the string representation of this instance
		 */
		public function toString() : String 
		{
			return PixlibStringifier.stringify( this ) 	+ "("
							+ "ownerID:" 	+ ownerID 	+ ", "							+ "name:" 		+ name 		+ ", "							+ "value:" 		+ value 	+ ", "							+ "type:" 		+ type 		+ ", "							+ "ref:" 		+ ref 		+ ", "							+ "method:" 	+ method 	+ ")";
		}
	}
}