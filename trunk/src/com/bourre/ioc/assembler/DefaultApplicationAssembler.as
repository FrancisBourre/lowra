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
package com.bourre.ioc.assembler
{
	import com.bourre.core.HashCodeFactory;
	import com.bourre.ioc.assembler.channel.ChannelListener;
	import com.bourre.ioc.assembler.channel.ChannelListenerExpert;
	import com.bourre.ioc.assembler.constructor.Constructor;
	import com.bourre.ioc.assembler.constructor.ConstructorExpert;
	import com.bourre.ioc.assembler.displayobject.DisplayLoaderInfo;
	import com.bourre.ioc.assembler.displayobject.DisplayObjectBuilder;
	import com.bourre.ioc.assembler.displayobject.DisplayObjectInfo;
	import com.bourre.ioc.assembler.method.Method;
	import com.bourre.ioc.assembler.method.MethodExpert;
	import com.bourre.ioc.assembler.property.DictionaryItem;
	import com.bourre.ioc.assembler.property.Property;
	import com.bourre.ioc.assembler.property.PropertyExpert;
	import com.bourre.ioc.assembler.resource.Resource;
	import com.bourre.ioc.core.IDExpert;
	import com.bourre.ioc.parser.ContextTypeList;
	
	import flash.net.URLRequest;	

	/**
	 * Default application assembler implementation.
	 * 
	 * @author Francis Bourre
	 */	public class DefaultApplicationAssembler implements ApplicationAssembler
	{
		//--------------------------------------------------------------------
		// Protected properties
		//--------------------------------------------------------------------
		
		/** @private */
		protected var _oIE 	: IDExpert;
		
		/** @private */
		protected var _oDOB : DisplayObjectBuilder;
		
		
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
		
		/**
		 * @inheritDoc
		 */
		public function setDisplayObjectBuilder( displayObjectBuilder : DisplayObjectBuilder ) : void
		{
			_oDOB = displayObjectBuilder;
			_oIE = new IDExpert();
		}
		
		/**
		 * @inheritDoc
		 */
		public function getDisplayObjectBuilder() : DisplayObjectBuilder
		{
			return _oDOB;
		}
		
		/**
		 * @inheritDoc
		 */
		public function buildLoader (	ID 							: String, 
										url 						: URLRequest, 
										startCallback 				: String 	= null,
										nameCallback 				: String 	= null, 
										loadCallback 				: String 	= null, 
										progressCallback 			: String 	= null, 
										timeoutCallback 			: String 	= null, 
										errorCallback 				: String 	= null, 
										initCallback 				: String 	= null, 
										parsedCallback 				: String 	= null, 
										objectsBuiltCallback		: String 	= null, 
										channelsAssignedCallback	: String 	= null, 
										methodsCallCallback 		: String 	= null, 
										completeCallback 			: String 	= null	) : void
		{
			getDisplayObjectBuilder().buildDisplayLoader( new DisplayLoaderInfo( 	ID, 
																					url, 
																					startCallback, 
																					nameCallback, 
																					loadCallback,
																					progressCallback,
																					timeoutCallback,
																					errorCallback,
																					initCallback, 
																					parsedCallback, 
																					objectsBuiltCallback, 
																					channelsAssignedCallback,
																					methodsCallCallback,
																					completeCallback ) );
		}
		
		/**
		 * @inheritDoc
		 */
		public function buildRoot( ID : String ) : void
		{
			getDisplayObjectBuilder().buildDisplayObject( new DisplayObjectInfo( ID, null, true, null, null ) );
		}
		
		/**
		 * @inheritDoc
		 */
		public function buildDLL( url : URLRequest ) : void
		{
			getDisplayObjectBuilder().buildDLL( new DisplayObjectInfo( null, null, false, url ) );
		}
		
		/**
		 * @inheritDoc
		 */
		public function buildDisplayObject( 		ID : String,
													parentID : String,
													url : URLRequest = null,
													isVisible : Boolean = true,
													type : String = null ) : void
		{
			getDisplayObjectBuilder().buildDisplayObject( new DisplayObjectInfo( ID, parentID, isVisible, url, type ) );
		}
		
		/**
		 * @inheritDoc
		 */
		public function buildResource( ID : String, url : URLRequest, type : String = null, deserializer : String = null ) : void
		{
			getDisplayObjectBuilder().buildResource( new Resource( ID, url, type, deserializer ) );
		}
		
		/**
		 * @inheritDoc
		 */
		public function buildProperty( 	ownerID : String, 
										name 	: String = null, 
										value 	: String = null, 
										type 	: String = null, 
										ref 	: String = null, 
										method 	: String = null	) : void
		{
			PropertyExpert.getInstance().addProperty( ownerID, name, value, type, ref, method );
		}
		
		/**
		 * @inheritDoc
		 */
		public function buildObject( 	ownerID 	: String, 
										type 		: String 	= null, 
										args 		: Array 	= null, 
										factory 	: String 	= null, 
										singleton 	: String 	= null) : void
		{
			if ( args != null )
			{
				var l : int = args.length;
				var i : int;
				var o : Object;

				if ( type == ContextTypeList.DICTIONARY )
				{
					for ( i = 0; i < l; i++ )
					{
						o = args[ i ];
						var key : Object = o.key;
						var value : Object = o.value;
						var pKey : Property = PropertyExpert.getInstance().buildProperty( ownerID, key.name, key.value, key.type, key.ref, key.method );
						var pValue : Property = PropertyExpert.getInstance().buildProperty( ownerID, value.name, value.value, value.type, value.ref, value.method );
						args[ i ] = new DictionaryItem( pKey, pValue );
					}

				} else
				{
					for ( i = 0; i < l; i++ )
					{
						o = args[ i ];
						var p : Property = PropertyExpert.getInstance().buildProperty( ownerID, o.name, o.value, o.type, o.ref, o.method );
						args[ i ] = p;
					}
				}
			}

			ConstructorExpert.getInstance().register( ownerID, new Constructor( ownerID, type, args, factory, singleton ) );
		}
		
		/**
		 * @inheritDoc
		 */
		public function buildMethodCall( ownerID : String, methodCallName : String, args : Array = null ) : void
		{
			if ( args != null )
			{
				var l : int = args.length;
				for ( var i : int; i < l; i++ )
				{
					var o : Object = args[ i ];
					var p : Property = new Property( o.id, o.name, o.value, o.type, o.ref, o.method );
					args[ i ] = p;
				}
			}
			
			var method : Method = new Method( ownerID, methodCallName, args );
			var index : Number = MethodExpert.getInstance( ).getKeys().length++;
			MethodExpert.getInstance().register( getOrderedKey( index ), method );
		}
		
		/**
		 * @inheritDoc
		 */
		public function buildChannelListener( ownerID : String, channelName : String, args : Array = null ) : void
		{
			var channelListener : ChannelListener = new ChannelListener( ownerID, channelName, args );
			ChannelListenerExpert.getInstance().register( HashCodeFactory.getKey( channelListener ), channelListener );
		}
		
		/**
		 * @inheritDoc
		 */
		public function registerID( ID : String ) : Boolean
		{
			return _oIE.register( ID );
		}
		
		
		//--------------------------------------------------------------------
		// Protected methods
		//--------------------------------------------------------------------
		
		/**
		 * Returns ordered key using passed-in index value.
		 */
		protected function getOrderedKey( index : Number ) : String
		{
			var d : Number = 5 - index.toString( ).length;
			var s : String = "";
			if( d > 0 ) for( var i : Number = 0; i < d ; i++ ) s += "0";
			return s + index;
		}	
	}
}