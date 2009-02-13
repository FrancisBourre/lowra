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
package com.bourre.ioc.assembler.displayobject 
{
	import com.bourre.events.ValueObject;
	import com.bourre.log.PixlibStringifier;
	
	import flash.net.URLRequest;	
	
	/**
	 * Value object to store Display loader configuration defined in 
	 * xml context.
	 * 
	 * @author Francis Bourre
	 */
	public class DisplayLoaderInfo implements ValueObject
	{
		//--------------------------------------------------------------------
		// Public properties
		//--------------------------------------------------------------------
		
		/**
		 * Display loader identifier.
		 * 
		 * @default null
		 */	
		public var id 						: String;
		
		/**
		 * Display loader content url.
		 * 
		 * @default null
		 */	
		public var url 						: URLRequest;
		
		public var startCallback			: String;
		public var nameCallback 			: String;
		
		public var loadCallback				: String;
		public var progressCallback			: String;
		public var timeoutCallback 			: String;
		public var errorCallback 			: String;
		public var initCallback 			: String;
		
		public var parsedCallback 			: String;
		public var objectsBuiltCallback 	: String;
		public var channelsAssignedCallback : String;
		public var methodsCallCallback 		: String;
		
		public var completeCallback			: String;
		
		
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
		
		/**
		 * Creates instance.
		 */			
		public function DisplayLoaderInfo(	id 							: String, 
											url 						: URLRequest, 
											startCallback 				: String 	= null,
											nameCallback 				: String 	= null, 
											loadCallback 				: String 	= null, 
											progressCallback 			: String 	= null, 
											timeoutCallback 			: String 	= null, 
											errorCallback 				: String 	= null, 
											initCallback 				: String 	= null, 
											parsedCallback 				: String 	= null, 
											objectsBuiltCallback		: String 	= null, 
											channelsAssignedCallback	: String 	= null, 
											methodsCallCallback 		: String 	= null, 
											completeCallback 			: String 	= null	) 
		{
			this.id = id;
			this.url = url;
			
			this.startCallback = startCallback;
			this.nameCallback = nameCallback;
			
			this.loadCallback = loadCallback;
			this.progressCallback = progressCallback;
			this.timeoutCallback = timeoutCallback;
			this.errorCallback = errorCallback;
			this.initCallback = initCallback;
			
			this.parsedCallback = parsedCallback;
			this.objectsBuiltCallback = objectsBuiltCallback;
			this.channelsAssignedCallback = channelsAssignedCallback;
			this.methodsCallCallback = methodsCallCallback;
			
			this.completeCallback = completeCallback;
		}
		
		/**
		 * Returns the string representation of this instance.
		 * @return the string representation of this instance
		 */
		public function toString() : String 
		{
			return PixlibStringifier.stringify( this ) 	+ "("
			+ "id:" 						+ id 						+ ", "
			+ "url:" 						+ url 						+ ", "
			
			+ "startCallback:" 				+ startCallback 			+ ", "
			+ "nameCallback:" 				+ nameCallback 				+ ", "
			
			+ "loadCallback:" 				+ loadCallback 				+ ", "			+ "progressCallback:" 			+ progressCallback 			+ ", "
			+ "timeoutCallback:" 			+ timeoutCallback 			+ ", "			+ "errorCallback:" 				+ errorCallback 			+ ", "			+ "initCallback:" 				+ initCallback 				+ ", "
			
			+ "parsedCallback:" 			+ parsedCallback 			+ ", "
			+ "objectsBuiltCallback:" 		+ objectsBuiltCallback 		+ ", "
			+ "channelsAssignedCallback:" 	+ channelsAssignedCallback 	+ ", "
			+ "methodsCallCallback:"		+ methodsCallCallback 		+ ", "
						+ "completeCallback:" 			+ completeCallback 			+ ")";
		}
	}
}