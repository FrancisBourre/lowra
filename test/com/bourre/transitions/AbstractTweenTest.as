package com.bourre.transitions
{
	import flexunit.framework.TestCase;
	import flash.display.Sprite;
	import com.bourre.core.MockAccessor;
	import com.bourre.commands.MockASyncCommandListener;

	public class AbstractTweenTest extends TestCase
	{
		private var _t : MockTweenFPS;
		private var _o : Sprite;
		private var _m : MockAccessor;
		private var errorOccurs : Boolean;
		
		public override function setUp () : void
		{
			_o = new Sprite();
			_t = new MockTweenFPS ( _o, "x", 50, 10 );	
			_m = new MockAccessor ();
			errorOccurs = false;
		}
		public function testConstruct() : void
		{
			assertNotNull ( "MockTweenFPS constructor return null - test1 failed", _t );
			
			try
			{
				var t1 : MockTweenFPS = new MockTweenFPS ( _o, "pouet", 50, 10 );
			}
			catch ( e : Error )
			{
				errorOccurs = true
			}
			
			assertTrue ( "MockTweenFPS constructor don't failed to create a tween with an invalid target property - test2 failed", errorOccurs );
			
			errorOccurs = false;
			try
			{
				var t2 : MockTweenFPS = new MockTweenFPS ( _m, "setProp", 50, 10, _m.getProp(), null, "getPropa" );
			}
			catch ( e : Error )
			{
				errorOccurs = true
			}
			
			assertTrue ( "MockTweenFPS constructor don't failed to create a tween with an invalid getter method name - test3 failed", errorOccurs );
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
				assertEquals ( "MockTweenFPS don't modify the object correctly in the iteration " + i + " - test1 failed", n*5, _o.x );
				
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
				assertEquals ( "MockTweenFPS don't modify the object correctly in the iteration " + i + "  - test4 failed", n*5, _o.x );
			}
			assertEquals ( "Beacon haven't run 10 times in yoyo - test5 failed", 10, i );
			assertEquals ( "Target object property don't equals tween end value - test6 failed", 0, _o.x );
			
			
			var t : MockTweenFPS = new MockTweenFPS ( _m, "setProp", 50, 10, NaN, null, "getProp" );
			assertEquals ( "Starting value retreived from the getter is not valid - test7 failed", 250, t.getStartValue() );
			
			t.start();
			n = 10;
			i = 0;
			var step : Number;
			while ( t.isPlaying() )
			{
				MockBeacon.getInstance().fireOnTickEvent( null );
				n--;
				i++;
				step = 50 + n * 20;
				assertEquals ( "MockTweenFPS don't modify the object correctly in the iteration " + i + " - test8 failed", step, _m.getProp() );
			}
			assertEquals ( "Beacon haven't run 10 times on a method accessor - test9 failed", 10, i );
			assertEquals ( "Target object property don't equals tween end value - test10 failed", 50, _m.getProp() );
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
			assertTrue ( "MockTweenFPS haven't fired the onCommandEnd event - test2 failed", l.called );
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
			
			assertTrue ( "MockTweenFPS haven't fired the onStart event - test2 failed", l.startCalled );
			assertTrue ( "MockTweenFPS haven't fired the onMotionFinished event - test4 failed", l.motionFinishedCalled );
			assertTrue ( "MockTweenFPS haven't fired the onMotionChanged event - test5 failed", l.motionChangedCalled );
			assertTrue ( "MockTweenFPS haven't fired the onCommandEnd event - test5 failed", l.commandEndCalled );
			assertEquals ( "MockTweenFPS haven't fired the onMotionChanged event at each step - test6 failed", 10, l.motionChangedCallCount );
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
			assertTrue ( "MockTweenFPS haven't fired the onStop event - test2 failed", l.stopCalled );
			assertFalse ( "MockTweenFPS have fired the onMotionFinished event - test3 failed", l.motionFinishedCalled );
		}
		
		public function testSetTarget () : void
		{
			var o : Sprite = new Sprite();
			o.x = -100;
			
			try
			{
				_t.setTarget( o );
			}
			catch( e : Error ) 
			{
				errorOccurs = true;
			}
			
			assertFalse ( _t + ".setTarget() failed to create the new Accessor - test1 failed", errorOccurs );
			assertEquals ( _t + ".getStartValue() don't return the initial value of the new target - test2 failed", -100, _t.getStartValue() ); 
		}
	}
}