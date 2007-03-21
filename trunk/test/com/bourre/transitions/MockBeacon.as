package com.bourre.transitions
{
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import com.bourre.events.BasicEvent;
	
	public class MockBeacon implements FrameBeacon
	{
		private static var _oInstance : MockBeacon;
		
		private var _oShape : Shape; 
		private var _bIP : Boolean;
		private var _oED : EventDispatcher;
		
		public function MockBeacon ( o : ConstructorAccess )
		{
			_oShape = new Shape();
			_bIP = false;
			_oED = new EventDispatcher ();
		}
		public function start() : void
		{
			if( !_bIP )
			{
				_bIP = true;
				_oShape.addEventListener( Event.ENTER_FRAME, enterFrameHandler );
			}
		}
		
		public function stop() : void
		{
			if( _bIP )
			{
				_bIP = false;
				_oShape.removeEventListener( Event.ENTER_FRAME, enterFrameHandler );
			}
		}
		
		public function isPlaying() : Boolean
		{
			return _bIP;
		}
		
		public function addFrameListener( listener : FrameListener ) : void
		{
			return _oED.addEventListener( Event.ENTER_FRAME, listener.onEnterFrame, false, 0, true );
		}
		public function removeFrameListener( listener : FrameListener ) : void
		{
			return _oED.removeEventListener( Event.ENTER_FRAME, listener.onEnterFrame );
		}
		
		public function enterFrameHandler ( e : Event ) : void
		{
			var evt : BasicEvent = new BasicEvent( Event.ENTER_FRAME, this );
			_oED.dispatchEvent( evt );
		}
		
		public static function getInstance() : MockBeacon
		{
			if( !_oInstance ) _oInstance = new MockBeacon( new ConstructorAccess () );
			return _oInstance;
		}
	}
}
internal class ConstructorAccess {}