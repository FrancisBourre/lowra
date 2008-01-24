package com.bourre.ioc.assembler.property 
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
	import com.bourre.collection.HashMap;
	import com.bourre.error.IllegalArgumentException;
	import com.bourre.events.*;
	import com.bourre.ioc.bean.BeanEvent;
	import com.bourre.ioc.bean.BeanFactory;
	import com.bourre.ioc.bean.BeanFactoryListener;
	import com.bourre.ioc.control.BuildFactory;
	import com.bourre.ioc.core.IDExpert;
	import com.bourre.ioc.parser.ContextTypeList;
	import com.bourre.log.PixlibDebug;
	import com.bourre.utils.ObjectUtils;	

	public class PropertyExpert 
		implements BeanFactoryListener
	{
		private static var _oI : PropertyExpert;
		private var _oEB : EventBroadcaster;
		private var _mProperty : HashMap;

		public static function getInstance() : PropertyExpert
		{
			if ( !( _oI is PropertyExpert ) ) _oI = new PropertyExpert( new PrivateConstructorAccess() );
			return _oI;
		}
		
		public static function release() : void
		{
			if ( PropertyExpert._oI is PropertyExpert ) PropertyExpert._oI = null;
		}

		public function PropertyExpert( o : PrivateConstructorAccess )
		{
			_oEB = new EventBroadcaster( this, PropertyExpertListener );
			_mProperty = new HashMap();

			BeanFactory.getInstance().addListener( this );
			addListener( IDExpert.getInstance() );
		}

		public function setPropertyValue( p : Property, target : Object ) : void
		{
			target[ p.name ] = getValue( p ) ;
		}

		public function getValue( p : Property ) : *
		{
			var msg : String;

			if ( p.method ) 
			{
				var a : Array = p.method.split( "." );
				var target : Object = BeanFactory.getInstance().locate( a[0] );
				var methodName : String = a[1];

				if ( target.hasOwnProperty( methodName ) && target[ methodName ] is Function )
				{
					return target[ methodName ];

				} else
				{
					msg = this + ".getValue() failed to retrieve method of '" + target + "' named '" + methodName + "'";
					PixlibDebug.FATAL( msg );
					throw new IllegalArgumentException( msg );
				}

			} else if ( p.ref )
			{
				var ref : String = p.ref;

				if ( ref.indexOf(".") == -1 )
				{
					return BeanFactory.getInstance().locate( p.ref );
					
				} else
				{
					var args : Array = ref.split(".");
					var oRef : Object = BeanFactory.getInstance().locate( String( args.shift() ) );
					return ObjectUtils.evalFromTarget( oRef, args.join(".") );
				}

			} else
			{
				var type : String = p.type ? p.type : ContextTypeList.STRING;
				return BuildFactory.getInstance().getBuilder( type ).build( type, [p.value] );
			}
		}

		public function deserializeArguments( a : Array ) : Array
		{
			var r : Array;
			var l : Number = a.length;

			if ( l > 0 ) r = new Array();

			for ( var i : Number = 0; i < l; i++ ) 
			{
				var o : * = a[i];
				if ( o is Property )
				{
					r.push( getValue( o as Property ) );

				} else if ( o is DictionaryItem )
				{
					var di : DictionaryItem = o as DictionaryItem;
					di.key = getValue( di.getPropertyKey() );					di.value = getValue( di.getPropertyValue() );
					r.push( di );
				}
			}

			return r;
		}
		
		public function buildProperty( 	ownerID : String, 
										name 	: String = null, 
										value 	: String = null, 
										type 	: String = null, 
										ref 	: String = null, 
										method 	: String = null  ) : Property
		{
			var p : Property = new Property( ownerID, name, value, type, ref, method );
			_oEB.broadcastEvent( new PropertyEvent( p ) );
			return p;
		}
		
		public function addProperty( 	ownerID : String, 
										name 	: String = null, 
										value 	: String = null, 
										type 	: String = null, 
										ref 	: String = null, 
										method 	: String = null  ) : Property
		{
			var p : Property = buildProperty( ownerID, name, value, type, ref, method );

			if ( _mProperty.containsKey( ownerID ) )
			{
				( _mProperty.get( ownerID ) as Array ).push( p );

			} else
			{
				var a : Array = new Array();
				a.push( p );
				_mProperty.put( ownerID, a );
			}

			return p;
		}

		/**
		 * Event system
		 */
		public function addListener( listener : PropertyExpertListener ) : Boolean
		{
			return _oEB.addListener( listener );
		}

		public function removeListener( listener : PropertyExpertListener ) : Boolean
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
		 * IBeanFactoryListener callbacks
		 */
		public function onRegisterBean( e : BeanEvent ) : void
		{
			var id : String = e.getID();
			var bean : Object = e.getBean();

			if ( _mProperty.containsKey( id ) )
			{
				var props : Array = _mProperty.get( id );
				var l : Number = props.length;
				while( -- l > - 1 ) setPropertyValue( props[ l ], bean );
			}
		}

		public function onUnregisterBean( e : BeanEvent ) : void
		{
			//
		}
	}
}

internal class PrivateConstructorAccess {}