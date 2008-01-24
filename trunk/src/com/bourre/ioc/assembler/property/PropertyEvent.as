package com.bourre.ioc.assembler.property 
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
	import com.bourre.events.BasicEvent;
	import com.bourre.ioc.assembler.property.Property;
	import com.bourre.log.PixlibStringifier;	

	public class PropertyEvent 
		extends BasicEvent
	{
		public static const onBuildPropertyEVENT : String = "onBuildProperty";

		protected var _oProp : Property;

		public function PropertyEvent( o : Property )
		{
			super( PropertyEvent.onBuildPropertyEVENT, o );

			_oProp = o;
		}

		public function getProperty() : Property
		{
			return _oProp;
		}

		public function getPropertyOwnerID() : String
		{
			return _oProp.ownerID;
		}
		
		public function getPropertyName() : String
		{
			return _oProp.name;
		}
		
		public function getPropertyValue() : String
		{
			return _oProp.value;
		}
		
		public function getPropertyType() : String
		{
			return _oProp.type;
		}

		public function getPropertyRef() : String
		{
			return _oProp.ref;
		}
		
		public function getPropertyMethod() : String
		{
			return _oProp.method;
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