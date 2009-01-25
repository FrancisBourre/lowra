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
package com.bourre.collection 
{
	import com.bourre.collection.Iterator;
	import com.bourre.error.NoSuchElementException;
	import com.bourre.error.UnsupportedOperationException;
	import com.bourre.log.PixlibDebug;
	
	import flash.utils.getQualifiedClassName;		

	/**
	 * The <code>XMLListIterator</code> class provides a convenient way
	 * to iterate through each entry of an <code>XMLList</code> instance.
	 * <p>
	 * Iterations are performed from <code>0</code> to <code>length</code> 
	 * of the passed-in XMLList instance.
	 * </p> 
	 * 
	 * @author 	Cedric Nehemie
	 * @see		ListIterator
	 */
	public class XMLListIterator 
		implements Iterator 
	{
		protected var list 		: XMLList;
		protected var length 	: Number;
		protected var index 	: Number;

		/**
		 * Creates a new iterator for the passed-in XMLList instance.
		 * 
		 * @param	list	<code>XMLList</code> iterator's target
		 */
		public function XMLListIterator ( list : XMLList )
		{
			this.list = list;
			this.length = list.length();
			index = -1;
		}

		/**
		 * @inheritDoc
		 */
		public function hasNext () : Boolean
		{
			return index + 1 < length;
		}

		/**
		 * @inheritDoc
		 */
		public function next () : *
		{
			if( !hasNext() )
			{
				var msg : String = this + " has no more element at '" + ( index + 1 ) +"' index.";
				PixlibDebug.ERROR( msg );
				throw new NoSuchElementException ( msg );
			}
			
			return list[ ++index ];
		}

		/**
		 * @inheritDoc
		 */
		public function remove () : void
		{
			var msg : String = "remove is currently not supported in " + getQualifiedClassName( this );
			PixlibDebug.ERROR( msg );
			throw new UnsupportedOperationException(  );
		}
	}
}
