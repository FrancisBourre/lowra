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
	import com.bourre.log.*;
	import flash.events.Event;
	
	public class BasicEvent extends Event
	{
		protected var _oTarget : Object;
		protected var _sType : String;
		
		public function BasicEvent( sType : String, oTarget : Object = null )
		{
			super ( sType );
			_sType = sType;
			_oTarget = oTarget;
		}
		
		public function set type( en : String ) : void
		{
			_sType = en;
		}
		public override function get type():String
		{
			return _sType;
		}
		
		public function setType( en : String ) : void
		{
			_sType = en;
		}
		public function getType():String
		{
			return _sType;
		}
		
		public function getTarget() : Object
		{ 
			return _oTarget; 
		}
		
		public function setTarget( oTarget : Object ) : void 
		{ 
			_oTarget = oTarget; 
		}
		
		public override function get target() : Object
		{ 
			return _oTarget; 
		}
		
		public function set target( oTarget : Object ) : void 
		{ 
			_oTarget = oTarget; 
		}
		
		/**
		 * Returns the string representation of this instance.
		 * @return the string representation of this instance
		 */
		public override function toString() : String 
		{
			return PixlibStringifier.stringify( this );
		}
	}
}