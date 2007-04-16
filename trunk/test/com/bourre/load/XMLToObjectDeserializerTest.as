package com.bourre.load
{
	import flexunit.framework.TestCase;
	import com.bourre.log.PixlibDebug 
	import com.bourre.events.BasicEvent;
	import flash.geom.Point;
	;

	public class XMLToObjectDeserializerTest extends TestCase
	{
		private var xml:XML ;
		private var completeXml:XML ;
		private var oXOD:XMLToObjectDeserializer ;
		
		
		public override function setUp():void
		{
			completeXml = 
			<fr>
				<url type="string" name="blog">
					blabla
				</url>
				<film type="string">
					film0
				</film>
				<film type="string">
					film1
				</film>
				<dvds>
					<film type="string">
						Lost Highway
					</film>
				</dvds>
			</fr> ;
			
			oXOD = new XMLToObjectDeserializer() ;
		}
		
		
		public function testConstruct() : void
		{
			assertNotNull("XMLToObjectDeserializer constructor returns null", oXOD) ;
		}
		
		public function testDeserializeString():void
		{
			xml = 	<fr>
						<url type="string">
							blabla
						</url>
					</fr> ;

			var obj:Object ;
			obj = oXOD.deserialize({}, xml);

			assertNotNull("XMLToObjectDeserializer deserialize return null object -String xml-", obj) ;
			assertNotNull("XMLToObjectDeserializer deserialize result doesn't contain expected property -String xml-", obj.url) ;
			assertTrue("XMLToObjectDeserializer deserialize doesn't return a string", obj.url.value is String) ;
			assertEquals("XMLToObjectDeserializer deserialize doesn't return expected value -String xml-", "blabla", obj.url.value) ;
		}
		
		public function testDeserializeNumber() : void
		{
			xml = 	<fr>
						<nb type="number">
							15
						</nb>
					</fr> ;
			
			var obj:Object ;
			obj = oXOD.deserialize({}, xml) ;
			
			assertNotNull("XMLToObjectDeserializer deserialize return null object -Number xml-", obj) ;
			assertNotNull("XMLToObjectDeserializer deserialize result doesn't contain expected property -Number xml-", obj.nb) ;
			assertTrue("XMLToObjectDeserializer deserialize doesn't return a number", obj.nb.value is Number) ;
			assertEquals("XMLToObjectDeserializer deserialize doesn't return expected value", 15, obj.nb.value) ;
		}
		
		public function testDeserializeArray():void
		{
			xml = 	<fr>
						<liste type="array">
							'allo, tu es là ?', 15, "c'est moi, huhu !", 'hahah'
						</liste>
					</fr> ;
					
			var obj:Object ;
			obj = oXOD.deserialize({}, xml) ;
			
			assertNotNull("XMLToObjectDeserializer deserialize return null object -array xml-", obj) ;
			assertNotNull("XMLToObjectDeserializer deserialize result doesn't contain expected property -array xml-", obj.liste) ;
			assertTrue("XMLToObjectDeserializer deserialize doesn't return an array", obj.liste.value is Array) ;
			assertEquals("XMLToObjectDeserializer deserialize doesn't return expected value-array xml-", "c'est moi, huhu !", obj.liste.value[2]) ;
			assertEquals("XMLToObjectDeserializer deserialize doesn't return expected value -array xml-", obj.liste.value[1], 15) ;
			assertNull("XMLToObjectDeserializer getArray returns more values than expected", obj.liste.value[obj.liste.value.length]) ;

		}
		
		public function testDeserializeBoolean():void
		{
			xml = 	<fr>
						<bool type="boolean">
							true
						</bool>
						<bool2 type="boolean">
							false
						</bool2>
						<bool3 type="boolean">
							1
						</bool3>
						<bool4 type="boolean">
							0
						</bool4>
						<bool5 type="boolean">
							2
						</bool5>
					</fr> ;
					
			var obj:Object = new Object() ;
			obj = oXOD.deserialize({}, xml) ;
			
			assertNotNull("XMLToObjectDeserializer deserialize return null object -boolean xml-", obj) ;
			assertNotNull("XMLToObjectDeserializer deserialize result doesn't contain expected property -boolean xml-", obj.bool) ;
			assertNotNull("XMLToObjectDeserializer deserialize result doesn't contain expected property -boolean xml-", obj.bool2) ;
			assertNotNull("XMLToObjectDeserializer deserialize result doesn't contain expected property -boolean xml-", obj.bool3) ;
			assertNotNull("XMLToObjectDeserializer deserialize result doesn't contain expected property -boolean xml-", obj.bool4) ;
			assertNotNull("XMLToObjectDeserializer deserialize result doesn't contain expected property -boolean xml-", obj.bool5) ;
			
			assertTrue("XMLToObjectDeserializer deserialize doesn't return an boolean", obj.bool.value is Boolean) ;
			assertTrue("XMLToObjectDeserializer deserialize doesn't return expected value -boolean xml-", obj.bool.value) ;
			assertFalse("XMLToObjectDeserializer deserialize doesn't return expected value -boolean xml-", obj.bool2.value) ;
			assertTrue("XMLToObjectDeserializer deserialize doesn't return expected value -boolean xml-", obj.bool3.value) ;
			assertFalse("XMLToObjectDeserializer deserialize doesn't return expected value -boolean xml-", obj.bool4.value) ;
			assertTrue("XMLToObjectDeserializer deserialize boolean return boolean when node isn't boolean", obj.bool5.value) ;
		}
		
		public function testDeserializeClass():void
		{
			xml = 	<fr>
						<event type="class">
						"com.bourre.events.BasicEvent", "onTest"
						</event>
					</fr> ;
					
			var obj:Object = new Object() ;
			
			var b:Boolean = true ; 
			try{
				obj = oXOD.deserialize({}, xml) ;
			}
			catch(e:Error)
			{
				b = false ; 
			}
			assertTrue("XMLToObjectDeserializer deserialize throw error with class type", b) ;
			
			assertNotNull("XMLToObjectDeserializer deserialize return null object -class xml-", obj) ;
			assertNotNull("XMLToObjectDeserializer deserialize result doesn't contain expected property -class xml-", obj.event) ;
			
			assertTrue("XMLToObjectDeserializer deserialize doesn't construct class instance", obj.event.value is BasicEvent) ;
			assertEquals("XMLToObjectDeserializer deserialize doesn't construct class instance", obj.event.value.type, "onTest") ;
		}
		
		public function testDeserializePoint():void
		{
			xml = 	<fr>
						<p type="point">
							5,6
						</p>
					</fr> ;
					
			var obj:Object = new Object() ;
			var b:Boolean = true ;
			try {
				obj = oXOD.deserialize({}, xml) ;
			}
			catch (e:Error)
			{
				b = false ;
			}
			
			assertTrue("XMLToObjectDeserializer getPoint missing a coordinate", b) ;
			
			assertNotNull("XMLToObjectDeserializer deserialize return null object  -point xml-", obj) ;
			assertNotNull("XMLToObjectDeserializer deserialize result doesn't contain expected property -point xml-", obj.p) ;
			assertTrue("XMLToObjectDeserializer deserialize doesn't return a point", obj.p.value is Point) ;
			
			assertEquals("XMLToObjectDerializer deserialize doesn't return expected value for Point-1-", 5, obj.p.value.x) ;
			assertEquals("XMLToObjectDerializer deserialize doesn't return expected value for Point-2-", 6, obj.p.value.y) ;
			
		}
		
		public function testDeserializeNode():void
		{
			xml = 	<fr>
						<dvds>
							<film type="string">
								Lost Highway
							</film>
						</dvds>
					</fr> ;
			
			var obj:Object = new Object() ;
			obj = oXOD.deserialize({}, xml) ;

			
			assertNotNull("XMLToObjectDeserializer deserialize return null object  -node xml-", obj) ;
			assertNotNull("XMLToObjectDeserializer deserialize result doesn't contain expected property -node xml 1-", obj.dvds) ;
			assertNotNull("XMLToObjectDeserializer deserialize result doesn't contain expected property -node xml- 2", obj.dvds.film) ;
			
			assertTrue ("XMLToObjectDeserializer deserialize doesn't return a string which is in childnode", obj.dvds.film.value is String) ;
			
			assertEquals("XMLToObjectDerializer deserialize doesn't return expected value -node xml-", obj.dvds.film.value, "Lost Highway") ;
		}
		
		public function testComplexNode():void
		{
			xml = 	<fr>
						<title type="string">blabla</title>
						<dvds>
							<film type="string">Fight Club</film>
						</dvds>
						<title type="string">pouet</title>
						<dvds>
							<title type="string">hopla</title>
						</dvds>
						<divx>
							<film type="string">Au nom de la rose</film>
							<film type="string">Dracula</film>
							<liste type="array">123,"eryna", 456</liste>
						</divx>
						<dvds>
							<film type="string">tralala</film>
						</dvds>
					</fr> ;
			
			var obj:Object = new Object() ;
			obj = oXOD.deserialize({}, xml) ;
			
			assertNotNull("XMLToObjectDeserializer deserialize return null object -complex node-", obj) ;
		
			//double entry [title]
			assertNotNull("XMLToObjectDeserializer deserializeNode doesn't recognize double entry", obj.title[1].value) ;
			assertEquals("XMLToObjectDeserializer deserializeNode doesn't return expected value with double entry", "pouet", obj.title[1].value) ;
			
			//triple complex node [dvds]
			assertNotNull("XMLToObjectDeserializer deserializeNode doesn't recognize triple complex node", obj.dvds[1].title) ;
			assertNotNull("XMLToObjectDeserializer deserializeNode doesn't recognize triple complex node", obj.dvds[0].film) ;
			assertEquals("XMLToObjectDeserializer deserializeNode doesn't return expected value with triple complex node", "hopla", obj.dvds[1].title.value) ;
			assertEquals("XMLToObjectDeserializer deserializeNode doesn't return expected value with triple complex node", "Fight Club", obj.dvds[0].film.value) ;
			assertEquals("XMLToObjectDeserializer deserializeNode doesn't return expected value with triple complex node", "tralala", obj.dvds[2].film.value) ;
			
			//double entry in complex node [divx]
			assertNotNull("XMLToObjectDeserializer deserializeNode doesn't recognize double entry in complex node", obj.divx.film[0]) ;
			assertEquals("XMLToObjectDeserializer deserializeNode doesn't return expected value with double entry in complex node", "Au nom de la rose", obj.divx.film[0].value) ;
			assertEquals("XMLToObjectDeserializer deserializeNode doesn't return expected value with double entry in complex node", "Dracula", obj.divx.film[1].value) ;		
			assertEquals("XMLToObjectDeserializer deserializeNode doesn't return expected value with double entry in complex node", "123", obj.divx.liste.value[0]) ;	
			assertEquals("XMLToObjectDeserializer deserializeNode doesn't return expected value with double entry in complex node", "eryna", obj.divx.liste.value[1]) ;
			
		}
	}
}