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
		private var _b:Boolean ;
		
		public override function setUp():void
		{
			DisplayObjectExpert.release() ;
			BeanFactory.release() ;
			_b = false ;
			_oDOE = DisplayObjectExpert.getInstance() ;
		}
		
		public function testConstruct() :void
		{
			assertNotNull("DisplayObjectExpert constructor returns null", _oDOE) ;
		}
		
		public function testSetRootTarget():void
		{
			var mc:MovieClip = new MovieClip() ;
			_oDOE.setRootTarget(mc) ;
			
			var clip:MovieClip = new MovieClip () ;
			try
			{
				_oDOE.setRootTarget(clip) ;
			}
			catch (e:Error)
			{
				_b = true ;
			}
			assertTrue("DisplayObjectExpert.setRootTarget doesn't throw error when a root is already set",
						_b) ;
		}
		
		public function testBuildEmptyDisplayObject():void
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
		}
		
		public function testBuildGraphicLoader():void
		{
			var mc:MovieClip = new MovieClip() ;
			_oDOE.setRootTarget(mc) ;

			//GraphicLoaderLocator.getInstance().register("graphical", gl) ;
			
			_oDOE.buildEmptyDisplayObject("containerID") ;
			_oDOE.buildGraphicLoader("photo", "containerID", 1, true, "photo.jpg") ;
			_oDOE.load() ;
			
			var t:Timer = new Timer(1000, 1) ;
			t.addEventListener(TimerEvent.TIMER_COMPLETE, addAsync(AsyncGraphicLoaderLoaded, 2000,mc)) ;
			t.start() ;
		}
		
		public function AsyncGraphicLoaderLoaded(e : Event, _mc:Object):void
		{
			var mc : Sprite = _mc as Sprite;

			assertTrue (	"DisplayObjectExpert load doesn't build container", 
							BeanFactory.getInstance().isRegistered("containerID")) ;
						
			assertTrue (	"DisplayObjectExpert load doesn't load photo", 
							BeanFactory.getInstance().isRegistered("photo")) ;
						
			assertEquals(	"DisplayObjectExpert load doesn't build root graphic child", 
							"containerID", mc.getChildAt(0).name) ;
							
			assertTrue (	"DisplayObjectExpert load doesn't cast sprite", 
							mc.getChildAt(0) is Sprite) ;
		}
		
		public function testLoad():void
		{
			//when load queues are empty
			_b = true ;
			_oDOE.load() ;
			var t:Timer = new Timer(200, 1) ;
			t.addEventListener(TimerEvent.TIMER_COMPLETE, addAsync(AsyncEmptyLoadingQueue, 300)) ;
			t.start() ;
		}
		public function AsyncEmptyLoadingQueue(e:Event):void
		{
			assertTrue("DisplayObjectExpert.load doesn't call callback method when queue is empty", 
						_b) ;
		}
		
		public function testDisplayObjectsTreatment():void
		{
			//creation of the root
			var root:MovieClip = new MovieClip() ;
			_oDOE.setRootTarget(root) ;
			
			//creation of the empty clips
			_oDOE.buildEmptyDisplayObject("clip1",	DisplayObjectExpert.ROOT_KEY) ;
			_oDOE.buildEmptyDisplayObject("clip2",	DisplayObjectExpert.ROOT_KEY) ;
			_oDOE.buildEmptyDisplayObject("clip11",	"clip1") ;
			_oDOE.buildEmptyDisplayObject("clip12",	"clip1") ;
			_oDOE.buildEmptyDisplayObject("clip111","clip11") ;
			_oDOE.buildEmptyDisplayObject("clip121","clip12") ;
			_oDOE.buildEmptyDisplayObject("clip122","clip12",0,"Sprite") ;
			
			//photos loaded in two clips (=> bitmap objects)
			_oDOE.buildGraphicLoader("photo1", "clip111", 1, true, "photo.jpg") ;
			_oDOE.buildGraphicLoader("photo2", "clip122", 1, true, "photo.jpg") ;
			
			_oDOE.load() ;
			
			var t:Timer = new Timer(1000, 1) ;
			t.addEventListener(TimerEvent.TIMER_COMPLETE, addAsync(AsyncHierarchyLoaded, 2000,root)) ;
			t.start() ;
		}
		public function AsyncHierarchyLoaded(e:Event, mc:Object):void
		{
			var root:MovieClip = mc as MovieClip ;
			var child:Sprite ;
			
			assertEquals("DisplayObjectExpert.displayObjectsTreatment wrong number of children on root clip", 
						2, root.numChildren) ;
			
			child = root.getChildByName("clip1") as MovieClip ;
			assertEquals("DisplayObjectExpert.displayObjectsTreatment wrong number of children on clip1 clip", 
						2, child.numChildren) ;
						
			child = root.getChildByName("clip2") as Sprite ;
			assertEquals("DisplayObjectExpert.displayObjectsTreatment wrong number of children on clip2 clip", 
						0, child.numChildren) ;
			assertTrue("DisplayObjectExpert.displayObjectsTreatment wrong type on clip2",
						root.getChildByName("clip2") is Sprite) ;
			
			child = (root.getChildByName("clip1") as MovieClip).getChildByName("clip11") as MovieClip ;
			assertEquals("DisplayObjectExpert.displayObjectsTreatment wrong number of children on clip11 clip", 
						1, child.numChildren) ;
						
			child = (root.getChildByName("clip1") as MovieClip).getChildByName("clip12") as MovieClip ;
			assertEquals("DisplayObjectExpert.displayObjectsTreatment wrong number of children on clip12 clip", 
						2, child.numChildren) ;
			
			child = ((root.getChildByName("clip1") as MovieClip).getChildByName("clip11") as MovieClip).getChildByName("clip111") as MovieClip ;
			assertEquals("DisplayObjectExpert.displayObjectsTreatment wrong number of children on clip111 clip", 
						1, child.numChildren) ;
			
			child = ((root.getChildByName("clip1") as MovieClip).getChildByName("clip12") as MovieClip).getChildByName("clip121") as MovieClip ;
			assertEquals("DisplayObjectExpert.displayObjectsTreatment wrong number of children on clip121 clip", 
						0, child.numChildren) ;
						
			child = ((root.getChildByName("clip1") as MovieClip).getChildByName("clip12") as MovieClip).getChildByName("clip122") as Sprite ;
			assertEquals("DisplayObjectExpert.displayObjectsTreatment wrong number of children on clip122 clip", 
						1, child.numChildren) ;
			assertTrue("DisplayObjectExpert.displayObjectsTreatment wrong type on clip122",
						((root.getChildByName("clip1") as MovieClip).getChildByName("clip12") as MovieClip).getChildByName("clip122") is Sprite) ;
		}
		
	}
}