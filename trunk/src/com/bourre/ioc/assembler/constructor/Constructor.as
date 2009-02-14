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
	 
package com.bourre.ioc.assembler.constructor
{
	import com.bourre.events.ValueObject;
	import com.bourre.log.PixlibStringifier;	
	
	/**
	 * The Constructor class store informations during xml context 
	 * parsing on "how to build an object".
	 * 
	 * TODO Documentation
	 * 
	 * @author Francis Bourre
	 */
	public class Constructor implements ValueObject
	{
		//--------------------------------------------------------------------
		// Public properties
		//--------------------------------------------------------------------
				
		public var 		id 			: String;
		public var 		type 		: String;
		public var 		arguments 	: Array;
		public var 		factory 	: String;
		public var 		singleton 	: String;		public var 		ref 		: String;
		public var		result 		: *;
		
		
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
				
		public function Constructor(	id 			: String, 
										type 		: String 	= null, 
										args 		: Array 	= null, 
										factory 	: String 	= null, 
										singleton 	: String 	= null,
										ref			: String 	= null )
		{
			this.id 		= id;
			this.type 		= type;
			this.arguments 	= args;
			this.factory 	= factory;
			this.singleton 	= singleton;
			this.ref = ref;
		}

		/**
		 * Returns the string representation of this instance.
		 * @return the string representation of this instance
		 */
		public function toString() : String 
		{
			return PixlibStringifier.stringify( this ) 	+ "("
							+ "id:" 		+ id 		+ ", "
							+ "type:" 		+ type 		+ ", "
							+ "arguments:[" + arguments + "], "
							+ "factory:" 	+ factory 	+ ", "
							+ "singleton:" 	+ singleton + ", "							+ "ref:" 		+ ref 		+ ")";
		}
	}
}

