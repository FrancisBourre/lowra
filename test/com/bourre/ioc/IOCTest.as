package com.bourre.ioc 
{
	import flexunit.framework.TestCase;
	
	import com.bourre.events.Broadcaster;
	import com.bourre.ioc.assembler.channel.ChannelListenerExpert;
	import com.bourre.ioc.assembler.constructor.ConstructorExpert;
	import com.bourre.ioc.assembler.method.MethodExpert;
	import com.bourre.ioc.assembler.property.PropertyExpert;
	import com.bourre.ioc.bean.BeanFactory;
	import com.bourre.ioc.load.ApplicationLoader;
	import com.bourre.ioc.load.ApplicationLoaderEvent;
	import com.bourre.load.GraphicLoaderLocator;
	import com.bourre.log.Logger;
	import com.bourre.structures.Dimension;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;	

	public class IOCTest 
		extends TestCase
	{
		private static var _c : Class = MockPlugin;

		protected var _al : ApplicationLoader;
		protected var _xml : XML;
		protected var _bf : BeanFactory;

		public override function setUp():void
		{
			PropertyExpert.release();			ConstructorExpert.release();			ChannelListenerExpert.release();			MethodExpert.release();

			BeanFactory.release();
			GraphicLoaderLocator.release();
			
			_bf = BeanFactory.getInstance();
			_al = new ApplicationLoader( new MovieClip() );
			
			_xml = 

			<beans>
				<root id="root">
					<test id="container" type="flash.display.MovieClip">
						<test id="sprite" type="flash.display.Sprite"/>
						<test id="text" type="flash.text.TextField"/>
					</test>
				</root>
				
				<test id="mockPlugin" type="com.bourre.ioc.MockPlugin">
					<argument ref="stringTest"/>
					<argument ref="container"/>
				</test>

				<test id="obj" type="Object">
					<property name="p1" value="hello p1"/>
					<property name="p2" ref="stringTest"/>
					<property name="p3" ref="numberTest"/>
					<property name="p4" ref="booleanTest"/>
					<property name="p5" ref="instanceTest"/>
					<property name="p6" ref="objChild"/>
				</test>
				
				<test id="objChild" type="Object">
					<property name="prop" value="world"/>
				</test>

				<test id="collection" type="Array">
					<argument ref="stringTest"/>
					<argument ref="numberTest"/>
					<argument ref="booleanTest"/>
					<argument ref="instanceTest"/>
				</test>

				<test id="stringTest" value="hello"/>
				<test id="numberTest" type="Number" value="13"/>
				<test id="booleanTest" type="Boolean" value="true"/>

				<test id="instanceTest" type="com.bourre.ioc.MockClass"/>
				<test id="logger" type="com.bourre.log.Logger" singleton-access="getInstance"/>
				<test id="broadcaster" type="com.bourre.events.ApplicationBroadcaster" factory="getChannelDispatcher" singleton-access="getInstance"/>

				<test id="dimensionClass" type="Class">
					<argument value="com.bourre.structures.Dimension"/>
				</test>
			</beans>;
		}
		
		public function testOnApplicationObjectsBuilt() : void
		{
			_al.addEventListener( ApplicationLoaderEvent.onApplicationObjectsBuiltEVENT, addAsync( onObjectsBuilt, 5000 ) );
			_al.processParsing( _xml );
		}
		
		public function onObjectsBuilt( e : Event ) : void
		{
			assertTrue( "ApplicationLoaderEvent.onApplicationObjectsBuiltEVENT fails", true );
	
			assertNotNull( "ApplicationLoader constructor returns null", _al );
			assertEquals( "build Sprite fails", true, _bf.locate( "container" ) is MovieClip );
			assertEquals( "build Sprite fails", true, _bf.locate( "sprite" ) is Sprite );
			assertEquals( "build Sprite fails", true, _bf.locate( "text" ) is TextField );
			assertEquals( "build String fails", "hello", _bf.locate( "stringTest" ) );
			assertEquals( "build Number fails", 13, _bf.locate( "numberTest" ) );			assertEquals( "build Boolean fails", true, _bf.locate( "booleanTest" ) );
			assertTrue( "build 'com.bourre.ioc.MockClass' instance fails", _bf.locate( "instanceTest" ) is MockClass );
			assertTrue( "build 'com.bourre.log.Logger.getInstance()' instance fails", _bf.locate( "logger" ) is Logger );
			assertTrue( "build 'com.bourre.events.ApplicationBroadcaster.getInstance().getChannelDispatcher()' instance fails", _bf.locate( "broadcaster" ) is Broadcaster );
		
			var a : Array = _bf.locate( "collection" ) as Array;
			assertEquals( "collection[ 0 ] as String ref fails", "hello", a[ 0 ] );
			assertEquals( "collection[ 1 ] as Number ref fails", 13, a[ 1 ] );
			assertEquals( "collection[ 2 ] as Boolean ref fails", true, a[ 2 ] );
			assertTrue( "collection[ 3 ] as 'com.bourre.ioc.MockClass' instance ref fails", a[ 3 ] );
			
			var o : Object = _bf.locate( "obj" ) as Object;
			assertEquals( "obj.p1 as String property fails", "hello p1", o.p1 );
			assertEquals( "obj.p2 as String ref fails", "hello", o.p2 );
			assertEquals( "obj.p3 as Number ref fails", 13, o.p3 );
			assertEquals( "obj.p4 as Boolean ref fails", true, o.p4 );
			assertTrue( "obj.p5 as 'com.bourre.ioc.MockClass' instance ref fails", o.p5 is MockClass );			assertEquals( "obj.p6 as 'obj.objChild.prop' ref fails", "world", o.p6.prop );
			assertEquals( "build 'com.bourre.structures.Dimension' class fails", _bf.locate( "dimensionClass" ), Dimension );

			assertTrue( "build 'com.bourre.ioc.MockPlugin' instance fails", _bf.locate( "mockPlugin" ) is MockPlugin );		}
		
//		public function testOnApplicationInit() : void
//		{
//			_al.addEventListener( ApplicationLoaderEvent.onApplicationInitEVENT, addAsync( onInit, 5000 ) );
//			_al.parseContext( _xml );
//		}
//		
//		public function onInit( e : Event ) : void
//		{
//			assertTrue( "ApplicationLoaderEvent.onApplicationInitEVENT fails", true );
//		}	}}