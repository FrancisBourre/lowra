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
	import com.bourre.error.IllegalArgumentException;	
	import com.bourre.log.PixlibDebug;
	import com.bourre.log.PixlibStringifier;	

	/**
	 * Recordet class.
	 * 
	 * <p>TODO Documentation</p>
	 * 
	 * @author Francis Bourre
	 */
	public class   RecordSet implements Iterable
	{		protected var _aColumNames 	: Array;
		protected var _aItems 		: Array;

		public function RecordSet ( rawData : *  )
		{
			parseRawData( rawData );
		}

		public function clear () : void
		{
			_aColumNames = new Array( );
			_aItems = new Array( );
		}

		public function parseRawData ( rawData : *  ) : void
		{
			clear( );
			
			_aColumNames = rawData.serverInfo.columnNames;
	
			var aItems : Array = rawData.serverInfo.initialData;
			var i : Iterator = new ArrayIterator( aItems );
			while( i.hasNext( )) 
			{
				var item : Object = new Object( );
				var aProperties : Array = i.next( );
				
				var j : Iterator = new ArrayIterator( aProperties );
				var n : int = 0 ;
				while( j.hasNext( )) 
				{
					// TODO: know if * or Object
					var propertyValue : * = j.next( );
					var propertyName : String = _aColumNames[ n++ ];
					
					item[ propertyName ] = propertyValue;
				}
				
				_aItems.push( item );
			}
		}

		public function getColumnNames () : Array 
		{
			return _aColumNames;
		}

		public function getItems () : Array
		{
			return _aItems;
		}

		public function getItemAt ( n : Number ) : Object
		{
			if ( isEmpty( ) )
			{
				PixlibDebug.WARN( this + ".getItemAt(" + n + ") can't retrieve data, collection is empty." );
				return null;

			} else if ( n < 0 || n >= getLength( ) ) 
			{
				var msg : String = this + ".getItemAt() was used with invalid value :'" + n + "', " + this + ".getLength() equals '" + getLength( ) + "'";
				PixlibDebug.ERROR( msg );
				throw new IllegalArgumentException( msg );
				
				return null;

			} else
			{
				return _aItems[ n ];
			}
		}

		public function isEmpty () : Boolean
		{
			return _aItems.length == 0;
		}

		public function columnIterator ( ) : Iterator 
		{
			return new ArrayIterator( getColumnNames( ) );
		}

		public function iterator () : Iterator
		{
			return new ArrayIterator( getItems( ) );
		}

		public function getLength () : Number
		{
			return _aItems.length;
		}

		/**
		 * Returns the string representation of this instance.
		 * 
		 * @return the string representation of this instance
		 */
		public function toString () : String 
		{
			return PixlibStringifier.stringify( this ) + 'column[' + getColumnNames( ) + '] values[' + getItems( ) + ']' ; 
		}
	}
}