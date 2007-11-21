package com.bourre.request
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

	import com.bourre.commands.ASyncCommand;
	import flash.events.Event;
	
	public interface DataServiceConnector 
		extends ASyncCommand
	{
		function setURL( url : String ) : void;
		function fireEvent( e : DataServiceEvent ) : void;
		function addServiceListener( listener : DataServiceListener ) : Boolean;
		function removeServiceRequestListener( listener : DataServiceListener ) : Boolean;
		function request( e : DataService ) : void;
		function release():void ;
		function addEventListener( type : String, listener : Object, ... rest ) : Boolean
		function removeEventListener( type : String, listener : Object ) : Boolean
	}
}