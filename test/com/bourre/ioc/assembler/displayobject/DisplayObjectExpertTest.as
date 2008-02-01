package com.bourre.ioc.assembler.displayobject
{
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLRequest;
	
	import com.bourre.ioc.bean.BeanFactory;
	import com.bourre.ioc.parser.ContextNodeNameList;
	import com.bourre.ioc.parser.ContextTypeList;
	import com.bourre.load.GraphicLoaderLocator;
	
	import flexunit.framework.TestCase;	

	public class DisplayObjectExpertTest extends TestCase
	{
		private var _oDOE : DisplayObjectExpert ;
		private var _b : Boolean ;

		public override function setUp():void
		{
			DisplayObjectExpert.release() ;
			BeanFactory.release();
			GraphicLoaderLocator.release();

			_b = false ;
			_oDOE = DisplayObjectExpert.getInstance();
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

			} catch (e:Error)
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
			_oDOE.buildEmptyDisplayObject( "idEmptyChild", "idEmpty", true, ContextTypeList.SPRITE );
			_oDOE.addEventListener( DisplayObjectExpertEvent.onDisplayObjectExpertLoadInitEVENT, addAsync(onTestBuildEmptyDisplayObject, 5000, mc) );
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
			_oDOE.buildGraphicLoader( "photo1", new URLRequest("http://url_that_doesnt_exist/nav_logo.png"), "containerID" );
			_oDOE.buildGraphicLoader( "photo2", new URLRequest( "http://www.google.fr/images/nav_logo2.png"), "containerID" );
			_oDOE.addEventListener( DisplayObjectExpertEvent.onDisplayObjectExpertLoadInitEVENT, addAsync(onTestBuildGraphicLoader, 5000, mc) );
			_oDOE.load() ;
		}
		
		public function onTestBuildGraphicLoader( e : Event, mc : MovieClip ) : void
		{
			assertStrictlyEquals( "DisplayObjectExpert.getRootTarget() doesn't return expected value", mc, _oDOE.getRootTarget() );
			assertTrue( "DisplayObjectExpert load() doesn't build 'container'", BeanFactory.getInstance().locate("containerID") is Sprite );
			
			var photo1 : Object;
			try{ photo1 = BeanFactory.getInstance().locate("photo1"); } catch ( e : Error ) {}
			assertNull( "DisplayObjectExpert.load() doesn't load 'photo1'", photo1 );
			assertTrue( "DisplayObjectExpert.load() doesn't load 'photo2'", BeanFactory.getInstance().locate("photo2") is Sprite );		
		}

		public function testEmptyLoadingQueue() : void
		{
			_oDOE.addEventListener( DisplayObjectExpertEvent.onDisplayObjectExpertLoadInitEVENT, addAsync( onTestEmptyLoadingQueue, 5000 ) );
			_oDOE.load() ;
		}

		public function onTestEmptyLoadingQueue( e : Event ) : void
		{
			assertTrue("DisplayObjectExpert.load doesn't call callback method when queue is empty", e is DisplayObjectExpertEvent ) ;
		}

		public function testBuildDisplayList() : void
		{
			//creation of the root
			var root : MovieClip = new MovieClip();
			_oDOE.setRootTarget( root ) ;
			
			//creation of the empty clips
			_oDOE.buildEmptyDisplayObject( "clip1",	ContextNodeNameList.ROOT ) ;
			_oDOE.buildEmptyDisplayObject( "clip2",	ContextNodeNameList.ROOT ) ;
			_oDOE.buildEmptyDisplayObject( "clip11", "clip1" ) ;
			_oDOE.buildEmptyDisplayObject( "clip12", "clip1" ) ;
			_oDOE.buildEmptyDisplayObject( "clip111", "clip11" ) ;
			_oDOE.buildEmptyDisplayObject( "clip121", "clip12" ) ;
			_oDOE.buildEmptyDisplayObject( "clip122", "clip12", true, ContextTypeList.SPRITE ) ;
			
			//photos loaded in two clips (=> bitmap objects)
			_oDOE.buildGraphicLoader( "photo1", new URLRequest( "http://www.google.fr/images/nav_logo.png" ), "clip111", true ) ;
			_oDOE.buildGraphicLoader( "photo2", new URLRequest( "http://www.google.fr/images/nav_logo2.png" ), "clip122", true ) ;
			
			_oDOE.addEventListener( DisplayObjectExpertEvent.onDisplayObjectExpertLoadInitEVENT, addAsync( onTestBuildDisplayList, 5000, root) );
			_oDOE.load() ;
		}

		public function onTestBuildDisplayList( e : Event, root : MovieClip ) : void
		{
			var child : Sprite;
			
			assertEquals( "Wrong number of children on root clip",  2, root.numChildren );
			
			child = _locate( "clip1" ) as MovieClip ;
			assertEquals( "Wrong number of children on clip1 clip", 2, child.numChildren );
						
			child = _locate( "clip2" ) as MovieClip ;
			assertEquals( "Wrong number of children on clip2 clip", 0, child.numChildren );
			assertTrue( "Wrong type on clip2", child is MovieClip ) ;
			
			child = _locate( "clip11" ) as MovieClip ;
			assertEquals( "Wrong number of children on clip11 clip", 1, child.numChildren );
						
			child = _locate( "clip12" ) as MovieClip ;
			assertEquals( "Wrong number of children on clip12 clip", 2, child.numChildren );
			
			child = _locate( "clip111" ) as MovieClip ;
			assertEquals( "Wrong number of children on clip111 clip", 1, child.numChildren);
			
			child = _locate( "clip121" ) as MovieClip ;
			assertEquals( "Wrong number of children on clip121 clip", 0, child.numChildren );
						
			child = _locate( "clip122" ) as Sprite ;
			assertEquals(" Wrong number of children on clip122 clip", 1, child.numChildren );
			assertTrue( "Wrong type on clip122", child is Sprite ) ;
		}
		
		protected function _locate( key : String ) : Object
		{
			return BeanFactory.getInstance().locate( key );
		}
	}
}