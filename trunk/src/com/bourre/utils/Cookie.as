package com.bourre.utils 
{
	import com.bourre.log.PixlibDebug;	
	import com.bourre.log.PixlibStringifier;	
	
	import flash.net.SharedObject;
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;		

	/**
	 * @author Cédric Néhémie
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
		private var _sLocalPath : String;
		private var _bSecure : Boolean;
		
		private var _sLocalSpace : String;		private var _sRootSpace : String;
		
		public function Cookie ( channel : String, localPath : String = "/", secure : Boolean = false )
		{
			_sChannel = channel;
			_sLocalPath = localPath;
			_bSecure = secure;
			
			_sRootSpace = "";
			_sLocalSpace = "";
		}

		override flash_proxy function callProperty( methodName : *, ... args ) : *
		{
			appendLocalSpace( methodName );
			return this;
		}
		override flash_proxy function getProperty( propertyName : * ) : *
		{
			var content : * = __getSO().data[ appendSpace( propertyName ) ];
			
			setLocalSpace();
	
			return content;
		}		
		override flash_proxy function setProperty( propertyName : *, value : * ) : void
		{
			var save : SharedObject = __getSO();
			save.data[ appendSpace( propertyName ) ] = value;
			save.flush();
			
			setLocalSpace();
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
		 * 		ROOT SPACE MANAGEMENT
		 *-----------------------------------------------------------*/
				
		public function setRootSpace ( space : String = "" ) : void
		{
			_sRootSpace = space;
		}
		public function getRootSpace () : String
		{
			return _sRootSpace;
		}
		public function hasRootSpace () : Boolean
		{
			return _sRootSpace != "";
		}
		
		/*-----------------------------------------------------------
		 * 		FINAL SPACE MANAGEMENT
		 *-----------------------------------------------------------*/
		
		protected function getSpace () : String 
		{
			return 	hasRootSpace() ? 
					getRootSpace() + ( hasLocalSpace() ? "." : "" ) + getLocalSpace() :
				   	getLocalSpace();
		}
		protected function hasSpace () : Boolean 
		{
			return getSpace() != "";
		}
		protected function appendSpace( space : String ) : String
		{
			return hasSpace() ? getSpace() + "." + space : space;
		}
		
		/*-----------------------------------------------------------
		 * 		LOCAL SPACE MANAGEMENT
		 *-----------------------------------------------------------*/

		protected function setLocalSpace ( space : String = "" ) : void
		{			
			_sLocalSpace = space;
		}		
		protected function getLocalSpace() : String
		{
			return _sLocalSpace;
		}
		protected function hasLocalSpace () : Boolean
		{
			return _sLocalSpace != "";
		}
		protected function appendLocalSpace( space : String ) : void
		{
			if( hasLocalSpace() )
				_sLocalSpace += "." + space;
			else
				_sLocalSpace = space;
		}
		
		/*-----------------------------------------------------------
		 * 		PRIVATE MEMBER
		 *-----------------------------------------------------------*/
		
		private function __getSO () : SharedObject
		{
			return SharedObject.getLocal( _sChannel, _sLocalPath, _bSecure );
		}
	}
}
