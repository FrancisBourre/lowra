package com.bourre.collection
{
	import flexunit.framework.TestCase;	

	public class SetTest extends TestCase
	{
		
		private var _oTypedSet:Set; 
		private var _oSet:Set ;
		
		
		public override function setUp():void
		{
			_oTypedSet = new Set(String) ;
			_oSet = new Set () ;
		}
		
		public function testConstruct():void
		{
			assertNotNull("Set constructor with type argument returns null", _oTypedSet) ;
			assertNotNull("Set constructor with no argument returns null", _oSet) ;
		}
		
		public function testIsValid():void
		{
			var bool:Boolean = true ;
			
			var typedSet:Set ;
			typedSet = new Set(String) ;

			typedSet.add("321") ;
			
			var testset:Set ;
			testset = new Set() ;
			testset.add(123) ;		
			
			try {
				typedSet.isValidIndex(0) ;
			}
			catch (e:Error)
			{
				bool = false;
			}
			assertTrue("Set.isValidIndex doesn't throw IndexOutOfBoundsException", bool) ; 
			
			
			bool = true ;
			try {
				typedSet.isValidType(123) ;
			}
			catch(e:Error)
			{
				bool = false ;
			}
			assertFalse("Set.isValidType doesn't throw error with wrong type", bool) ;
			
			assertFalse("Set.isValidObject doesn't catch an existing element", typedSet.isValidObject("321")) ; //ok

			bool = true ;
			try {
				typedSet.isValidCollection(testset) ;
			}
			catch (e:Error)
			{
				bool = false ;
			}
			
			assertFalse("Set.isValidCollection doesn't throw IllegalArgumentException with wrong typed collection", 
						bool) ;
		}
		
		public function testAdd():void
		{
			var bool:Boolean = true ;
			var typedSet:Set ;
			typedSet = new Set(String) ;
			var _set:Set ;
			_set = new Set() ;
			
			//typed set			
			assertTrue("Set.isValidObject catch a non-existing element ", typedSet.isValidObject("123"));
			
			assertTrue("Set.add (typed) failed",typedSet.add("123")) ;
			assertFalse("Set.add (typed) doesn't failed with duplicate element", typedSet.add("123")) ;
			try {
				typedSet.add(123) ;
			}
			catch (e:Error)
			{
				bool = false ;
			}
			assertFalse("Set.add doesn't throw IllegalArgumentException when wrong type", bool);
			
			//no typed set
			assertTrue("Set.add failed with string typed element", _set.add("123")) ;
			assertTrue("Set.add failed with number typed element", _set.add(123)) ;

		}
		
		public function testAddAt():void
		{
			var typedSet:Set ;
			typedSet = new Set(Number) ;
			typedSet.add(123) ;
			typedSet.add(789) ;
			
			typedSet.addAt(1, 456) ;
			assertEquals("Set.addAt don't add the element at the right index", 1, typedSet.indexOf(456)) ;
			assertEquals("Set.addAt don't add the element at the right index", 2, typedSet.indexOf(789)) ;
			
			typedSet.addAt( typedSet.size(), 1610 ) ;
			
			assertEquals("Set.addAt don't add the element at the end", 3, typedSet.indexOf(1610)) ;
			
			var b : Boolean = false;
			try
			{
				typedSet.addAt( typedSet.size() + 1, 1610 ) ;
			}
			catch( e : Error )
			{
				b = true;
			}
			assertTrue("Set.addAt don't failed when adding an element outside of the range",b);
		}

		public function testSize() : void
		{
			var typedSet:Set ;
			typedSet = new Set(String) ;
			
			typedSet.add("123") ;
			typedSet.add("456") ;
			
			assertEquals("Set.size doesn't return the right length", 2, typedSet.size());
		}
		
		public function testAddAll():void
		{
			var bool:Boolean = true ;
			var testSet:Set ;
			testSet = new Set() ;
			testSet.add("lalala") ;
			testSet.add(new Array()) ;
			testSet.add(456) ;
			
			var typedSet:Set ;
			typedSet = new Set(String) ;
			
			var _set:Set ;
			_set = new Set() ;
			_set.add( 456 );
		
			assertFalse("Set.addAll doesn't failed with adding an empty collection", _set.addAll( new Set())) ;
			
			try {
				typedSet.addAll(testSet) ;
			}
			catch (e:Error)
			{
				bool = false ;
			}
			assertFalse("Set.addAll (typed) doesn't failed with adding an untyped set",bool) ;
			
			bool = true ;
			try {
				_set.addAll(testSet) ;
			}
			catch (e:Error)
			{
				bool=false ;
			}
			assertTrue ("Set.addAll failed when adding an untyped set in untyped set", bool) ;
			
			bool = true ;
			try 
			{
				_set.addAll(typedSet) ;
			}
			catch (e:Error)
			{
				bool=false ;
			}
			assertTrue ("Set.addAll failed when adding a typed set in untyped set", bool) ;
		}
		
		public function testGetSet():void
		{
			var typedSet:Set ;
			typedSet = new Set(String) ;
			typedSet.add("123") ;
			typedSet.add("456") ;
			
			assertEquals("Set.get doesn't return the expected value", "123", typedSet.get(0));
			typedSet.set(0,"789") ;
			assertEquals("Set.set doesn't set the expected value", "789", typedSet.get(0)) ;
		}
		
		public function testClear():void
		{
			var _set:Set ;
			_set = new Set() ;
			_set.add(123) ;
			
			_set.clear() ;
			assertEquals("Set.clear doesn't clear the Set", 0,_set.size()) ;
		}
		
		public function testContains():void
		{
			var bool:Boolean = true ;
			var typedSet:Set ;
			typedSet = new Set(String) ;
			typedSet.add("456") ;
			assertTrue("Set.contains doesn't find the value", typedSet.contains("456")) ;
			assertFalse("Set.contains find an unknown value",typedSet.contains("123"));
			try {
				typedSet.contains(123);	
			}
			catch (e:Error)
			{
				bool = false ;
			}
			assertFalse("Set.contains doesn't detect wrong type", bool) ;
			
		}
		
		public function testContainsAll():void
		{
			var bool:Boolean = true ;
			var typedSet:Set ;
			typedSet = new Set(String) ;
			typedSet.add ("123") ;
			typedSet.add("lalala") ;
			typedSet.add("456") ;
			
			var testSet:Set ;
			testSet = new Set(String) ;
			testSet.add("123") ;
			testSet.add("lalala") ;
			
			var testSet2:Set ;
			testSet2 = new Set() ;
			testSet2.add(123) ;
			testSet2.add("123") ;
			
			var testSet3:Set ;
			testSet3 = new Set(String) ;
			testSet3.add("46") ;
			testSet3.add("123") ;
			
			typedSet.add("lalala");
			assertTrue("Set.containsAll doesn't find all elements", 
						typedSet.containsAll(testSet));
						
			try {			
				typedSet.containsAll(testSet2) ;
			}
			catch (e:Error)
			{
				bool = false ;
			}
			assertFalse ("Set.containsAll doesn't failed with testing wrong typed element", bool) ;
			assertFalse("Set.containsAll doesn't failed with wrong values", 
						typedSet.containsAll(testSet3)) ;
		}
		
		public function testEquals():void
		{
			var typedSet:Set ;
			typedSet = new Set(String) ;
			typedSet.add("123") ;
			typedSet.add("lalala") ;
			
			var testSet:Set ;
			testSet = new Set(String) ;
			testSet.add("123") ;
			testSet.add("lalala") ;
			
			assertTrue("Set.equals doesn't return true", typedSet.equals(testSet)) ;
			
			testSet.add("456") ;
			assertFalse("Set.equals doesn't matter with the number of values", typedSet.equals(testSet)) ;
		}
		
		public function testIsEmpty():void
		{
			var typedSet:Set ;
			typedSet = new Set(String) ;
			assertTrue("Set.isEmpty returns true as Set isn't empty", typedSet.isEmpty()) ;
		}
		
		public function testRemove():void
		{
			var typedSet:Set ;
			typedSet = new Set(String) ;
			typedSet.add("lalala") ;
			typedSet.add("hop") ;
			
			assertTrue("Set.remove returns false", typedSet.remove("lalala")) ;
			assertEquals("Set.remove element still in the set ", -1, typedSet.indexOf("lalala")) ;

		}
		
		public function testRemoveAll():void
		{
			var typedSet:Set ;
			typedSet = new Set(String) ;
			typedSet.add("789") ;
			typedSet.add("456") ;
			typedSet.add("321") ;
			
			var testset:Set ;
			testset = new Set(String) ;
			testset.add("789") ;
			testset.add("456") ;
			testset.add("321") ;
			
			var nb:int = typedSet.size() ;
			nb = nb-3 ;
			assertTrue("Set.removeAll returns false", typedSet.removeAll(testset)) ;
			assertFalse("Set.removeAll doesn't remove all the elements",typedSet.containsAll(testset)) ;
			assertEquals("Set.removeAll doesn't remove all the elements", nb, typedSet.size()) ;
		}
		
		public function testRetainAll():void
		{
			var typedSet:Set ;
			typedSet = new Set(String) ;
			typedSet.add("456") ;
			typedSet.add("321") ;
			typedSet.add("789") ;
			typedSet.add("123") ;
			typedSet.add("654") ;
			
			var testset:Set ;
			testset = new Set(String) ;
			testset.add("789") ;
			testset.add("456") ;
			testset.add("321") ;
			
			assertTrue("set.retainAll returns false", typedSet.retainAll(testset)) ;
			assertEquals("Set.retainAll doesn't remove elements not contained in specified collection", 
						testset.size(), typedSet.size()) ;
			
		}
		
		public function testToArray():void
		{
			var typedSet:Set ;
			typedSet = new Set(String) ;
			typedSet.add("789") ;
			typedSet.add("456") ;
			typedSet.add("321") ;
			
			var tab:Array ;
			tab = new Array () ;
			tab = typedSet.toArray() ;
			tab[0] = "7894" ;
			assertTrue("Set.toArray doesn't return an array", typedSet.toArray() is Array) ;
			
			var nb:int = 0 ; 
			var ok:Boolean = true ;
			for (var i:Object in _oTypedSet)
			{
				if (typedSet[i] != tab[nb])
				{
					ok = false ;
					break ;
				}
				nb++ ;
			}
			assertTrue("Set.toArray returned contents isn't equal to Set contents", ok) ;
		}
		
	}
}