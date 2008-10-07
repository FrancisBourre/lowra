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
	import com.bourre.commands.Batch;
	import com.bourre.core.AbstractLocator;
	import com.bourre.ioc.assembler.constructor.Constructor;
	import com.bourre.ioc.bean.BeanEvent;
	import com.bourre.ioc.bean.BeanFactory;
	import com.bourre.ioc.bean.BeanFactoryListener;
	import com.bourre.ioc.control.BuildFactory;
	import com.bourre.ioc.parser.ContextTypeList;	

	public class PropertyExpert 
		extends AbstractLocator
		implements BeanFactoryListener
	{
		private static var _oI : PropertyExpert;

		public static function getInstance() : PropertyExpert
		{
			if ( !( PropertyExpert._oI is PropertyExpert ) ) 
				PropertyExpert._oI = new PropertyExpert( new PrivateConstructorAccess() );

			return PropertyExpert._oI;
		}
		
		public static function release() : void
		{
			PropertyExpert._oI = null;
		}

		public function PropertyExpert( o : PrivateConstructorAccess )
		{
			super( Array, PropertyExpertListener, null );

			BeanFactory.getInstance().addListener( this );
		}
		
		override protected function onRegister( id : String = null, o : Object = null ) : void
		{
			broadcastEvent( new PropertyEvent( PropertyEvent.onRegisterPropertyOwnerEVENT, id ) );
		}

		override protected function onUnregister( id : String = null ) : void
		{
			broadcastEvent( new PropertyEvent( PropertyEvent.onUnregisterPropertyOwnerEVENT, id ) );
		}

		public function setPropertyValue( p : Property, target : Object ) : void
		{
			target[ p.name ] = getValue( p );
		}

		public function getValue( p : Property ) : *
		{
			if ( p.method ) 
			{
				return BuildFactory.getInstance().build( new Constructor( null, ContextTypeList.FUNCTION, [ p.method ] ) );

			} else if ( p.ref )
			{
				return BuildFactory.getInstance().build( new Constructor( null, ContextTypeList.INSTANCE, null, null, null, p.ref ) );

			} else
			{
				var type : String = p.type/* && p.type != ContextTypeList.CLASS */? p.type : ContextTypeList.STRING;
				return BuildFactory.getInstance().build( new Constructor( p.ownerID, type, [ p.value ] ) );
			}
		}

		public function deserializeArguments( a : Array ) : Array
		{
			var r : Array;
			var l : Number = a.length;

			if ( l > 0 ) r = new Array();

			for ( var i : int; i < l; i++ ) 
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
			broadcastEvent( new PropertyEvent( PropertyEvent.onBuildPropertyEVENT, null, p ) );
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

			if ( isRegistered( ownerID ) )
			{
				( locate( ownerID ) as Array ).push( p );

			} else
			{
				register( ownerID, [ p ] );
			}

			return p;
		}

		public function addListener( listener : PropertyExpertListener ) : Boolean
		{
			return getBroadcaster().addListener( listener );
		}

		public function removeListener( listener : PropertyExpertListener ) : Boolean
		{
			return getBroadcaster().removeListener( listener );
		}

		public function onRegisterBean( e : BeanEvent ) : void
		{
			var id : String = e.getID();
			if ( isRegistered( id ) ) Batch.process( setPropertyValue, locate( id ) as Array, e.getBean() );
		}

		public function onUnregisterBean( e : BeanEvent ) : void {}
	}
}

internal class PrivateConstructorAccess {}