package com.bourre.ioc.core
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
	import flash.utils.Dictionary;

	import com.bourre.collection.HashMap;
	import com.bourre.collection.Set;
	import com.bourre.error.IllegalArgumentException;
	import com.bourre.error.NoSuchElementException;
	import com.bourre.ioc.assembler.property.PropertyEvent;
	import com.bourre.ioc.assembler.property.PropertyExpertListener;
	import com.bourre.log.PixlibDebug;
	import com.bourre.log.PixlibStringifier;	

	public class IDExpert
		implements PropertyExpertListener
	{
		private static var _oI : IDExpert;

		private var _d : Dictionary;
		private var _c : Set;
		private var _m : HashMap;

		/**
		 * @return singleton instance of IDExpert
		 */
		public static function getInstance() : IDExpert 
		{
			if ( !(IDExpert._oI is IDExpert) ) IDExpert._oI = new IDExpert( new PrivateConstructorAccess() );
			return IDExpert._oI;
		}
		
		public static function release() : void
		{
			if ( IDExpert._oI is IDExpert ) IDExpert._oI = null;
		}

		public function IDExpert( access : PrivateConstructorAccess )
		{
			_d = new Dictionary( true );
			_c = new Set();
			_m = new HashMap();
		}

		public function onBuildProperty( e : PropertyEvent ) : void
		{
			var refID : String;

			var methodName : String = e.getPropertyMethod();
			if ( methodName != null )
			{
				var split : Array = methodName.split( ".");
				_pushReference( split[0], e.getPropertyOwnerID() );

			} else
			{
				refID = e.getPropertyRef();
				if ( refID != null ) _pushReference( refID, e.getPropertyOwnerID() );
			}

//			if ( refID != null ) 
//			{
//				if ( refID.indexOf(".") != -1 )
//				{
//					var a : Array = refID.split(".");
//					refID = a[0];
//				}
//
//				_pushReference( refID, e.getPropertyOwnerID() );
//			}
		}

		public function onRegisterPropertyOwner( e : PropertyEvent ) : void {}
		public function onUnregisterPropertyOwner( e : PropertyEvent ) : void{}

		private function _pushReference( refID : String, ownerID : String ) : void
		{	
			_c.add( refID );

			var nRef : int = _c.indexOf( refID );
			var nOwner : int = _c.indexOf( ownerID );
			
			if ( nRef > nOwner )
			{
				_c.removeAt( nRef );
				_c.addAt( nOwner, refID );
			}
		}

		public function getReferenceList() : Set
		{
			return _c;
		}
		
		// check for id conflicts
		public function isRegistered( id : String ) : Boolean
		{
			return (_d[ id ] == true) ? true : false;
		}

		public function register( id : String ) : Boolean
		{
			if (  _d[ id ] ) 
			{
				var msg : String = this + ".register(" + id + ") failed. This id was already registered, check conflicts in your config file.";
				PixlibDebug.ERROR( msg );
				throw( new IllegalArgumentException( msg ) );

			} else
			{
				_d[ id ] = true;
				_c.add( id );
				return true;
			}

			return false;
		}
		
		public function unregister( id : String ) : Boolean
		{
			if ( isRegistered( id ) ) 
			{
				_d[ id ] = false;
				_c.remove( id );
				return true;

			} else
			{
				var msg : String =  this + ".unregister(" + id + ") failed.";
				PixlibDebug.ERROR( msg );
				throw( new NoSuchElementException( msg ) );
			}

			return false;
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