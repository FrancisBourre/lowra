package com.bourre.ioc.assembler.method 
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
	import com.bourre.error.NoSuchMethodException;
	import com.bourre.events.EventBroadcaster;
	import com.bourre.ioc.assembler.property.PropertyExpert;
	import com.bourre.ioc.bean.BeanFactory;
	import com.bourre.log.PixlibDebug;
	import com.bourre.log.PixlibStringifier;	

	public class MethodExpert
	{
		private static var	_oI		: MethodExpert;

		private var 		_oEB 	: EventBroadcaster;
		private var 		_aMethod: Array;

		public static function getInstance() : MethodExpert
		{
			if ( !(MethodExpert._oI is MethodExpert) ) 
				MethodExpert._oI = new MethodExpert( new PrivateConstructorAccess() );

			return MethodExpert._oI;
		}

		public static function release() : void
		{
			if ( MethodExpert._oI is MethodExpert ) MethodExpert._oI = null;
		}

		public function MethodExpert( access : PrivateConstructorAccess )
		{
			_oEB = new EventBroadcaster( this, MethodExpertListener );
			_aMethod = new Array();
		}

		public function addMethod ( ownerID : String, name : String, args : Array ) : Method
		{
			var m : Method = new Method( ownerID, name, args );
			_aMethod.push( m ) ;
			_oEB.broadcastEvent( new MethodEvent( m ) );
			return m;
		}
		
		public function callMethod( m : Method ) : void
		{
			var f : Function;
			var msg : String;
			var owner : Object = BeanFactory.getInstance().locate( m.ownerID );

			try
			{
				f = owner[ m.name ] as Function;

			} catch ( e : Error )
			{
				msg = this + ".callMethod() failed. " + m.ownerID + "." + m.name + " method was not found.";
				PixlibDebug.FATAL( msg );
				throw new NoSuchMethodException( msg );
			}

			try
			{
				f.apply( null, PropertyExpert.getInstance().deserializeArguments( m.args ) );

			} catch ( e : Error )
			{
				var msg : String = this + ".callMethod() failed. " + m.ownerID + "." + m.name + "() can't be called.";
				PixlibDebug.FATAL( msg );
				throw new IllegalArgumentException( msg );
			}
		}

		public function callAllMethods() : void
		{
			var l : int = _aMethod.length;
			for ( var i : int = 0; i < l; i++ ) callMethod( _aMethod[i] );
		}
		
		/**
		 * Event system
		 */
		public function addListener( listener : MethodExpertListener ) : Boolean
		{
			return _oEB.addListener( listener );
		}

		public function removeListener( listener : MethodExpertListener ) : Boolean
		{
			return _oEB.removeListener( listener );
		}

		public function addEventListener( type : String, listener : Object, ... rest ) : Boolean
		{
			return _oEB.addEventListener.apply( _oEB, rest.length > 0 ? [ type, listener ].concat( rest ) : [ type, listener ] );
		}

		public function removeEventListener( type : String, listener : Object ) : Boolean
		{
			return _oEB.removeEventListener( type, listener );
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