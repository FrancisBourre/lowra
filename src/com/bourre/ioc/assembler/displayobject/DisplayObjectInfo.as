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
 
package com.bourre.ioc.assembler.displayobject
{
	import com.bourre.events.ValueObject;
	import com.bourre.ioc.parser.ContextTypeList;
	import com.bourre.log.PixlibStringifier;
	
	import flash.net.URLRequest;	
	
	/**
	 * Value object to store Display object configuration defined in 
	 * xml context.
	 * 
	 * @author Francis Bourre
	 */
	public class DisplayObjectInfo implements ValueObject
	{
		//--------------------------------------------------------------------
		// Private properties
		//--------------------------------------------------------------------
		
		private var _aChilds: Array;
		
				
		//--------------------------------------------------------------------
		// Public properties
		//--------------------------------------------------------------------
		
		/**
		 * Display object identifer.
		 * 
		 * @default null
		 */		
		public var ID 		: String;
		
		/**
		 * Display object parent identifer.
		 * 
		 * @default null
		 */	
		public var parentID : String;
		
		/**
		 * Visibility of display object.
		 * 
		 * @default null
		 */	
		public var isVisible: Boolean;
		
		/**
		 * Type of display object.
		 * 
		 * @default null
		 */	
		public var type		: String;
		
		/**
		 * Display object content url.
		 * 
		 * @default null
		 */	
		public var url : URLRequest;
		
		
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
		
		/**
		 * Creates instance.
		 */
		public function DisplayObjectInfo ( ID			: String, 
											parentID	: String	= null, 
											isVisible	: Boolean 	= true, 
											url 		: URLRequest = null, 
											type		: String 	= null )
		{
			this.ID 		= ID;
			this.parentID 	= parentID;
			this.isVisible 	= isVisible;
			this.type 		= (type == null) ? ContextTypeList.MOVIECLIP : type;
			this.url 		= url;
			_aChilds 		= new Array();
		}
		
		/**
		 * Adds child to current display object.
		 */
		public function addChild( o : DisplayObjectInfo ) : void
		{
			_aChilds.push( o );
		}
		
		/**
		 * Returns childs list.
		 */
		public function getChild() : Array
		{
			return _aChilds.concat();
		}
		
		/**
		 * Returns <code>true</code> if display object has childs.
		 */
		public function hasChild() : Boolean
		{
			return getNumChild() > 0;
		}
		
		/**
		 * Returns childs count.
		 */
		public function getNumChild() : int
		{
			return _aChilds.length;
		}
		
		/**
		 * Returns <code>true</code> if display object is an empty 
		 * container. (eq url == null ).
		 */
		public function isEmptyDisplayObject() : Boolean
		{
			return ( url == null );
		}
		
		/**
		 * Returns the string representation of this instance.
		 * @return the string representation of this instance
		 */
		public function toString() : String 
		{
			var s : String = " ";
			s += "ID:" + ID + ", ";			s += "url:" + url + ", ";
			s += "parentID:" + parentID + ", ";			s += "isVisible:" + isVisible + ", ";			s += "url:" + type + ", ";			s += "hasChild:" + hasChild() + ", ";			s += "numChild:" + getNumChild();
			
			return PixlibStringifier.stringify( this ) + s;
		}
	}
}
