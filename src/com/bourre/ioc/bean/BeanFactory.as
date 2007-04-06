package com.bourre.ioc.bean
{
	import com.bourre.core.Locator;
	import com.bourre.collection.HashMap ;
	import com.bourre.events.EventBroadcaster;	
	import com.bourre.error.*;
	import com.bourre.log.*;
	
	public class BeanFactory 
		implements Locator
	{
		private static  var _oI : BeanFactory ;
		
		private var _oEB : EventBroadcaster ;
		private var _m : HashMap ;
		
		public static var onRegisterBeanEVENT:String = "onRegisterBean" ;
		public static var onUnregisterBeanEVENT:String = "onUnregisterBean" ;
		
		public static function getInstance() : BeanFactory
		{
			if ( !(BeanFactory._oI is BeanFactory) ) BeanFactory._oI = new BeanFactory( new PrivateConstructorAccess() );
			return BeanFactory._oI;
		}
		
		public function BeanFactory( access : PrivateConstructorAccess )
		{
			_oEB = new EventBroadcaster(this) ;
			_m = new HashMap() ;
		}
		
		public function  locate ( key : String ) : Object
		{
			if ( isRegistered(key) )
			{
				return _m.get( key ) ;

			} else
			{
				var msg : String = this + ".locate(" + key + ") fails." ;
				PixlibDebug.ERROR( msg ) ;
				throw( new NoSuchElementException( msg ) ) ;
			}
		}
		
		public function isRegistered( key : String ) : Boolean
		{
			return _m.containsKey( key ) ;
		}
		
		public function isBeanRegistered( bean : Object ) : Boolean
		{
			return _m.containsValue( bean ) ;
		}
		
		public function register ( key : String, bean : Object ) : Boolean
		{
			if (!(isRegistered(key)) && !(isBeanRegistered(bean)))
			{
				_m.put(key, bean) ;
				_oEB.broadcastEvent(new BeanEvent(BeanFactory.onRegisterBeanEVENT, key, bean)) ;
				return true ;

			} else
			{
				var msg:String = "";
				
				if ( isRegistered( key ) )
				{
					msg = this+".register("+key+", "+bean+") fails, key is already registered." ;
				}
				
				if ( isBeanRegistered( bean ) )
				{
					msg += this + ".register(" + key + ", " + bean + ") fails, bean is already registered.";
				}
				
				PixlibDebug.ERROR(msg) ;
				throw( new UnsupportedOperationException( msg ) );
				return false ;
				
			}
		}
		
		public function unregister ( key : String ) : Boolean
		{
			if (isRegistered(key))
			{
				_m.remove(key) ;
				_oEB.broadcastEvent(new BeanEvent(BeanFactory.onUnregisterBeanEVENT, key, null)) ;
				return true ;
			}
			else
			{
				return false ;
			}
		}
		
		public function addListener( listener : BeanFactoryListener ) : Boolean
		{
			return _oEB.addListener( listener ) ;
		}
		
		public function removeListener( listener : BeanFactoryListener ) : Boolean
		{
			return _oEB.removeListener( listener );
		}
		
		public function addEventListener( type : String, listener : Object ) : Boolean
		{
			return _oEB.addEventListener( type, listener );
		}
		
		public function removeEventListener( type : String, listener : Object ) : Boolean
		{
			return _oEB.removeEventListener( type, listener );
		}
		
		public function toString() : String 
		{
			return PixlibStringifier.stringify( this );
		}
		
		public static function release():void
		{
			if ( BeanFactory._oI is BeanFactory ) BeanFactory._oI = null;
		}
	}
}

internal class PrivateConstructorAccess {}