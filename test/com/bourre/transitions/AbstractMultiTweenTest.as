package com.bourre.transitions
{
	import flexunit.framework.TestCase;
	import flash.display.Sprite;
	import com.bourre.core.MockAccessor;
	import com.bourre.commands.MockASyncCommandListener;

	public class AbstractMultiTweenTest extends TestCase
	{
		private var _t : MockMultiTweenFPS;
		private var _o : Sprite;
		private var _m : MockAccessor;
		private var errorOccurs : Boolean
		
		public override function setUp () : void
		{
			_o = new Sprite();
			_m = new MockAccessor();
			_t = new MockMultiTweenFPS ( [ _o, _o, _m ], [ "x", "y", "setProp" ], [ 50, 100, 80 ], 10, null, null, [ null, null, "getProp" ] );
		}
		public function testConstruct () : void
		{
			assertNotNull ( "MockMultiTweenFPS return a null object - test1 failed", _t );
			
			assertTrue ( "MockMultiTweenFPS don't return an array of target - test2 failed", _t.getTarget() is Array );
			assertEquals ( "MockMultiTweenFPS don't return the good number of targets - test3 failed", 3, (_t.getTarget() as Array).length );
			
			var vals : Array = _t.getStartValue();
			
			assertNotNull ( "MockMultiTweenFPS.getStartValue() return a null entity", vals );
			assertEquals ( "Starting value retreived from the getter is not valid - test3 failed", 0, vals[0] );
			assertEquals ( "Starting value retreived from the getter is not valid - test4 failed", 0, vals[1] );
			assertEquals ( "Starting value retreived from the getter is not valid - test5 failed", 250, vals[2] );
			try
			{
				var t : MockMultiTweenFPS = new MockMultiTweenFPS ( _o, ["pouet"], [50], 10 );
			}
			catch ( e : Error )
			{
				errorOccurs = true
			}
			
			assertTrue ( "MockMultiTweenFPS constructor don't failed to create a tween with an invalid target property - test2 failed", errorOccurs );
		}
		
		public function testRun () : void
		{
			var n : Number = 0;
			var i : Number = 0;
			
			_t.start();
			
			while ( _t.isPlaying() )
			{
				MockBeacon.getInstance().fireOnTickEvent( null );
				n++;
				i++;
				assertEquals ( "MockMultiTweenFPS don't modify the object correctly in the iteration " + i + " - test1 failed", n*5, _o.x );
				
			}
			assertEquals ( "Beacon haven't run 10 times - test2 failed", 10, i );
			assertEquals ( "Target object property don't equals tween end value - test3 failed", 50, _o.x );
			
			_t.yoyo();
			n = 10;
			i = 0;
			while ( _t.isPlaying() )
			{
				MockBeacon.getInstance().fireOnTickEvent( null );
				n--;
				i++;
				assertEquals ( "MockMultiTweenFPS don't modify the object correctly in the iteration " + i + "  - test4 failed", n*5, _o.x );
			}
			assertEquals ( "Beacon haven't run 10 times in yoyo - test5 failed", 10, i );
			assertEquals ( "Target object property don't equals tween end value - test6 failed", 0, _o.x );
			
			
			var t : MockMultiTweenFPS = new MockMultiTweenFPS ( _m, ["prop","setProp"], [ 50, 200 ], 10, null, null, [null, "getProp"] );
						
			t.start();
			n = 0;
			i = 0;
			var step : Number;
			while ( t.isPlaying() )
			{
				MockBeacon.getInstance().fireOnTickEvent( null );
				n++;
				i++;
				step = 250 - (n * 5);
				assertEquals ( "MockMultiTweenFPS don't modify the object correctly in the iteration " + i + " - test8 failed", step, _m.getProp() );
			}
			assertEquals ( "Beacon haven't run 10 times on a method accessor - test9 failed", 10, i );
			assertEquals ( "Target object property don't equals tween end value - test10 failed", 200, _m.getProp() );
		}
		
		public function testASyncBehavior () : void
		{
			var l : MockASyncCommandListener = new MockASyncCommandListener();
			
			assertTrue( "Listener haven't been added - test1 failed", _t.addASyncCommandListener( l ) );
			_t.start();
			
			while ( _t.isPlaying() )
			{
				MockBeacon.getInstance().fireOnTickEvent( null );
			}
			assertTrue ( "MockMultiTweenFPS haven't fired the onCommandEnd event - test2 failed", l.called );
		}
		
		public function testEventBroadcasting () : void
		{
			var l : MockTweenListener = new MockTweenListener ();
			
			assertTrue( "Listener haven't been added - test1 failed", _t.addListener( l ) );
			_t.start();

			while ( _t.isPlaying() )
			{
				MockBeacon.getInstance().fireOnTickEvent( null );
			}
			
			assertTrue ( "MockMultiTweenFPS haven't fired the onStart event - test2 failed", l.startCalled );
			assertTrue ( "MockMultiTweenFPS haven't fired the onMotionFinished event - test4 failed", l.motionFinishedCalled );
			assertTrue ( "MockMultiTweenFPS haven't fired the onMotionChanged event - test5 failed", l.motionChangedCalled );
			assertTrue ( "MockMultiTweenFPS haven't fired the onCommandEnd event - test5 failed", l.commandEndCalled );
			assertEquals ( "MockMultiTweenFPS haven't fired the onMotionChanged event at each step - test6 failed", 10, l.motionChangedCallCount );
		}
		
		public function testStopEvent () : void
		{
			var l : MockTweenListener = new MockTweenListener ();
			
			assertTrue( "Listener haven't been added - test1 failed", _t.addListener( l ) );
			_t.start();
			
			var n : Number = 0;

			while ( _t.isPlaying() )
			{
				n++;
				
				if( n == 5 )
					_t.stop();
							 
				MockBeacon.getInstance().fireOnTickEvent( null );
			}
			assertTrue ( "MockMultiTweenFPS haven't fired the onStop event - test2 failed", l.stopCalled );
			assertFalse ( "MockMultiTweenFPS have fired the onMotionFinished event - test3 failed", l.motionFinishedCalled );
		}
	}
}