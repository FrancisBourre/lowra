package com.bourre.ioc 
{
	import com.bourre.ioc.core.IDExpert;	
	
	import flash.display.MovieClip;
	
	import com.bourre.ioc.assembler.displayobject.DisplayObjectExpert;
	import com.bourre.ioc.bean.BeanFactory;
	import com.bourre.ioc.load.ApplicationLoader;
	import com.bourre.load.GraphicLoaderLocator;
	
	import flexunit.framework.TestCase;		

	public class IOCTest 
		extends TestCase
	{
		protected var _al : ApplicationLoader;
		protected var _xml : XML;
		protected var _bf : BeanFactory;

		public override function setUp():void
		{
			IDExpert.release();
			DisplayObjectExpert.release() ;
			BeanFactory.release();
			GraphicLoaderLocator.release();

			_bf = BeanFactory.getInstance();
			_al = new ApplicationLoader( new MovieClip() );
			
		}

		public function testParseContext() : void
		{
			_xml = 

			<beans>
				<test id="stringTest" value="hello"/>
				<test id="numberTest" type="Number" value="13"/>
				<test id="booleanTest" type="Boolean" value="true"/>
				
				<test id="instanceTest" type="com.bourre.ioc.MockClass"/>
			</beans>;

			_al.parseContext( _xml );
			
			assertNotNull( "ApplicationLoader constructor returns null", _al );
			assertEquals( "build String fails", "hello", _bf.locate( "stringTest" ) );
			assertEquals( "build Number fails", 13, _bf.locate( "numberTest" ) );			assertEquals( "build Boolean fails", true, _bf.locate( "booleanTest" ) );
			assertTrue( "build 'com.bourre.ioc.MockClass' instance fails", _bf.locate( "instanceTest" ) is MockClass );
		}	}}