package com.bourre.ioc.control 
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
	import flash.utils.Dictionary;
	
	import com.bourre.ioc.assembler.property.DictionaryItem;
	import com.bourre.log.PixlibDebug;	

	public class BuildDictionary 
		implements IBuilder
	{
		import com.bourre.log.*;

		public function build ( type 		: String = null, 
								args 		: Array = null,  
								factory 	: String = null, 
								singleton 	: String = null, 
								id 			: String = null ) : *
		{
			var d : Dictionary = new Dictionary();

			if ( args.length <= 0 ) 
			{
				PixlibDebug.WARN( this + ".build(" + args + ") returns an empty Dictionary." );

			} else
			{
				var l : int = args.length;
				for ( var i : int = 0; i < l; i++ )
				{
					var di : DictionaryItem = args[ i ] as DictionaryItem;
					if (di.key != null)
					{
						d[ di.key ] = di.value;

					} else
					{
						PixlibDebug.WARN( this + ".build() adds item with a 'null' key for '"  + di.value +"' value." );
					}
				}
			}
			return d;
		}

		public function toString() : String 
		{
			return PixlibStringifier.stringify( this );
		}
	}}