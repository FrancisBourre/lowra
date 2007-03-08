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

package com.bourre.load
{
	import com.bourre.commands.Command;
	
	public interface ILoad 
		extends Command
	{
		function load() : void;
		function getPerCent() : Number;
		function getURL() : String;
		function setURL( sURL : String ) : void;
		function addListener( oL : ILoadListener ) : void;
		function removeListener( oL : ILoadListener ) : void;
		function getName() : String;
		function setName( sURL : String ) : void;
		function setAntiCache( b : Boolean ) : void;
		function prefixURL( sURL : String ) : void;
	}
}