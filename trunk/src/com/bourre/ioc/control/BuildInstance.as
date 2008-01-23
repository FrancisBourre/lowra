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
	import com.bourre.error.IllegalArgumentException;	
	import com.bourre.core.CoreFactory;
	import com.bourre.log.*;
	import com.bourre.plugin.*;
	
	public class BuildInstance 
		implements IBuilder
	{

		public function build ( type 		: String = null, 
								args 		: Array = null,  
								factory 	: String = null, 
								singleton 	: String = null, 
								id 			: String = null ) : *
		{
			var o : Object = null;

			if ( id.length > 0 ) ChannelExpert.getInstance().registerChannel( PluginChannel.getInstance( id ) );
			if ( type ) 
			{
				try
				{
					o = CoreFactory.buildInstance( type, args, factory, singleton );

				} catch( e : Error )
				{
					var msg : String = this + ".build(" + type + ") failed.";
					PixlibDebug.FATAL( msg );
					throw new IllegalArgumentException( msg );
				}
			}

			return o;
		}
		
		public function toString() : String 
		{
			return PixlibStringifier.stringify( this );
		}
	}
}