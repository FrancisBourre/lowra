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
package com.bourre.structures 
{
	import com.bourre.log.PixlibStringifier;	
	
	/**
	 * @author Cédric Néhémie
	 */
	public class Dimension 
	{
		public var width : Number;
		public var height : Number;
		
		public function Dimension ( width : Number = 0, height : Number = 0 )
		{
			this.width = width;
			this.height = height;
		}

		public function equals ( dimension : Dimension ) : Boolean
		{
			return (width == dimension.width && height == dimension.height );
		}
		
		public function setSize ( dimension : Dimension ) : void
		{
			width = dimension.width;
			height = dimension.height;
		}
		
		public function clone() : Dimension
		{
			return new Dimension ( width, height );
		}

		public function toString() : String 
		{
			return PixlibStringifier.stringify ( this ) + "[" + width + ", " + height +"]";
		}	
	}
}
