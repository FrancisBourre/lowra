package com.bourre.ioc.assembler.displayobject 
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
	import com.bourre.events.ValueObject;
	import com.bourre.log.PixlibStringifier;
	
	import flash.net.URLRequest;	

	public class DisplayLoaderInfo 
		implements ValueObject
	{
		public var id 						: String;
		public var url 						: URLRequest;
		public var progressCallback 		: String;
		public var nameCallback 			: String;
		public var timeoutCallback 			: String;
		public var parsedCallback 			: String;
		public var methodsCallCallback 		: String;
		public var objectsBuiltCallback 	: String;
		public var channelsAssignedCallback : String;
		public var initCallback 			: String;

		public function DisplayLoaderInfo(	id 							: String, 
											url 						: URLRequest, 
											progressCallback 			: String 	= null, 
											nameCallback 				: String 	= null, 
											timeoutCallback 			: String 	= null, 
											parsedCallback 				: String 	= null, 
											methodsCallCallback 		: String 	= null, 
											objectsBuiltCallback		: String 	= null, 
											channelsAssignedCallback	: String 	= null, 
											initCallback 				: String 	= null	) 
		{
			this.id = id;
			this.url = url;
			this.progressCallback = progressCallback;
			this.nameCallback = nameCallback;
			this.timeoutCallback = timeoutCallback;
			this.parsedCallback = parsedCallback;
			this.methodsCallCallback = methodsCallCallback;
			this.objectsBuiltCallback = objectsBuiltCallback;
			this.channelsAssignedCallback = channelsAssignedCallback;
			this.initCallback = initCallback;
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
			+ "progressCallback:" 			+ progressCallback 			+ ", "
			+ "nameCallback:" 				+ nameCallback 				+ ", "
			+ "timeoutCallback:" 			+ timeoutCallback 			+ ", "
			+ "parsedCallback:" 			+ parsedCallback 			+ ", "
			+ "methodsCallCallback:"		+ methodsCallCallback 		+ ", "
			+ "objectsBuiltCallback:" 		+ objectsBuiltCallback 		+ ", "
			+ "channelsAssignedCallback:" 	+ channelsAssignedCallback 	+ ", "
			+ "initCallback:" 				+ initCallback 				+ ")";
		}
	}
}