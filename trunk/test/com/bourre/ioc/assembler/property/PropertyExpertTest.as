package com.bourre.ioc.assembler.property
{
	import flexunit.framework.TestCase;
	import com.bourre.ioc.bean.BeanFactory;

	public class PropertyExpertTest extends TestCase
	{
		private var _oPE:PropertyExpert ;
		private var _oObj:Object ;
		private var _oProp:Property ;
		private var _aProp:Array ;
		
		public override function setUp():void
		{
			_oObj = {_x:250} ;
			
			
			_oProp = new Property("button","_x", "250", "Number") ;
			_aProp = new Array() ;
			_aProp.push(_oProp) ;
			
			BeanFactory.getInstance().register("button", _oObj) ;
			
			_oPE = PropertyExpert.getInstance() ;
		}
		
		public function testConstruct() :void
		{
			assertNotNull("PropertyExpert constructor returns null", _oPE) ;
		}
		
		public function testDeserializeArguments():void
		{
			assertNotNull("PropertyExpert.deserializeArguments returns null", _oPE.deserializeArguments(_aProp)) ;
		}
		
		public function testPropertiesSetters():void
		{

		}
		
		public function testTypeGetter():void
		{
			
		}
		
		public function testPropertyVOGetter() : void
		{
			
		}
		
		public function testBuildProperty() : void
		{
			
		}
		
		public function testListeners():void
		{
			
		}
		
		public function testEventListeners():void
		{
			
		}
		
		public function testRegisterBean():void
		{
			
		}
	}
}