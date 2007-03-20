package com.bourre.collection
{
	import com.bourre.collection.Collection;
	import com.bourre.collection.Iterator;
	/**
	 * <code>Stack</code> a Queue(lifo) that can be typed or not
	 * 
	 * @author Romain Flacher
	 * @version 1.0
	 * @example Using a <code>Stack</code>
	 * <listing>var aq : Queue = new Queue ( Number );
	 * aq.add(20)
	 * aq.add("20"); // throw an error because not type of Number
	 * 
	 * </listing>
	 */
	public class Queue implements Collection
	{
		private var _aStack : TypedArray
		/**
		 * Create an empty Stack.
		 */
		public function Queue (type : Class = null)
		{
			this._aStack = new TypedArray(type)
		}
		
		public function contains(o:Object):Boolean
		{
			return _aStack.indexOf(o)!= -1
		}
	
		public function toArray():Array
		{
			return _aStack.toArray()
		}
		
		public function isEmpty():Boolean
		{
			return _aStack.length == 0
		}
		
		public function remove(o:Object):Boolean
		{
			var fromIndex : int = 0
			var find :Boolean = false
			//delete all references to the object in the stack 
			while(true)
			{
				fromIndex =_aStack.indexOf (o, fromIndex)
				if(fromIndex==-1)
				{
					return find
				}
				find = true
				_aStack.splice(fromIndex, 1)
				
			}
			return find
		}
		
		public function clear():void
		{
			_aStack = new TypedArray(_aStack.getType())
		}
		
		public function iterator():Iterator
		{
			return new QueueIterator(this)
		}
		
		public function removeAll(c:Collection):Boolean
		{
			var iter : Iterator = c.iterator()
			var find :Boolean = false
			while(iter.hasNext())
			{
				find=this.remove(iter.next()) || find
			}
			return find
		}
		
		
		public function containsAll(c:Collection):Boolean
		{
			var iter : Iterator = c.iterator()
			
			//if on elements is not in this collection return false
			//else if all elements is in return true
			while(iter.hasNext())
			{
				if(_aStack.indexOf(iter.next())==-1)
					return false
			}
			return true
		}
		
		public function addAll(c:Collection):Boolean
		{
			var iter : Iterator = c.iterator()
			var modified : Boolean = false
			while(iter.hasNext())
			{
				modified = true
				_aStack.push(iter.next())
			}
			return modified
			
		}
		
		public function retainAll(c:Collection):Boolean
		{
			var modified : Boolean = false
			var fin : int = _aStack.length
			var id : int = 0
			 while(id < fin)
			{
				var obj : * = _aStack[id]
				if(!c.contains(obj))
				{
					var fromIndex : int = 0
					while(true)
					{
						fromIndex =_aStack.indexOf (obj, fromIndex)
						if(fromIndex==-1)
						{
							break
						}
						modified = true
						_aStack.splice(fromIndex, 1)
						--fin
						
					}
				}else
				{
					++id
				}
				
					
			}
			return modified;
		}
		
		public function add(o:Object):Boolean
		{
			
			_aStack.push(o)
			return true
		}
		
		public function size():uint
		{
			return _aStack.length
		}
	    
		public function peek() :Object
		{
			return _aStack[0]
		}
	    
		public function poll() : Object
		{
			return _aStack.shift()
		}
	         
	}
}

import com.bourre.collection.Iterator;
import com.bourre.collection.Queue

internal class QueueIterator 
	implements Iterator
{
	private var _c : Queue
	private var _nIndex : int
	private var _nLastIndex : int
	private var _a : Array
	
	public function QueueIterator( c : Queue )
	{
		_c = c;
		_nIndex = -1;
		_a = _c.toArray();
		_nLastIndex = _a.length - 1;
	}
	
	public function hasNext() : Boolean
	{
		return _nLastIndex > _nIndex;
	}
	
 	public function next() : *
 	{
 		return _a[ ++_nIndex];
 	}
 	
    public function remove() : void
    {
    	throw(new Error("not implemented :p "))
    	//_c.remove( _a[ _nIndex] ); 
    	//dont work cause the curent elemnt can be remove more than one time
    }
}