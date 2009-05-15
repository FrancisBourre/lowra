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
package com.bourre.utils 
{
	import com.bourre.log.PixlibStringifier;
	
	import flash.net.SharedObject;
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;	

	/**
	 * Cookies manager.
	 * 
	 * TODO Documentation
	 *  
	 * @author	Cédric Néhémie
	 */
	dynamic public class Cookie extends Proxy 
	{
		/*----------------------------------------------------
		 * 		CLASS MEMBERS
		 *---------------------------------------------------*/
		
		static private var _aInstances : Object = {};
		
		static public function getInstance( channel : String ) : Cookie
		{
			if( !_aInstances[ channel ] ) 
				_aInstances[ channel ] = new Cookie( channel );
			
			return _aInstances[ channel ];
		}		
		static public function release( channel : String ) : void
		{
			_aInstances[ channel ] = null;
		}
		
		/*----------------------------------------------------
		 * 		INSTANCE MEMBERS
		 *---------------------------------------------------*/
		
		private var _sChannel : String;
		private var _sCookieLocalPath : String;
		private var _bSecure : Boolean;
		
		private var _sLocalPath : String;		private var _sRootPath : String;
		
		public function Cookie ( channel : String, localPath : String = "/", secure : Boolean = false )
		{
			_sChannel = channel;
			_sCookieLocalPath = localPath;
			_bSecure = secure;
			
			_sRootPath = "";
			_sLocalPath = "";
		}

		override flash_proxy function callProperty( methodName : *, ... args ) : *
		{
			appendLocalPath( methodName );
			return this;
		}
		override flash_proxy function getProperty( propertyName : * ) : *
		{
			var content : * = __getSO().data[ appendPath( propertyName ) ];
			
			setLocalPath();
	
			return content;
		}		
		override flash_proxy function setProperty( propertyName : *, value : * ) : void
		{
			var save : SharedObject = __getSO();
			save.data[ appendPath( propertyName ) ] = value;
			save.flush();
			
			setLocalPath();
		}

		public function clear() : void
		{
			__getSO().clear();
		}
		public function toString() : String
		{
			return PixlibStringifier.stringify( this );
		}
				
		/*-----------------------------------------------------------
		 * 		ROOT PATH MANAGEMENT
		 *-----------------------------------------------------------*/
				
		public function setRootPath ( path : String = "" ) : void
		{
			_sRootPath = path;
		}
		public function getRootPath () : String
		{
			return _sRootPath;
		}
		public function hasRootPath () : Boolean
		{
			return _sRootPath != "";
		}
		
		/*-----------------------------------------------------------
		 * 		FINAL PATH MANAGEMENT
		 *-----------------------------------------------------------*/
		
		protected function getPath () : String 
		{
			return 	hasRootPath() ? 
					getRootPath() + ( hasLocalPath() ? "." : "" ) + getLocalPath() :
				   	getLocalPath();
		}
		protected function hasPath () : Boolean 
		{
			return getPath() != "";
		}
		protected function appendPath( path : String ) : String
		{
			return hasPath() ? getPath() + "." + path : path;
		}
		
		/*-----------------------------------------------------------
		 * 		LOCAL PATH MANAGEMENT
		 *-----------------------------------------------------------*/

		protected function setLocalPath ( path : String = "" ) : void
		{			
			_sLocalPath = path;
		}		
		protected function getLocalPath() : String
		{
			return _sLocalPath;
		}
		protected function hasLocalPath () : Boolean
		{
			return _sLocalPath != "";
		}
		protected function appendLocalPath( path : String ) : void
		{
			if( hasLocalPath() )
				_sLocalPath += "." + path;
			else
				_sLocalPath = path;
		}
		
		/*-----------------------------------------------------------
		 * 		PRIVATE MEMBER
		 *-----------------------------------------------------------*/
		
		private function __getSO () : SharedObject
		{
			return SharedObject.getLocal( _sChannel, _sCookieLocalPath, _bSecure );
		}
	}
}
