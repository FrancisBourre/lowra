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

package com.bourre.events
{
	import flash.utils.getQualifiedClassName;
	import com.bourre.error.ProtectedConstructorException;
	import com.bourre.log.*;
	
	public class EventChannel 
	{
		protected var abstractConstructorAccess : AbstractConstructorAccess = new AbstractConstructorAccess();
		private var _sChannelName : String;
		
		public function EventChannel(  access : AbstractConstructorAccess, channelName : String = null )
		{
			var qualifiedClassName : String = getQualifiedClassName( this );
			if ( qualifiedClassName == "com.bourre.events::EventChannel" )
				throw new ProtectedConstructorException( "Instantiation failed. " + qualifiedClassName 
				+ " is an abstract class, you must extend it before using it" );
			
			_sChannelName =  channelName ? channelName : qualifiedClassName;
		}
		
		public function toString() : String
		{
			return _sChannelName;
		}
	}
}

internal class AbstractConstructorAccess {}