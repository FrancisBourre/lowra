package com.bourre.load 
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
	import com.bourre.load.strategy.URLLoaderStrategy;			

	public class FileLoader 
		extends AbstractLoader
	{
		public static const BINARY : String = URLLoaderStrategy.BINARY;		public static const TEXT : String = URLLoaderStrategy.TEXT;		public static const VARIABLES : String = URLLoaderStrategy.VARIABLES;

		public function FileLoader( dataFormat : String = null )
		{
			super( new URLLoaderStrategy( dataFormat ) );
		}
		
		public function setDataFormat( dataFormat : String ) : void
		{
			( getStrategy( ) as URLLoaderStrategy ).setDataFormat( dataFormat );
		}

		protected override function getLoaderEvent( type : String, errorMessage : String = "" ) : LoaderEvent
		{
			return new FileLoaderEvent( type, this, errorMessage );
		}
	}
}