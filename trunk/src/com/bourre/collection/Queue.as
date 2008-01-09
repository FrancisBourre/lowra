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
	import com.bourre.collection.Collection;
	import com.bourre.collection.Iterator;
	import com.bourre.error.ClassCastException;
	import com.bourre.error.IllegalArgumentException;
	import com.bourre.error.NullPointerException;
	import com.bourre.log.PixlibDebug;
	import com.bourre.log.PixlibStringifier;		

	/**
	 * A collection designed for holding elements prior to processing.
	 * Besides basic <code>Collection</code> operations,
	 * queues provide additional insertion, extraction, and inspection
	 * operations.
	 * <p>
	 * Elements in a <code>Queue</code> are orderered according to a LIFO
	 * (last-in-first-out) order.
	 * </p><p>
	 * As ActionScript 3 doesn't support typed array for the moment, there
	 * is no way to check the type of elements within the queue.
	 * In upcoming version of the Flash Player there is more and more chance
	 * to have a way to type Array's entries, so if its the case the 
	 * queue would provide type-safety for its entries in next
	 * release.
	 * </p> 
	 * @author 	Romain Flacher
	 * @example 
	 * Using an untyped <code>Queue</code>
	 * <listing>var aq : Queue = new Queue ();
	 * aq.add( 20 )
	 * aq.add( "20" );
	 * aq.add( 80 );
	 * 
	 * trace ( aq.size() ); // 3 
	 * trace ( aq.poll() ); // 80
	 * 
	 * trace ( aq.peek() ); // "20"
	 * trace ( aq.size() ); // 2 
	 * </listing>
	 * 
	 * Using a typed <code>Queue</code>
	 * <listing>var aq : Queue = new Queue ( Number );
	 * aq.add( 20 )
	 * try
	 * {
	 * 	aq.add( "20" ); // throws an error because "20" is not a Number
	 * 	aq.add( 80 );
	 * }
	 * catch ( e : Error ) {}
	 * 
	 * trace ( aq.size() ); // 2
	 * trace ( aq.poll() ); // 80
	 * 
	 * trace ( aq.peek() ); // 20
	 * trace ( aq.size() ); // 1 
	 * </listing>
	 */
	public class Queue implements Collection, TypedContainer
	{
		private var _aStack : Array;
		private var _oType : Class;

		/**
		 * Create an empty <code>Queue</code> object. 
		 */
		public function Queue ( type : Class = null )
		{
			this._aStack = new Array( );
			_oType = type;
		}

		/**
		 * Adds the specified element to this queue if it is not already 
		 * present (optional operation). The object is added as the top
		 * of the queue.
		 * <p>
		 * If the current queue object is typed and if the passed-in object's  
		 * type prevents it to be added in this queue, the function throws
		 * an <code>ClassCastException</code>.
		 * </p>
		 * @param 	o element to be added to this queue.
		 * @return 	<code>true</code> if this queue did not already contains	
		 * 			the specified element.
		 * @throws 	<code>ClassCastException</code> — If the object's
		 * 			type prevents it to be added into this queue
		 */
		public function add (o : Object) : Boolean
		{
			if( isValidType( o ) )
			{
				_aStack.push( o );
				return true;
			}
			return false;
		}

		/**
		 * Removes a single instance of the specified element from this
	     * queue, if this queue contains one or more such elements.
	     * Returns <code>true</code> if this queue contained the specified
	     * element (or equivalently, if this collection changed as a result
	     * of the call).
	     * <p>
		 * If the current queue object is typed and if the passed-in object's  
		 * type prevents it to be added in this queue, the function throws
		 * a <code>ClassCastException</code>.
		 * </p> 
	     * @param 	o <code>object</code> to be removed from this <code>Set</code>,
	     * 			  if present.
		 * @return 	<code>true</code> if the <code>Set</code> contained the 
		 * 			specified element.
	     * @throws 	<code>ClassCastException</code> — If the object's type
		 * 			prevents it to be added into this <code>Set</code>
		 */
		public function remove ( o : Object ) : Boolean
		{
			if( isValidType( o ) && contains( o ) )
			{
				_aStack.splice( _aStack.indexOf( o ), 1 );
				return true;
			}
			return false;
		}

		/**
		 * 
		 */
		public function contains ( o : Object ) : Boolean
		{
			return _aStack.indexOf( o ) != -1;
		}

		/**
		 * 
		 */
		public function toArray () : Array
		{
			return _aStack.concat( );
		}

		/**
		 * 
		 */
		public function isEmpty () : Boolean
		{
			return _aStack.length == 0;
		}

		/**
		 * 
		 */
		public function clear () : void
		{
			_aStack = new Array( );
		}

		/**
		 * 
		 */
		public function iterator () : Iterator
		{
			return new QueueIterator( this );
		}

		/**
		 * 
		 * <p>
		 * If the passed-in <code>Collection</code> is null the method throw a
		 * <code>NullPointerException</code> error.
		 * </p><p>
		 * If the passed-in <code>Collection</code> type is different than the current
		 * one the function will throw an <code>IllegalArgumentException</code>.
		 * However, if the type of this queue is <code>null</code>, 
		 * the passed-in <code>Collection</code> can have any type. 
		 * </p>
		 * @param 	c	<code>Collection</code>
		 * @return 	<code>true</code> if this collection changed as a result of the
		 *         	call.
		 * @throws 	<code>NullPointerException</code> — If the passed-in collection
		 * 			is <code>null</code>
		 * @throws 	<code>IllegalArgumentException</code> — If the passed-in collection
		 * 			type is not the same that the current one.
		 */
		public function addAll ( c : Collection ) : Boolean
		{
			if( isValidCollection( c ) )
			{
				var iter : Iterator = c.iterator( );
				var modified : Boolean = false;
				
				while(iter.hasNext( ))
				{
					var o : * = iter.next( );
					if( isValidType( o ) )
					{
						_aStack.push( o );
						modified = true;
					}
				}
				
				return modified;
			}
			return false;
		}

		/**
		 * 
		 * <p>
		 * If the passed-in <code>Collection</code> is null the method throw a
		 * <code>NullPointerException</code> error.
		 * </p><p>
		 * If the passed-in <code>Collection</code> type is different than the current
		 * one the function will throw an <code>IllegalArgumentException</code>.
		 * However, if the type of this queue is <code>null</code>,
		 * the passed-in <code>Collection</code> can have any type. 
		 * </p>
		 * @param 	c	<code>Collection</code>
		 * @return 	<code>true</code> if this collection changed as a result of the
		 *         	call.
		 * @throws 	<code>NullPointerException</code> — If the passed-in collection
		 * 			is <code>null</code>
		 * @throws 	<code>IllegalArgumentException</code> — If the passed-in collection
		 * 			type is not the same that the current one.
		 */
		public function removeAll ( c : Collection ) : Boolean
		{
			if( isValidCollection( c ) )
			{	
				var iter : Iterator = c.iterator( );
				var find : Boolean = false;
				
				while(iter.hasNext( ))
				{
					var o : * = iter.next();
					while( this.contains( o ) )
					{
						find = this.remove( o ) || find;
					}
				}			
				return find;
			}
			return false;
		}

		/**
		 * 
		 * <p>
		 * If the passed-in <code>Collection</code> is null the method throw a
		 * <code>NullPointerException</code> error.
		 * </p><p>
		 * If the passed-in <code>Collection</code> type is different than the current
		 * one the function will throw an <code>IllegalArgumentException</code>.
		 * However, if the type of this queue is <code>null</code>, 
		 * the passed-in <code>Collection</code> can have any type. 
		 * </p>
		 * @param 	c	<code>Collection</code>
		 * @return 	<code>true</code> if this queue contains all of the elements of the
		 * 	       	specified collection.
		 * @throws 	<code>NullPointerException</code> — If the passed-in collection
		 * 			is <code>null</code>
		 * @throws 	<code>IllegalArgumentException</code> — If the passed-in collection
		 * 			type is not the same that the current one.
		 */
		public function containsAll ( c : Collection ) : Boolean
		{
			if( isValidCollection( c ) )
			{
				var iter : Iterator = c.iterator( );
				
				//if one element is not in this collection return false
				//else if all elements is in return true
				while( iter.hasNext( ) )
				{
					if( !contains( iter.next( ) ) )
						return false;
				}
				return true;
			}
			return false;
		}

		/**
		 * 
		 * <p>
		 * If the passed-in <code>Collection</code> is null the method throw a
		 * <code>NullPointerException</code> error.
		 * </p><p>
		 * If the passed-in <code>Collection</code> type is different than the current
		 * one the function will throw an <code>IllegalArgumentException</code>.
		 * However, if the type of this queue is <code>null</code>, 
		 * the passed-in <code>Collection</code> can have any type. 
		 * </p>
		 * @param 	c	<code>Collection</code>
		 * @return 	<code>true</code> if this collection changed as a result of the
		 *         	call.
		 * @throws 	<code>NullPointerException</code> — If the passed-in collection
		 * 			is <code>null</code>
		 * @throws 	<code>IllegalArgumentException</code> — If the passed-in collection
		 * 			type is not the same that the current one.
		 */
		public function retainAll (c : Collection) : Boolean
		{
			if( isValidCollection( c ) )
			{
				var modified : Boolean = false;
				var fin : int = _aStack.length;
				var id : int = 0;
				while(id < fin)
				{
					var obj : * = _aStack[id];
					if(!c.contains( obj ))
					{
						var fromIndex : int = 0;
						while(true)
						{
							fromIndex = _aStack.indexOf( obj, fromIndex );
							if(fromIndex == -1)
							{
								break;
							}
							modified = true;
							_aStack.splice( fromIndex, 1 );
							--fin;
						}
					}else
					{
						++id;
					}
				}
				return modified;
			}
			return false;
		}

		public function size () : uint
		{
			return _aStack.length;
		}

		public function peek () : Object
		{
			return _aStack[0];
		}

		public function poll () : Object
		{
			return _aStack.shift( );
		}

		

		public function isType (o : *) : Boolean
		{
			return o is _oType;
		}

		public function getType () : Class
		{
			return _oType;
		} 
		
		/**
		 * Verify that the passed-in <code>Collection</code> is a valid
		 * collection for use with the <code>addAll</code>, <code>removeAll</code>,
		 * <code>retainAll</code> and <code>containsAll</code> methods. 
		 * <p>
		 * If the passed-in <code>Collection</code> is null the method throw a
		 * <code>NullPointerException</code> error.
		 * </p><p>
		 * If the passed-in <code>Collection</code> type is different than the current
		 * one the function will throw an <code>IllegalArgumentException</code>.
		 * However, if the type of this queue is <code>null</code>,
		 * the passed-in <code>Collection</code> can have any type. 
		 * </p>
		 * @param 	c	<code>Collection</code> to verify
		 * @return 	boolean <code>true</code> if the collection is valid
		 * @throws 	<code>NullPointerException</code> — If the passed-in collection
		 * 			is <code>null</code>
		 * @throws 	<code>IllegalArgumentException</code> — If the passed-in collection
		 * 			type is not the same that the current one.
		 * @see		#addAll()
		 * @see		#removeAll()
		 * @see		#retainAll()
		 * @see		#containsAll()
		 */
		public function isValidCollection ( c : Collection ) : Boolean
		{
			if( c == null ) 
			{
				PixlibDebug.ERROR( "The passed-in collection is null in " + this );
				throw new NullPointerException( "The passed-in collection is null in " + this );
			}
			else if( getType() != null )
			{
				if( c is TypedContainer && ( c as TypedContainer ).getType() != getType() )
				{
					PixlibDebug.ERROR( "The passed-in collection is not of the same type than " + this );
					throw new IllegalArgumentException( "The passed-in collection is not of the same type than " + this );
				}
				else
				{
					return true;
				}
			}
			else
			{
				return true;
			}
		}
		
		/**
		 * Verify that the passed-in object type match the current 
		 * queue element's type.
		 * <p>
		 * In the case that the object's type prevents it to be added
		 * as element for this queue the method will throw
		 * an <code>ClassCastException</code>.
		 * </p> 
		 * @param 	o	<code>Object</code> to verify
		 * @return 	<code>true</code> if the object is elligible for this
		 * 			queue object, either <cod>false</code>.
		 * @throws 	<code>ClassCastException</code> — If the object's type
		 * 			prevents it to be added into this queue
		 */
		public function isValidType ( o : Object ) : Boolean
		{
			if ( getType() != null)
			{
				if ( isType( o ) )
				{
					return true;
				}
				else
				{
					PixlibDebug.ERROR( o + " has a wrong type for " + this );
					throw new ClassCastException( o + " has a wrong type for " + this ) ;
				}
			}
			else
				return true ;
		}
		
		public function toString () : String
		{
			return PixlibStringifier.stringify( this );
		}   
	}
}

import com.bourre.collection.Iterator;
import com.bourre.collection.Queue;

internal class QueueIterator 
	implements Iterator
{
	private var _c : Queue;
	private var _nIndex : int;
	private var _nLastIndex : int;
	private var _a : Array;

	public function QueueIterator ( c : Queue )
	{
		_c = c;
		_nIndex = -1;
		_a = _c.toArray( );
		_nLastIndex = _a.length - 1;
	}

	public function hasNext () : Boolean
	{
		return _nLastIndex > _nIndex;
	}

	public function next () : *
	{
		return _a[ ++_nIndex];
	}

	public function remove () : void
	{
		throw(new Error( "not implemented :p " ));
    	//_c.remove( _a[ _nIndex] ); 
    	//dont work cause the curent elemnt can be remove more than one time
	}
}