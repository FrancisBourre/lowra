package com.bourre.utils 
{
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
		
		private var _sCurrentSpace : String;		private var _sRootSpace : String;
		
		public function Cookie ( channel : String, localPath : String = "/", secure : Boolean = false )
		{
			_sChannel = channel;
			_sLocalPath = localPath;
			_bSecure = secure;
		}

		override flash_proxy function callProperty( methodName : *, ... args ) : *
		{
			setCurrentSpace( appendSpace( methodName ) );
			return this;
		}
		override flash_proxy function getProperty( propertyName : * ) : *
		{
			var save : SharedObject = __getSO();
			var content : * = save.data[ appendSpace( propertyName ) ];
			
			setCurrentSpace();
	
			return content;
		}
		
		override flash_proxy function setProperty( propertyName : *, value : * ) : void
		{
			var save : SharedObject = __getSO();
			save.data[ appendSpace( propertyName ) ] = value;
			save.flush();
			
			setCurrentSpace();
		}

		public function clear() : void
		{
			__getSO().clear();
		}
		
		public function setRootSpace ( space : String = "" ) : void
		{
			_sRootSpace = space;
		}
		public function getRootSpace () : String
		{
			return _sRootSpace;
		}
				
		public function setCurrentSpace ( space : String = null ) : void
		{
			if( space == null )
				space = getRootSpace();
			
			_sCurrentSpace = space;
		}		
		public function getCurrentSpace( space : String ) : String
		{
			return _sCurrentSpace;
		}
		public function appendSpace( space : String ) : String
		{
			return _sCurrentSpace == "" ? space : _sCurrentSpace + "." + space;
		}
		
		public function toString() : String
		{
			return PixlibStringifier.stringify( this );
		}

		private function __getSO () : SharedObject
		{
			return SharedObject.getLocal( _sChannel, _sLocalPath, _bSecure );
		}
	}
}
