package com.bourre.transitions
{
	import flexunit.framework.TestCase;
	import flash.display.Sprite;
	import com.bourre.core.MockAccessor;
	import flash.events.Event;

	public class TweenMSTest extends TestCase
	{
		private var _oT : TweenMS;
		private var _oS : Sprite;
		private var _m : MockAccessor;
		private var _ml : MockTweenListener;
		
		private var errorOccurs : Boolean;
		
		public override function setUp () : void
		{
			_oS = new Sprite();
			_m = new MockAccessor();
			_oT = new TweenMS( _oS, "x", 100, 100 );
			_ml = new MockTweenListener();
			
			errorOccurs = false;
		}
		
		public function testConstruct () : void
		{
			var t : TweenMS;
			assertNotNull ( "Constructor returns null", _oT );
			
			t = new TweenMS ( _m, "setProp", 100, 10, 0, null, "getProp" );
			assertNotNull ( "Constructor returns null when passing a function", t );
			
			try
			{
				t = new TweenMS ( _m, "pouet", 100, 10 );
			}
			catch( e : Error )
			{
				errorOccurs = true;
			}
			assertTrue ( "Tween don't failed when passing a non-existing property", errorOccurs );
			
			errorOccurs = false;
			try
			{
				t = new TweenMS ( _m, "setProp", 100, 10, 0, null, "getPropa" );
			}
			catch( e : Error )
			{
				errorOccurs = true;
			}
			assertTrue ( "Tween don't failed when passing a non-existing getter method", errorOccurs );
		}
		public function testEventBroadcasting () : void
		{						  		
			assertTrue( "Listener haven't been added - test2 failed", _oT.addListener( _ml ) );
			assertTrue( "Listener haven't been added - test1 failed", 
						_oT.addEventListener( 	TweenEvent.onMotionFinishedEVENT, 
										  		addAsync( eventCallBack, 150 ) ) );
			
			_oT.start();
		}
		
		public function eventCallBack ( e : Event ) : void
		{
			assertTrue ( _oT + " haven't fired the onStart event - test1 failed", _ml.startCalled );
			assertTrue ( _oT + " haven't fired the onMotionChanged event - test3 failed", _ml.motionChangedCalled );
			assertTrue ( _oT + " haven't fired the onCommandEnd event - test4 failed", _ml.commandEndCalled );
			assertEquals ( _oT + " haven't modify the property correctly - test5 failed", 100, _oS.x );
		}
		
		public function testSetTarget () : void
		{
			var o : Sprite = new Sprite();
			o.x = -100;
			
			try
			{
				_oT.setTarget( o );
			}
			catch( e : Error ) 
			{
				errorOccurs = true;
			}
			
			assertFalse ( _oT + ".setTarget() failed to create the new Accessor - test1 failed", errorOccurs );
			assertEquals ( _oT + ".getStartValue() don't return the initial value of the new target - test2 failed", -100, _oT.getStartValue() ); 
		}
	}
}