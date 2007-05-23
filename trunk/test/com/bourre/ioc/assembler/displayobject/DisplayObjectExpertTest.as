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
	import com.bourre.ioc.parser.ContextNodeNameList;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import com.bourre.load.QueueLoaderEvent;

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
		
		public function testConstruct() : void
		{
			assertNotNull("DisplayObjectExpert constructor returns null", _oDOE) ;
		}
		
		public function testSetRootTarget():void
		{
			var mc:MovieClip = new MovieClip();
			_oDOE.setRootTarget(mc) ;

			var b : Boolean = false;
			try
			{
				_oDOE.setRootTarget( new MovieClip () );
			}
			catch (e:Error)
			{
				b = true ;
			}

			assertTrue("DisplayObjectExpert.setRootTarget doesn't throw an error when root target has been already set", b) ;
		}

		public function testBuildEmptyDisplayObject() : void
		{
			var mc : MovieClip = new MovieClip();
			_oDOE.setRootTarget( mc );

			_oDOE.buildEmptyDisplayObject( "idEmpty" );
			_oDOE.buildEmptyDisplayObject( "idEmptyChild", "idEmpty", -1, true, "Sprite" );
			_oDOE.addEventListener( DisplayObjectExpert.onLoadCompleteEVENT, addAsync(onTestBuildEmptyDisplayObject, 5000, mc) );
			_oDOE.load();
		}
		
		public function onTestBuildEmptyDisplayObject( e : Event, mc : Sprite ) : void
		{
			assertTrue ("DisplayObjectExpert.buildEmptyDisplayObject() fails to register 'idEmpty' id with BeanFactory", BeanFactory.getInstance().isRegistered("idEmpty") );				
			var emptyMC : DisplayObjectContainer = mc.getChildAt(0) as DisplayObjectContainer;
			assertTrue ("DisplayObjectExpert.buildEmptyDisplayObject() fails to add child with with Movieclip type", mc.getChildAt(0) is MovieClip) ;
			assertTrue ("DisplayObjectExpert.buildEmptyDisplayObject() fails to register 'idEmptyChild' id with BeanFactory", BeanFactory.getInstance().isRegistered("idEmptyChild") );
			assertTrue ("DisplayObjectExpert.buildEmptyDisplayObject() fails to add child with with Sprite type", emptyMC.getChildAt(0) is Sprite) ;
		}
		
		public function testBuildGraphicLoader():void
		{
			var mc : MovieClip = new MovieClip() ;
			_oDOE.setRootTarget( mc ) ;

			_oDOE.buildEmptyDisplayObject( "containerID" );
			_oDOE.buildGraphicLoader( "photo1", "http://www.tweenpix.net/blog/themes/tweenpix/img/banner2.jpg", "containerID" );
			_oDOE.buildGraphicLoader( "photo2", "http://www.tweenpix.net/blog/themes/tweenpix/img/banner3.jpg", "containerID" );
			_oDOE.addEventListener( DisplayObjectExpert.onLoadCompleteEVENT, addAsync(onTestBuildGraphicLoader, 5000, mc) );
			_oDOE.load() ;
		}
		
		public function onTestBuildGraphicLoader( e : Event, mc : MovieClip ) : void
		{
			assertStrictlyEquals( "DisplayObjectExpert.getRootTarget() doesn't return expected value", mc, _oDOE.getRootTarget() );
			assertTrue( "DisplayObjectExpert load() doesn't build 'container'", BeanFactory.getInstance().locate("containerID") is Sprite );
			assertTrue( "DisplayObjectExpert.load() doesn't load 'photo1'", BeanFactory.getInstance().locate("photo1") is Sprite );
			assertTrue( "DisplayObjectExpert.load() doesn't load 'photo2'", BeanFactory.getInstance().locate("photo2") is Sprite );		
		}

		public function testEmptyLoadingQueue() : void
		{
			_oDOE.addEventListener( DisplayObjectExpert.onLoadCompleteEVENT, addAsync( onTestEmptyLoadingQueue, 5000 ) );
			_oDOE.load() ;
		}

		public function onTestEmptyLoadingQueue( e : Event ) : void
		{
			assertTrue("DisplayObjectExpert.load doesn't call callback method when queue is empty",  e is QueueLoaderEvent ) ;
		}

		public function testDisplayObjectsTreatment() : void
		{
			//creation of the root
			var root : MovieClip = new MovieClip();
			_oDOE.setRootTarget( root ) ;
			
			//creation of the empty clips
			_oDOE.buildEmptyDisplayObject("clip1",	ContextNodeNameList.ROOT) ;
			_oDOE.buildEmptyDisplayObject("clip2",	ContextNodeNameList.ROOT) ;
			_oDOE.buildEmptyDisplayObject("clip11",	"clip1") ;
			_oDOE.buildEmptyDisplayObject("clip12",	"clip1") ;
			_oDOE.buildEmptyDisplayObject("clip111","clip11") ;
			_oDOE.buildEmptyDisplayObject("clip121","clip12") ;
			_oDOE.buildEmptyDisplayObject("clip122","clip12",0,true,"Sprite") ;
			
			//photos loaded in two clips (=> bitmap objects)
			_oDOE.buildGraphicLoader( "photo1", "http://www.tweenpix.net/blog/themes/tweenpix/img/banner2.jpg", "clip111", 0, true ) ;
			_oDOE.buildGraphicLoader( "photo2", "http://www.tweenpix.net/blog/themes/tweenpix/img/banner3.jpg", "clip122", 0, true ) ;
			
			_oDOE.addEventListener( DisplayObjectExpert.onLoadCompleteEVENT, addAsync( onTestDisplayObjectsTreatment, 5000, root) );
			_oDOE.load() ;
		}

		public function onTestDisplayObjectsTreatment( e:Event, mc:Object ) : void
		{
			var root : MovieClip = mc as MovieClip;
			var child : Sprite;
			
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