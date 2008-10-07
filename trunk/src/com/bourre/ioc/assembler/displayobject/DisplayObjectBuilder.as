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
	import com.bourre.commands.Command;
	import com.bourre.events.ValueObject;
	
	import flash.display.DisplayObjectContainer;	

	public interface DisplayObjectBuilder 
		extends Command
	{
		function getRootTarget() : DisplayObjectContainer;
		function setRootTarget( target : DisplayObjectContainer ) : void;

		function buildDisplayLoader( o : ValueObject ) : void;		function buildDLL( o : ValueObject ) : void;		function buildDisplayObject( o : ValueObject ) : void;

		function addListener( listener : DisplayObjectBuilderListener ) : Boolean;
		function removeListener( listener : DisplayObjectBuilderListener ) : Boolean;
		function addEventListener( type : String, listener : Object, ... rest ) : Boolean;
		function removeEventListener( type : String, listener : Object ) : Boolean;				function setAntiCache( b : Boolean) : void;
		function isAntiCache() : Boolean;	}}