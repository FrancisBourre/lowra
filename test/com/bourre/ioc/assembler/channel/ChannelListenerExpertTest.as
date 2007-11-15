package com.bourre.ioc.assembler.channel
{
	import flexunit.framework.TestCase;

	public class ChannelListenerExpertTest extends TestCase
	{
		
		private var _oCL:ChannelListenerExpert ;
		
		public override function setUp():void
		{
			_oCL = ChannelListenerExpert.getInstance() ;
		}
		
		public function testConstruct():void
		{
			assertNotNull("ChannelListenerExspert constructor returns null", ChannelListenerExpert.getInstance()) ;
		}
		
		public function testBuildChannelListener():void
		{/*
			var listen:String = "listen" ;
			var att:Object = new Object() ;
			att = {channel:"channel"} ;
			var obj:Object = new Object();
			obj = {attribute:att} ;
			var chan:EventChannel ;
			chan = new EventChannel("channel") ;
			
			BeanFactory.getInstance().register(listen, obj) ;
			_oCL.buildChannelListener(listen, obj) ;
			_oCL.assignAllChannelListeners() ;
		*/
		}
	}
}