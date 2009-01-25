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
 
package com.bourre.remoting
{
	import com.bourre.log.PixlibDebug;
	
	import flash.utils.getQualifiedClassName;		

	/**
	 * The ServiceMethod class.
	 * 
	 * <p>TODO Documentation.</p>
	 * 
	 * @author Francis Bourre
	 * @author Romain Flacher
	 */
	public class ServiceMethod 
	{
 		private var _sServiceMethodName : String;
		
		function ServiceMethod( s : String = null )
		{
			 _sServiceMethodName = s ? s : getQualifiedClassName( this ) ;
			 if( _sServiceMethodName == "ServiceMethod" ) 
			 	PixlibDebug.WARN('ServiceMethod must have a name , or be extends by another class with a different name of ServiceMethod');
		}

		public function toString() : String
		{
			return _sServiceMethodName;
		}
	}
}
