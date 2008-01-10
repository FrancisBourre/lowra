package com.bourre.load
{
	import flexunit.framework.TestCase;
	import flexunit.framework.Test;
	import com.bourre.events.BasicEvent;
	import com.bourre.events.BooleanEvent;

	import flash.geom.Point;	
	
	public class XMLToObjectTest extends TestCase
	{
		private var _o:Object ;
		
		public override function setUp():void
		{
			var list	: Array ;
			var point	: Point ;
			var dvd 	: Object ;
			var obj		: Object ;
			var e		: BasicEvent ;
			var be		: BooleanEvent ;
			var dep		: Object ;
			
			list 		= 	['allo, tu es lÃ  ?', 
							"l'avion", 
							"c'est moi, huhu !", 
							'hahah'] ;
			point 		= new Point(1,2) ;
			dvd			= new Object() ;
			dvd.film 	= "Lost Highway" ;
			obj 		= new Object() ;
			e 			= new BasicEvent("onTest", obj) ;
			be 			= new BooleanEvent("onTest", e, false) ;
			dep 		= new Object() ;
			dep.value 	= 7 ;
			
			_o = new Object() ;
			
			_o.cost 	= 13 ;
			_o.title 	= "pixLib" ;
			_o.liste 	= list ;
			_o.code 	= "<i>testons</i>" ;
			_o.visible 	= true ;
			_o.visible2 = false ;
			_o.blog 	= "http://www.tweenpix.net/blog" ;
			_o.filmA 	= "film0" ;
			_o.filmB 	= "film1" ;
			_o.vecteur 	= point ;
			_o.dvds 	= dvd ;
			_o.event 	= e ;
			_o.noeud 	= "aucun attribut" ;
			_o.mix		= 	['test',
							23, 
							false,
							true];
			_o.deprecated = dep ;
			_o.bevent 	= be ;
		}
		
		public function testNumber():void
		{
			assertEquals("XMLToObject (Number) value isn't equal to the expected value", 
						 13, _o.cost) ;
			assertTrue	("XMLToObject number value isn't typed as number", 
						 _o.cost is Number) ;
		}
		
		public function testString():void
		{
			assertEquals("XMLToObject (String) value isn't equal to the expected value", 
						"pixLib", _o.title) ;
			assertTrue	("XMLToObject string value isn't typed as string",
						_o.title is String) ;
		}
		
		public function testArray():void
		{
			var compare:Boolean = true ;
			var a:Array = _o.liste ;
			var b:Array = [	'allo, tu es lÃ  ?', 
							"l'avion", 
							"c'est moi, huhu !", 
							'hahah'] ;
				
			assertTrue(	"XMLToObject array isn't typed as array", 
						a is Array) ;
									
			assertEquals(	"XMLToObject array doesn't have the expected length", 
							b.length, a.length) ;
			
			for (var i:Number = 0 ; i<a.length ; i++)
			{
				if (a[i] != b[i]) 
				{
					compare = false ;
				}
			}
			assertTrue("XMLToObject (array) an entry of the array isn't equal to expected value", compare) ;
		}
		
		public function testCode():void
		{
			assertEquals("XMLToObject (tag) value isn't equal to expected one", 
						"<i>testons</i>", _o.code) ;
			assertTrue("XMLToObject tag isn't typed as string", 
						_o.code is String) ;
		}
	
		public function testBoolean():void
		{
			assertTrue(	"XMLToObject boolean isn't typed as boolean", 
						_o.visible is Boolean) ;	
			assertTrue(	"XMLToObject (boolean) value isn't equal to expected value", 
						_o.visible) ;
			assertFalse("XMLToObject (boolean) value isn't equal to expected value", 
						_o.visible2) ;	
		}
		
		public function testNameAttribute():void
		{
			assertEquals("XMLToObject (name attribute) value isn't equal to expected value", 
						"http://www.tweenpix.net/blog", _o.blog) ;
			assertTrue("XMLToObject nameAttribute isn't typed as string", 
						_o.blog is String) ;
		}
		
		public function testClonedNodes():void
		{
			var n:Number = 0 ;
			var p:String ;
			for (p in _o)
				if (_o[p] == "film0" || _o[p] == "film1") n++ ;
			assertEquals("XMLToObject (clonedNodes) all nodes not find", 
						 2, n) ;
		}
			
		public function testRecursiveParsing():void
		{
			assertEquals(	"XMLToObject (recursiveParsing) doesn't find the last node", 
							"Lost Highway", _o.dvds.film) ;
		}

		public function testCustomType():void
		{
			var p:Point = new Point(1,2) ;
			assertTrue(	"XMLToObject (customType) doesn't recognize custom type", 
						_o.vecteur is Point) ;
			assertTrue(	"XMLToObject (customType) isn't equal to expected value", 
						p.equals(_o.vecteur)) ;
		}

		public function testClassInstance():void
		{
			assertTrue ("XMLToObject doesn't recognize the class instance", 
						_o.event is BasicEvent) ;
		}
		
		public function testClassWithArgument():void
		{
			assertTrue(	"XMLToObject (classWithArgument) isn't typed as expected",
						_o.bevent is BooleanEvent) ;
			assertFalse( "XMLToObject doesn't find the class argument", 
						_o.bevent.getBoolean()) ;
		}
		
		public function testNodeWithoutAttribute():void
		{
			assertTrue("XMLToObject (nodeWithoutAttribute) isn't typed as expected", 
						_o.noeud is String) ;
			assertEquals(	"XMLToObject value isn't find", 
							"aucun attribut", _o.noeud) ;
		}
		
		public function testMixedArray():void
		{
			var compare:Boolean = true ;
			var a:Array = _o.mix ;
			var b:Array = ['test',
							23, 
							false,
							true];
			assertTrue(	"XMLToObject (mixedArray) array isn't typed as array", 
						_o.mix is Array) ;
						
			for (var i:Number = 0 ; i<a.length ; i++)
			{
				if (a[i] != b[i]) 
				{
					compare = false ;
				}
			}
			assertTrue("XMLToObject (mixedArray) an entry of the array isn't equal to expected value", compare) ;
		}
		
		public function testXml2oAttribute():void
		{
			assertEquals(	"XMLToObject (xml2oAttribute) value isn't equal to expected value",
							7, _o.deprecated.value) ;
		}
	}
}