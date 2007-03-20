package com.bourre.collection
{
	import flexunit.framework.TestCase;
	import com.bourre.collection.Stack;
	
	public class StackTest extends TestCase
	{
		private var _oS : Stack
		private var _oTs : Stack
		
		public override function setUp() : void
		{
			_oS = new Stack()
			
			_oTs = new Stack(Number)
		}
		
		public function testConstruct() : void
		{
			assertNotNull("create new untyped stack : ", _oS)
			assertNotNull("create new Typed 'Number' stack : ", _oTs)
		}
		
		public function testAdd() : void
		{
			assertTrue(_oS + ".add() failled to add 42 [test 1]", _oS.add(42))
			assertTrue(_oS + ".add() failled to add \"hello\" [test 2]", _oS.add("hello"))
			var obj : Object = {id: "test"}
			assertTrue(_oS + ".add() failled to add " + obj + "[test 3]", _oS.add(obj))
			assertTrue(_oS + ".add() failled to add twiss" + obj + "[test 4]", _oS.add(obj))
			assertTrue(_oS + ".add() failled to add  a stack [test 5]", _oS.add(new Stack()))
			
			var ok : Boolean= true
			try{
				assertTrue(_oTs + ".add() failled to add 4", _oTs.add(4))
			}
			catch(e:Error)
			{
				ok = false
			}
			assertTrue(_oTs + ".add() add 4 trow an error", ok)
			
			ok = false
			try{
				assertTrue(_oTs + ".add() failled to add 4", _oTs.add("so cool typed stack"))
			}
			catch(e:Error)
			{
				ok = true
			}
			assertTrue(_oTs + ".add('so cool typed stack') faill to trow error on bad type adding", ok)
			
		}
		
		public function testContains() : void
		{
			assertFalse(_oS + ".contains() failled on empty Collection", _oS.contains("hello"))
			_oS.add('hello')
			assertFalse(_oS + ".contains() failled with 2", _oS.contains(2))
			assertTrue(_oS + ".contains() failled with string 'hello'",_oS.contains("hello"))
			_oS.add(2)
			assertTrue(_oS + ".contains() failled with number 2",_oS.contains(2))
			
		}
		
		public function testSize() : void
		{
			assertEquals(_oS + ".size() failled with empty Collection", _oS.size(), 0)
			_oS.add('hello')
			assertEquals(_oS + ".size() failled to return 1", _oS.size(), 1)
			_oS.add(1)
			assertEquals(_oS + ".size() failled to return 2", _oS.size(), 2)
		}
		
		public function testRemove() : void
		{
			_oS.add(42)
			_oS.add(42)
			_oS.add(42)
			_oS.add(40)
			var obj : Object = {id: "test"}
			_oS.add(obj)
			_oS.add(obj)
			
			assertTrue(_oS + ".remove() failled to remove " + obj, _oS.remove(obj))
			assertEquals(_oS + ".size() failled to return 4 after remove [1]", _oS.size(), 4)
			assertFalse(_oS + ".remove() failled with" + obj, _oS.remove(obj))
			assertEquals(_oS + ".size() failled to return 4 after remove [2]", _oS.size(), 4)
			assertTrue(_oS + ".remove() failled to remove " + obj, _oS.remove(42))
			assertEquals(_oS + ".size() failled to return 1 after remove", _oS.size(), 1)
		}
		public function testContainAll() : void
		{
			_oS.add(12)
			_oS.add ('bugOrNot')
			_oS.add(10)
			
			var stack2 : Stack = new Stack()
			stack2.add(12)
			stack2.add ('bugOrNot')
			stack2.add ('bugOrYes')
			stack2.add(50)
			
			assertTrue (_oS + ".containsAll() failled to return  true", _oS.containsAll (new Stack()) )
			assertFalse (_oS + ".containsAll() failled to return false [2]", _oS.containsAll (stack2) )
			stack2.add(10)
			assertFalse (_oS + ".containsAll() failled to return false [3]", _oS.containsAll (stack2) )
			
			_oS.add ('bugOrYes')
			_oS.add(50)
			assertTrue (_oS + ".containsAll() failled to return true", _oS.containsAll (stack2) )
		}
		
		public function testRetainAll() : void
		{
			_oS.add(12)
			_oS.add ('bugOrNot')
			_oS.add ('bugOrNot')
			_oS.add ('bugOrYes')
			_oS.add ('bugOrYes')
			_oS.add ('bugOrYes')
			_oS.add ('bugOrBug')
			_oS.add ('bugOrBug')
			_oS.add(50)
			
			var stack2 : Stack = new Stack ()
			stack2.add (12)
			stack2.add ('bugOrBug')
			stack2.add ("hello")
			
			assertTrue(_oS + ".retainAll() failled  to return true with " + stack2, _oS.retainAll(stack2) )
			assertEquals(_oS + ".size() failled to return 3 after retainAll", 3, _oS.size())
			assertFalse(_oS + ".retainAll() failled  to return false with " + stack2, _oS.retainAll(stack2) )
			assertTrue(_oS + ".retainAll() failled  to return true with empty Collection", _oS.retainAll(new Stack()) )
			assertEquals(_oS + ".size() failled to return 0 after retainAll", 0, _oS.size())
		}
		
		public function testAddAll() : void
		{
			var stack2 : Stack = new Stack ()
			stack2.add (12)
			stack2.add ('bugOrBug')
			stack2.add ("hello")
			stack2.add ("hello")
			
			assertTrue(_oS + ".addAll() failled  to return true with " + stack2, _oS.addAll(stack2) )
			assertEquals(_oS + ".size() failled to return 3 after retainAll", 4, _oS.size())
			assertTrue (_oS + ".containsAll() failled to return  true", _oS.containsAll (stack2) )
			assertFalse(_oS + ".addAll() failled  to return False with  an empty Collection", _oS.addAll(new Stack()) )
		}
		
		public function testRemoveAll() : void
		{
			var stack2 : Stack = new Stack ()
			stack2.add (12)
			stack2.add ('bugOrBug')
			stack2.add ("hello")
			stack2.add ("hello")
			
			
			_oS.add(13)
			_oS.add ("hello")
			
			assertTrue(_oS + ".removeAll() failled  to return true [1]", _oS.removeAll(stack2))
			assertEquals(_oS + ".size() failled to return 1 after removeAll", 1, _oS.size())

			assertFalse(_oS + ".removeAll() failled  to return false if no elements to remove", _oS.removeAll(stack2))

			assertFalse(_oS + ".removeAll() failled  to return false with empty stack", _oS.removeAll(new Stack))
			_oS.addAll(stack2)
			_oS.addAll(stack2)
			assertTrue(_oS + ".removeAll() failled  to return true [2]", _oS.removeAll(stack2))
			assertEquals(_oS + ".size() failled to return 1 after removeAll", 1, _oS.size())
			
		}
		
		public function testpush () : void
		{
			assertEquals(_oS + ".push() failled  to return true [1]", 1,  _oS.push(1))
			assertEquals(_oS + ".push() failled  to return true [2]", "cocuou",  _oS.push("cocuou"))
			assertEquals(_oS + ".size() failled to return 2 after push", 2, _oS.size())
		}
		
    
		public function testpeek() : void
		{
			_oS.push(1)
			_oS.push(2)
			_oS.push(3)
			_oS.push(4)
			
			assertEquals(_oS + ".peek() failled to return 4", 4, _oS.peek())
			assertEquals(_oS + ".size() failled to return 4 after peek",4, _oS.size())
			assertEquals(_oS + ".peek() failled to return 4 aftera  peek", 4, _oS.peek())
		}
	    
		public function testpop() : void
		{
			_oS.push(1)
			_oS.push(2)
			_oS.push(3)
			_oS.push(4)
			
			assertEquals(_oS + ".pop() failled to return 4", 4, _oS.pop())
			assertEquals(_oS + ".size() failled to return 3 after peek",3, _oS.size())
			assertEquals(_oS + ".pop() failled to return 3 aftera  peek", 3, _oS.pop())
		}
	    
	
		
		public function testsearch() : void
		{
			_oS.push(1)
			_oS.push(2)
			_oS.push(3)
			_oS.push(4)
			var nb : Number= 10
			_oS.push(nb)
			var obj : Object = {id:4}
			_oS.push(obj)
			assertEquals(_oS + ".search() failled to return 3", 3, _oS.search(4))
			assertEquals(_oS + ".search() failled to return 4",4, _oS.search(3))
			assertEquals(_oS + ".search() failled to return 2",2, _oS.search(nb))
			assertEquals(_oS + ".search() failled to return 1",1, _oS.search(obj))
			assertEquals(_oS + ".search() failled to return 6",6, _oS.search(1))
		}
	}
}