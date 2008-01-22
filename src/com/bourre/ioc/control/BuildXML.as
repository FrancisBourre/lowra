package com.bourre.ioc.control {	/*	 * Copyright the original author or authors.	 * 	 * Licensed under the MOZILLA PUBLIC LICENSE, Version 1.1 (the "License");	 * you may not use this file except in compliance with the License.	 * You may obtain a copy of the License at	 * 	 *      http://www.mozilla.org/MPL/MPL-1.1.html	 * 	 * Unless required by applicable law or agreed to in writing, software	 * distributed under the License is distributed on an "AS IS" BASIS,	 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.	 * See the License for the specific language governing permissions and	 * limitations under the License.	 */	/**	 * @author Francis Bourre	 * @version 1.0	 */	import com.bourre.log.PixlibDebug;												
	public class BuildXML 		implements IBuilder	{		import com.bourre.log.*;		public function build ( type : String = null, 								args : Array = null,  								factory : String = null, 								singleton : String = null, 								channel : String = null		) : *		{			if ( args != null || args.length > 0 ) 			{				var s : String = args[ 0 ] as String;				if ( s.length > 0 )				{					return new XML( s );				} else				{					PixlibDebug.WARN( this + ".build() returns an empty XML." );					return new XML();				}			} else			{				PixlibDebug.WARN( this + ".build() returns an empty XML." );				return new XML();			}		}		public function toString() : String 		{			return PixlibStringifier.stringify( this );		}	}}