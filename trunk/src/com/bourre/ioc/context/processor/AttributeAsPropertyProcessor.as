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
 
package com.bourre.ioc.context.processor 
{
	import com.bourre.ioc.parser.ContextNodeNameList;	
	import com.bourre.collection.HashMap;
	import com.bourre.commands.Batch;
	import com.bourre.ioc.parser.ContextAttributeList;

	/**
	 * Transforms node attributes value to IoC property node.
	 * 
	 * @example Simple context
	 * <pre class="prettyprint">
	 * 
	 * &lt;beans&gt;
	 * 	&lt;heading id="test1" fontFamily="Arial" fontSize="100" type="Object"&gt;
	 *		&lt;property name="rank" value="First" /&gt;
	 * 	&lt;/heading&gt;
	 * &lt;/beans&gt;
	 * </pre>
	 * 
	 * @example Adds processor to context loader.
	 * <pre class="prettyprint">
	 * 	
	 * 	loader.addProcessor( new AttributeAsPropertyProcessor( "test1" ) );
	 * </pre>
	 * 
	 * @example Processing result.
	 * <pre class="prettyprint">
	 * 	
	 * &lt;beans&gt;
	 * 	&lt;heading id="test1" type="Object"&gt;
	 *		&lt;property name="rank" value="First" /&gt;
	 *		&lt;property name="fontFamily" value="Arial" /&gt;
	 *		&lt;property name="fontSize" value="100" /&gt;
	 * 	&lt;/heading&gt;
	 * &lt;/beans&gt;
	 * </pre>
	 * 
	 * @author Romain Ecarnot
	 */
	public class AttributeAsPropertyProcessor implements ContextProcessor
	{
		//--------------------------------------------------------------------
		// Private properties
		//--------------------------------------------------------------------
		
		private var _mName : HashMap;
		private var _aID : Array;
		private var _xml : XML;
		
		
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
		
		/**
		 * Creates new <code>AttributeAsPropertyProcessor</code> instance.
		 * 
		 * @param	id	Node identifier to search for
		 * @param	...	Additionnal nodes identifiers
		 */
		public function AttributeAsPropertyProcessor( id : String, ...args )
		{
			init();
			
			_aID = args.concat( [ id ] );
		}
		
		/**
		 * @inheritDoc
		 */
		public function process( xml : XML ) : XML
		{
			_xml = xml;
			
			Batch.process( processNode, _aID );
			
			return _xml;
		}
		

		//--------------------------------------------------------------------
		// Protected methods
		//--------------------------------------------------------------------
		
		/**
		 * Initializes attribute names hashmap with default values.
		 */
		protected function init() : void
		{
			_mName = new HashMap( );
			
			addAttributeName( ContextAttributeList.ID, "" );
			addAttributeName( ContextAttributeList.TYPE, "" );		}
		
		/**
		 * Adds a new attribute name.
		 * 
		 * @param	attributeName	Attribute name to add.
		 * @param	value			Value associated with new attribute name.
		 */
		protected function addAttributeName( attributeName : String, value : * ) : void
		{
			_mName.put( attributeName, value );
		}
		
		/**
		 * Returns <code>true</code> if passed-in <code>attributeName</code> 
		 * is a protected attribute name.
		 */
		protected function isReserved( attributeName : * ) : Boolean
		{
			return _mName.containsKey( attributeName );
		}
		
		protected function processNode( id : String ) : void
		{
			var node : XMLList = _xml..*.( hasOwnProperty( getAttributeName( ContextAttributeList.ID ) ) && @[ContextAttributeList.ID] == id );
			
			var atts : XMLList = node.attributes( );
			for each (var o : XML in atts) 
			{
				var nodeName : String = ContextNodeNameList.PROPERTY;
				var attName : String = o.name( ).toString( );
				
				if( !isReserved( attName ) )
				{
					var property : XML = <{nodeName} />;
					property.@[ContextAttributeList.NAME] = attName;
					property.@[ContextAttributeList.VALUE] = o.toString( );
					
					node.appendChild( property );
				}
			}
		}
		
				
		//--------------------------------------------------------------------
		// Private implementation
		//--------------------------------------------------------------------

		private static function getAttributeName( name : String ) : String
		{
			return "@" + name;		
		}		
	}
}
