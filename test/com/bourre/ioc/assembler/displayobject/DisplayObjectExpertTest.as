package com.bourre.ioc.assembler.displayobject
{
	import flexunit.framework.TestCase;
	import flash.display.MovieClip;
	import com.bourre.ioc.bean.BeanFactory;
	import com.bourre.log.PixlibDebug;
	import com.bourre.load.GraphicLoader;
	import flash.display.Sprite;
	import com.bourre.load.GraphicLoaderLocator;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.events.Event;


	public class DisplayObjectExpertTest extends TestCase
	{
		private var _oDOE:DisplayObjectExpert ;
		
		public override function setUp():void
		{
			DisplayObjectExpert.release() ;
			_oDOE = DisplayObjectExpert.getInstance() ;
		}
		
		public function testConstruct() :void
		{
			assertNotNull("DisplayObjectExpert constructor returns null", _oDOE) ;
		}
		
		/*public function testBuildEmptyDisplayObject():void
		{
			var mc:MovieClip = new MovieClip() ;
			_oDOE.setRootTarget(mc) ;
			_oDOE.buildEmptyDisplayObject("idEmpty", DisplayObjectExpert.ROOT_KEY, 1) ;
			_oDOE.load() ;
			
			assertTrue ("DisplayObjectExpert load doesn't load emptyDisplayObject", 
						BeanFactory.getInstance().isRegistered("idEmpty")) ;

			assertEquals(	"DisplayObjectExpert load doesn't build root empty child", 
							"idEmpty", mc.getChildAt(0).name) ;
							
			assertTrue ("DisplayObjectExpert load doesn't cast movieclip", 
						mc.getChildAt(0) is MovieClip) ;
		}*/
		
		public function testBuildGraphicLoader():void
		{
			var mc:MovieClip = new MovieClip() ;
			_oDOE.setRootTarget(mc) ;

			//GraphicLoaderLocator.getInstance().register("graphical", gl) ;
			
			_oDOE.buildEmptyDisplayObject("containerID") ;
			_oDOE.buildGraphicLoader("containerID", 1, true, "photo","photo.jpg") ;
			_oDOE.load() ;
			
			var t:Timer = new Timer(1000, 1) ;
			t.addEventListener(TimerEvent.TIMER_COMPLETE, addAsync(AsyncGraphicLoaderLoaded, 2000,mc)) ;
			t.start() ;
		}
		
		public function AsyncGraphicLoaderLoaded(e : Event, _mc:Object):void
		{
			var mc : Sprite = _mc as Sprite;

			assertTrue ("DisplayObjectExpert load doesn't build container", 
						BeanFactory.getInstance().isRegistered("containerID")) ;
						
			assertTrue ("DisplayObjectExpert load doesn't load photo", 
						BeanFactory.getInstance().isRegistered("photo")) ;
						
			assertEquals(	"DisplayObjectExpert load doesn't build root graphic child", 
							"containerID", mc.getChildAt(0).name) ;
							
			assertTrue ("DisplayObjectExpert load doesn't cast sprite", 
						mc.getChildAt(0) is Sprite) ;
		}
	}
}