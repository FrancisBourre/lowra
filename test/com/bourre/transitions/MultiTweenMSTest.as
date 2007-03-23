package com.bourre.transitions
{
	import flexunit.framework.TestCase;
	import flash.display.Sprite;
	import com.bourre.core.MockAccessor;
	import flash.events.Event;

	public class MultiTweenMSTest extends TestCase
	{
		private var _oT :MultiTweenMS;
		private var _oS : Sprite;
		private var _m : MockAccessor;
		private var _ml : MockTweenListener;
		
		private var errorOccurs : Boolean;
		
		public override function setUp () : void
		{
			_oS = new Sprite();
			_m = new MockAccessor();
			_oT = new MultiTweenMS( [ _oS, _m ], ["x", "setProp"], [100, 50], 100, null, null, [ null,"getProp" ] );
			_ml = new MockTweenListener();
			
			errorOccurs = false;
		}
		
		public function testConstruct () : void
		{
			var t : MultiTweenMS;
			assertNotNull ( "Constructor returns null", _oT );
			
			try
			{
				t = new MultiTweenMS ( _m, ["pouet"], [100], 10 );
			}
			catch( e : Error )
			{
				errorOccurs = true;
			}
			assertTrue ( "Tween don't failed when passing a non-existing property", errorOccurs );
			
			errorOccurs = false;
			try
			{
				t = new MultiTweenMS ( _m, ["setProp"], [100], 10, null, null, ["getPropa"] );
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
			assertEquals ( _oT + " haven't modify the property correctly - test6 failed", 50, _m.getProp() );
		}
	}
}