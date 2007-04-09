package com.bourre.ioc.assembler
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

	public interface ApplicationAssembler
	{
		//function buildDLL( url : String ) : void;
		//function buildEmptyMovieClip( parentID : String, name : String, depth : Number ) : void;
		//function buildGraphicLib( parentID : String, depth : Number, isVisible : Boolean, name : String, url : String = null ) : void;
		//function buildGraphicProperty( id : String, propertyNode : * ) : void;
		//function buildProperty( id : String, propertyNode : * ) : void;

		function buildObject( 	id 			: String, 
								type 		: String 	= null, 
								args 		: Array 	= null, 
								factory 	: String 	= null, 
								singleton 	: String 	= null, 
								channelName : String 	= null 	) : void;

		//function buildMethodCall( id : String, methodCallNode : Object ) : void;
		//function buildChannelListener( id : String, listenChannelNode : Object ) : void;
	}
}