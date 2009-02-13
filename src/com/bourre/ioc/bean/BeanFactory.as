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

package com.bourre.ioc.bean
{
	import com.bourre.collection.HashMap;
	import com.bourre.core.Locator;
	import com.bourre.error.IllegalArgumentException;
	import com.bourre.error.NoSuchElementException;
	import com.bourre.error.PrivateConstructorException;
	import com.bourre.events.EventBroadcaster;
	import com.bourre.log.PixlibDebug;
	import com.bourre.log.PixlibStringifier;
	
	import flash.utils.Dictionary;	

	/**
	 *  Dispatched when a bean is registered.
	 *  
	 *  @eventType com.bourre.ioc.bean.BeanEvent.onRegisterBeanEVENT
	 */
	[Event(name="onRegisterBean", type="com.bourre.ioc.bean.BeanEvent")]
	
	/**
	 *  Dispatched when a bean is unregistered.
	 *  
	 *  @eventType com.bourre.ioc.bean.BeanEvent.onUnregisterBeanEVENT
	 */
	[Event(name="onUnregisterBean", type="com.bourre.ioc.bean.BeanEvent")]
	
	/**
	 * Bean factory manager.
	 * 
	 * @author Francis Bourre
	 * @author Olympe Dignat
	 */
	public class BeanFactory implements Locator
	{
		//--------------------------------------------------------------------
		// Private properties
		//--------------------------------------------------------------------
			
		private static  var _oI : BeanFactory ;

		private var _oEB : EventBroadcaster ;
		private var _m : HashMap ;
		
		
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
		
		/**
		 * Returns unique factory instance.
		 */	
		public static function getInstance() : BeanFactory
		{
			if ( !(BeanFactory._oI is BeanFactory) ) BeanFactory._oI = new BeanFactory( new PrivateConstructorAccess( ) );
			return BeanFactory._oI;
		}
		
		/**
		 * Releases factory.
		 * 
		 * <p>Factory is not cleared.</p>
		 */
		public static function release() : void
		{
			if ( BeanFactory._oI is BeanFactory ) BeanFactory._oI = null;
		}
		
		/**
		 * Returns all registered keys on an Array.
		 */
		public function  getKeys() : Array
		{
			return _m.getKeys( ) ;
		}
		
		/**
		 * Returns all registered values on an Array.
		 */
		public function getValues() : Array
		{
			return _m.getValues( ) ;
		}
		
		/**
		 * Clears factory
		 */
		public function clear() : void
		{
			_m.clear( );
		}
		
		/**
		 * Searchs and returns value registered with passed-in key.
		 * 
		 * @param	key	Registered key to search
		 * 
		 * @throws 	<code>NoSuchElementException</code> — key is not
		 * 			registered in factory
		 */
		public function  locate( key : String ) : Object
		{
			if ( isRegistered( key ) )
			{
				return _m.get( key ) ;
			} 
			else
			{
				var msg : String = this + ".locate(" + key + ") fails." ;
				PixlibDebug.ERROR( msg ) ;
				throw( new NoSuchElementException( msg ) ) ;
			}
		}
		
		/**
		 * Returns <code>true</code> if passed-in key is registered in factory.
		 */
		public function isRegistered( key : String ) : Boolean
		{
			return _m.containsKey( key ) ;
		}
		
		/**
		 * Returns <code>true</code> if passed-in bean is registered in factory.
		 */
		public function isBeanRegistered( bean : Object ) : Boolean
		{
			return _m.containsValue( bean ) ;
		}
		
		/**
		 * Registers new key / bean pair into factory. 
		 * 
		 * @param	key		Key to register		 * @param	bean	Value to record
		 * 
		 * @throws 	<code>IllegalArgumentException</code> — key or bean are 
		 * 			already registered in factory
		 */
		public function register( key : String, bean : Object ) : Boolean
		{
			if ( !( isRegistered( key ) ) && !( isBeanRegistered( bean ) ) )
			{
				_m.put( key, bean ) ;
				_oEB.broadcastEvent( new BeanEvent( BeanEvent.onRegisterBeanEVENT, key, bean ) ) ;
				return true ;
			} 
			else
			{
				var msg : String = "";

				if ( isRegistered( key ) )
				{
					msg += this + ".register(" + key + ", " + bean + ") fails, key is already registered." ;
				}

				if ( isBeanRegistered( bean ) )
				{
					msg += this + ".register(" + key + ", " + bean + ") fails, bean is already registered.";
				}

				PixlibDebug.ERROR( msg ) ;
				throw( new IllegalArgumentException( msg ) );
				return false ;
			}
		}
		
		/**
		 * Unregisters key from factory. 
		 * 
		 * @param	key		Key to unregister
		 */
		public function unregister( key : String ) : Boolean
		{
			if ( isRegistered( key ) )
			{
				_m.remove( key ) ;
				_oEB.broadcastEvent( new BeanEvent( BeanEvent.onUnregisterBeanEVENT, key, null ) ) ;
				return true ;
			}
			else
			{
				return false ;
			}
		}
		
		/**
		 * Unregisters bean from factory. 
		 * 
		 * <p>Key is unregistered too.</p>
		 * 
		 * @param	bean		Value to unregister
		 */
		public function unregisterBean( bean : Object ) : Boolean
		{
			var key : String = getKey( bean );
			return ( key != null ) ? unregister( key ) : false;
		}
		
		/**
		 * Returns registered key for passes-in bean object.
		 * 
		 * @param	bean	Bean object to search
		 */
		public function getKey( bean : Object ) : String
		{
			var key : String;
			var b : Boolean = isBeanRegistered( bean );

			if ( b )
			{
				var a : Array = _m.getKeys( );
				var l : uint = a.length;

				while( --l > -1 ) 
				{
					key = a[ l ];
					if ( locate( key ) == bean ) return key;
				}
			}
			
			return null;
		}
		
		/**
		 * Adds the passed-in listener as listener for all events dispatched
		 * by this event broadcaster. The function returns <code>true</code>
		 * if the listener have been added at the end of the call. If the
		 * listener is already registered in this event broadcaster the function
		 * returns <code>false</code>.
		 * <p>
		 * Note : The <code>addListener</code> function doesn't accept functions
		 * as listener, functions could only register for a single event.
		 * </p>
		 * @param	listener	the listener object to add as global listener
		 * @return	<code>true</code> if the listener have been added during this call
		 * @throws 	<code>IllegalArgumentException</code> — If the passed-in listener
		 * 			listener doesn't match the listener type supported by this event
		 * 			broadcaster
		 * @throws 	<code>IllegalArgumentException</code> — If the passed-in listener
		 * 			is a function
		 */
		public function addListener( listener : BeanFactoryListener ) : Boolean
		{
			return _oEB.addListener( listener );
		}
		
		/**
		 * Removes the passed-in listener object from this event
		 * broadcaster. The object is removed as listener for all
		 * events the broadcaster may dispatch.
		 * 
		 * @param	listener	the listener object to remove from
		 * 						this event broadcaster object
		 * @return	<code>true</code> if the object have been successfully
		 * 			removed from this event broadcaster
		 * @throws 	<code>IllegalArgumentException</code> — If the passed-in listener
		 * 			is a function
		 */
		public function removeListener( listener : BeanFactoryListener ) : Boolean
		{
			return _oEB.removeListener( listener );
		}
		
		/**
		 * Adds an event listener for the specified event type.
		 * There is two behaviors for the <code>addEventListener</code>
		 * function : 
		 * <ol>
		 * <li>The passed-in listener is an object : 
		 * The object is added as listener only for the specified event, the object must
		 * have a function with the same name than <code>type</code> or at least a
		 * <code>handleEvent</code> function.</li>
		 * <li>The passed-in listener is a function : 
		 * A <code>Delegate</code> object is created and then
		 * added as listener for the event type. There is no restriction on the name of 
		 * the function. If the <code>rest</code> is not empty, all elements in it is 
		 * used as additional arguments into the delegate object. 
		 * </ol>
		 * 
		 * @param	type		name of the event for which register the listener
		 * @param	listener	object or function which will receive this event
		 * @param	rest		additional arguments for the function listener
		 * @return	<code>true</code> if the function have been succesfully added as
		 * 			listener fot the passed-in event
		 * @throws 	<code>UnsupportedOperationException</code> — If the listener is an object
		 * 			which have neither a function with the same name than the event type nor
		 * 			a function called <code>handleEvent</code>
		 */
		public function addEventListener( type : String, listener : Object, ... rest ) : Boolean
		{
			return _oEB.addEventListener.apply( _oEB, rest.length > 0 ? [ type, listener ].concat( rest ) : [ type, listener ] );
		}
		
		/**
		 * Removes the passed-in listener for listening the specified event. The
		 * listener could be either an object or a function.
		 * 
		 * @param	type		name of the event for which unregister the listener
		 * @param	listener	object or function to be unregistered
		 * @return	<code>true</code> if the listener have been successfully removed
		 * 			as listener for the passed-in event
		 */
		public function removeEventListener( type : String, listener : Object ) : Boolean
		{
			return _oEB.removeEventListener( type, listener );
		}
		
		/**
		 * @inheritDoc
		 */
		public function add( d : Dictionary ) : void
		{
			for ( var key : * in d ) 
			{
				try
				{
					register( key, d[ key ] as Object );
				} catch( e : IllegalArgumentException )
				{
					e.message = this + ".add() fails. " + e.message;
					PixlibDebug.ERROR( e.message );
					throw( e );
				}
			}
		}
		
		/**
		 * Returns string representation.
		 */
		public function toString() : String 
		{
			return PixlibStringifier.stringify( this );
		}
		
		
		//--------------------------------------------------------------------
		// Private implementation
		//--------------------------------------------------------------------
		
		/** @private */
		public function BeanFactory( access : PrivateConstructorAccess )
		{
			if ( !(access is PrivateConstructorAccess) ) throw new PrivateConstructorException();
			
			_oEB = new EventBroadcaster( this ) ;
			_m = new HashMap( ) ;
		}		
	}
}

internal class PrivateConstructorAccess 
{
}