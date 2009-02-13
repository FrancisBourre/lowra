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
package com.bourre.ioc.assembler
{
	import com.bourre.ioc.assembler.displayobject.DisplayObjectBuilder;
	
	import flash.net.URLRequest;	
	
	/**
	 * The ApplicationAssembler defines rules for concrete assembler 
	 * implementations.
	 * 
	 * @author Francis Bourre
	 */
	public interface ApplicationAssembler
	{
		/**
		 * Registers passed_in <code>ID</code>.
		 */
		function registerID(				ID							: String			) 		: Boolean;
		
		/**
		 * Sets the <code>DisplayObjectBuilder</code> to use to 
		 * build xml context elements.
		 */
		function setDisplayObjectBuilder( 	displayObjectExpert 		: DisplayObjectBuilder ) 	: void;
		
		/**
		 * Returns the <code>DisplayObjectBuilder</code> used to 
		 * build xml context elements.
		 */
		function getDisplayObjectBuilder() 															: DisplayObjectBuilder;
		
		/**
		 * Builds a Display Loader object.
		 * 
		 * @param	ID							Registration ID of loader
		 * @param	url							URL of loader to use
		 * @param	...							Callback handlers
		 */
		function buildLoader( 				ID 							: String, 
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
											completeCallback 			: String 	= null	) 		: void;
		/**
		 * Builds main <code>root</code> object.
		 * 
		 * @param	ID	Registration ID.
		 */									
		function buildRoot(					ID							: String			)		: void;
		
		/**
		 * Builds <code>display object</code>.
		 * 
		 * @param	ID			Registration ID.		 * @param	parentID	Parent registration ID.		 * @param	url			(optional) File URL.		 * @param	isVisible	(optional) <code>true</code> to show object.		 * @param	type		(optional) Display object type.
		 */	
		function buildDisplayObject( 		ID 							: String,
											parentID 					: String, 
											url 						: URLRequest= null,
											isVisible 					: Boolean	= true,
											type 						: String	= null	) 		: void;
		
		/**
		 * Builds <code>DLL</code> object.
		 * 
		 * @param	url	File URL.
		 */	
		function buildDLL( 					url 						: URLRequest 		) 		: void;
		
		/**
		 * Builds <code>Resource</code> object.
		 * 
		 * @param	ID				Registration ID.
		 * @param	url				File URL.
		 * @param	type			(optional) Resource type : 'binary' or 'text'		 * @param	deserializer	(optional) Resource content deserializer
		 */	
		function buildResource(				id							: String,
											url							: URLRequest,
											type						: String = null,
											deserializer 				: String = null		)	: void;
		/**
		 * Builds <code>Property</code> object.
		 */								
		function buildProperty( 			ownerID 					: String, 
											name 						: String 	= null, 
											value 						: String 	= null, 
											type 						: String 	= null, 
											ref 						: String 	= null, 
											method 						: String 	= null	) 		: void;
		/**
		 * Builds generic <code>Object</code>.
		 */	
		function buildObject( 				id 							: String, 
											type 						: String 	= null, 
											args 						: Array 	= null, 
											factory 					: String 	= null, 
											singleton 					: String 	= null  ) 		: void;
		/**
		 * Builds <code>Method-call</code> object.
		 */	
		function buildMethodCall( 			id 							: String, 
											methodCallName 				: String, 
											args 						: Array 	= null 	) 		: void;
		/**
		 * Builds <code>Channel</code> listener.
		 */	
		function buildChannelListener( 		id 							: String, 
											channelName 				: String, 
											args 						: Array 	= null 	) 		: void;
	}
}