package com.bourre.view 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	import com.bourre.plugin.NullPlugin;
	
	import flexunit.framework.TestCase;	

	public class AbstractViewTest extends TestCase
	{
		private var _oAV : AbstractView;
		private var _oDefaultAV : AbstractView;
		private var _oSprite : Sprite;
		
		static private var TESTID : String = "testId" ;
		public override function setUp () : void
		{
			_oDefaultAV = new AbstractView();
			
			_oSprite = new Sprite();

			var oChild1 : Sprite = new Sprite();
			oChild1.name = "child1" ;
			var oChild2 : MovieClip = new MovieClip();
			oChild2.name = "child2" ;

			oChild2['myFunction'] = myFunction ;
			oChild1.addChild( oChild2 );
			
			_oSprite.addChild( oChild1 );
			_oAV = new AbstractView( NullPlugin.getInstance(), TESTID, _oSprite );
		}
		
		public function myFunction() : void
		{
			
		}
		
		public function testConstruct () : void
		{
			assertEquals ( "AbstractView don't return a null for it's owner plugin - test1 failed", _oDefaultAV.getOwner(), NullPlugin.getInstance() );
			assertNull ( "AbstractView don't return a null for it's name id - test2 failed", _oDefaultAV.getName() );
			assertNull ( "AbstractView don't return a null for it's view - test3 failed", _oDefaultAV.view );
			
			assertEquals ( "AbstractView return a null for it's owner plugin - test4 failed", _oAV.getOwner() , NullPlugin.getInstance());
			assertEquals ( "AbstractView return a null for it's name id - test5 failed", _oAV.getName(), TESTID );
			assertEquals ( "AbstractView return a null for it's view - test6 failed", _oAV.view , _oSprite );
			
		}
		
		public function testRun () : void
		{
			assertNotNull ( "AbstractView::canResolveUI return a true for not exist ui - test1 failed", _oAV.canResolveUI('child1.notfound') );
			assertNotNull ( "AbstractView::canResolveFunction return a true for not exist function - test2 failed", _oAV.canResolveFunction('child1.child2.notfound')  );
			assertNotNull ( "AbstractView::resolveUI return a null for an exist ui  - test3 failed", _oAV.resolveUI('child1.child2') );
			assertNotNull ( "AbstractView::resolveFunction return a null for an exist function - test4 failed", _oAV.resolveFunction('child1.child2.myFunction')  );
			
		}
		
		override public function tearDown():void
	    {
	        ViewLocator.getInstance().unregister(TESTID);
	    }
		
	
	}
}