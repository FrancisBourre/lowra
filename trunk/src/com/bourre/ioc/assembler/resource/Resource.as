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
package com.bourre.ioc.assembler.resource 
{
	import com.bourre.events.ValueObject;
	import com.bourre.log.PixlibStringifier;
	
	import flash.net.URLRequest;	
	
	/**
	 * Value object to store resource configuration defined in 
	 * xml context.
	 * 
	 * @author Romain Ecarnot
	 */
	public class Resource implements ValueObject
	{
		//--------------------------------------------------------------------
		// Public properties
		//--------------------------------------------------------------------
		
		/**
		 * Resource identifier.
		 * 
		 * @default null
		 */
		public var id : String;
		
		/**
		 * Resource file url.
		 * 
		 * @default null
		 */
		public var url 	: URLRequest;
		
		/**
		 * Resource type.
		 * 
		 * @default null
		 */
		public var type	: String;
		
		/**
		 * Resource deserializer.
		 * 
		 * @default null
		 */
		public var deserializerClass : String;
		
		
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
		
		/**
		 * Creates instance.
		 */			
		public function Resource(	id 					: String, 
									url 				: URLRequest, 
									type 				: String 	= null,
									deserializerClass 	: String 	= null )
		{
			this.id = id;
			this.url = url;			this.type = type;			this.deserializerClass = deserializerClass;		}
		
		/**
		 * Returns <code>true</code> if a deserializer is associated with 
		 * current resource.
		 */
		public function hasDeserializer(  ) : Boolean
		{
			return deserializerClass != null;
		}

		/**
		 * Returns the string representation of this instance.
		 * @return the string representation of this instance
		 */
		public function toString() : String 
		{
			return PixlibStringifier.stringify( this ) 	+ "("
			+ "id:" 			+ id 					+ ", "
			+ "url:" 			+ url 					+ ", "			+ "type:" 			+ url 					+ ", "			+ "deserializer:" 	+ deserializerClass		+ ")";
		}
	}
}