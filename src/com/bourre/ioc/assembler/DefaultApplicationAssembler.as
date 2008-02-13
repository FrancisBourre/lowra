package com.bourre.ioc.assembler
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
	import flash.net.URLRequest;
	
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
	import com.bourre.ioc.parser.ContextTypeList;	

	public class DefaultApplicationAssembler 
		implements ApplicationAssembler
	{
		protected var _oDOB : DisplayObjectBuilder;
		
		public function setDisplayObjectBuilder( displayObjectBuilder : DisplayObjectBuilder ) : void
		{
			_oDOB = displayObjectBuilder;
		}

		public function getDisplayObjectBuilder() : DisplayObjectBuilder
		{
			return _oDOB;
		}

		public function buildLoader (	ID 							: String, 
										url 						: URLRequest, 
										progressCallback 			: String 	= null, 
										nameCallback 				: String 	= null, 
										timeoutCallback 			: String 	= null, 
										parsedCallback 				: String 	= null, 
										methodsCallCallback 		: String 	= null, 
										objectsBuiltCallback		: String 	= null, 
										channelsAssignedCallback	: String 	= null, 
										initCallback 				: String 	= null	) : void
		{
			getDisplayObjectBuilder().buildDisplayLoader( new DisplayLoaderInfo( 	ID, 
																					url, 
																					progressCallback, 
																					nameCallback, 
																					timeoutCallback, 
																					parsedCallback, 
																					methodsCallCallback, 
																					objectsBuiltCallback, 
																					channelsAssignedCallback, 
																					initCallback ) 				);
		}

		public function buildDLL( url : URLRequest ) : void
		{
			getDisplayObjectBuilder().buildDLL( new DisplayObjectInfo( null, null, false, url ) );
		}
		
		public function buildDisplayObject( 		ID : String,
													parentID : String,
													url : URLRequest = null,
													isVisible : Boolean = true,
													type : String = null ) : void
		{
			getDisplayObjectBuilder().buildDisplayObject( new DisplayObjectInfo( ID, parentID, isVisible, url, type ) );
		}

		public function buildProperty( 	ownerID : String, 
										name 	: String = null, 
										value 	: String = null, 
										type 	: String = null, 
										ref 	: String = null, 
										method 	: String = null	) : void
		{
			PropertyExpert.getInstance().addProperty( ownerID, name, value, type, ref, method );
		}

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
			MethodExpert.getInstance().register( HashCodeFactory.getKey( method ), method );
		}

		public function buildChannelListener( ownerID : String, channelName : String ) : void
		{
			var channelListener : ChannelListener = new ChannelListener( ownerID, channelName );
			ChannelListenerExpert.getInstance().register( HashCodeFactory.getKey( channelListener ), channelListener );
		}
	}
}