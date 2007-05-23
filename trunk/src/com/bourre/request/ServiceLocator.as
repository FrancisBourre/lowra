package com.bourre.request
{
	import com.bourre.request.DataService;
	import com.bourre.collection.HashMap;
	import com.bourre.core.Locator;
	import com.bourre.log.Logger;
	import com.bourre.log.PixlibStringifier;
	import com.bourre.log.PixlibDebug;
	import com.bourre.error.ClassCastException;
	
	public class ServiceLocator implements Locator
	{
		private static var _I : ServiceLocator;
		protected var _m : HashMap;
		
		public function ServiceLocator( access : PrivateConstructorAccess )
		{
			_m = new HashMap() ;
		}
		 
		public static function getInstance(): ServiceLocator
		{
			if( ! (ServiceLocator._I is ServiceLocator) )
			{
				ServiceLocator._I = new ServiceLocator( new PrivateConstructorAccess() );
			}
			return ServiceLocator._I;
		}
		
		public function getService( key : String ) : DataService
		{
			return locate( key ) as DataService;
		}
		
		
		public function isRegistered( key : String ) : Boolean 
		{
			return _m.containsKey( key );
		}
		
		public function locate( key : String ) : Object
		{
			if ( !(isRegistered( key )) ) Logger.ERROR( "Can't locate DataService instance with '" + key + "' name in " + this );
			var service : Object = new (_m.get( key ) as Class)();
			if ( service is DataService ) 
			{
				return service;

			} else
			{
				PixlibDebug.DEBUG("[ServiceLocator]::locate() failed with '"+key+"', class associated doesn't implement DataService interface");
				throw( new ClassCastException("[ServiceLocator]::locate() failed with '"+key+"', class associated doesn't implement DataService interface") );
			}
		}
			
			
		public function registerService( key:String, service:Class ) : Boolean
		{
			if ( isRegistered( key ) )
			{
				Logger.FATAL( "DataService instance is already registered with '" + key + "' name in " + this );
				return false;
			}
			else
			{
				_m.put( key, service );
				return true;
			}
		}
		
		public function unregisterService( key : String ) : void
		{
			_m.remove( key );
		}
			
		/**
		 * Returns the string representation of this instance.
		 * @return the string representation of this instance
		 */
		public function toString() : String 
		{
			return PixlibStringifier.stringify( this );
		}
	}	
}

internal class PrivateConstructorAccess {}
