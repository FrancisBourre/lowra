package com.bourre.transitions
{
	import flash.events.Event;	

	public class MockTweenListener implements TweenListener
	{
		public var commandEndCalled : Boolean;
		public var stopCalled : Boolean;
		public var startCalled : Boolean;
		public var motionFinishedCalled : Boolean;
		public var motionChangedCalled : Boolean;
		public var motionChangedCallCount : Number = 0;
		
		public function onStop( e : TweenEvent ) : void
		{
			stopCalled = true;
		}
		
		public function onStart( e : TweenEvent ) : void
		{
			startCalled = true;
		}
		
		public function onMotionFinished( e : TweenEvent ) : void
		{
			motionFinishedCalled = true;
		}
		
		public function onMotionChanged( e : TweenEvent) : void
		{
			motionChangedCallCount++;
			motionChangedCalled = true;
		}
		
		public function onCommandEnd ( e : Event ) : void
		{
			commandEndCalled = true;
		}
		
	}
}