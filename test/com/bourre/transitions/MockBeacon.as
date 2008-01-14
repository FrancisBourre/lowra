package com.bourre.transitions
{
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import com.bourre.events.BasicEvent;
	
	public class MockBeacon implements TickBeacon
	{
		private static var _oInstance : MockBeacon;
		private static const TICK : String = "onTick";
		
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
				_oShape.addEventListener( Event.ENTER_FRAME, fireOnTickEvent );
			}
		}
		
		public function stop() : void
		{
			if( _bIP )
			{
				_bIP = false;
				_oShape.removeEventListener( Event.ENTER_FRAME, fireOnTickEvent );
			}
		}
		
		public function isPlaying() : Boolean
		{
			return _bIP;
		}
		
		public function addTickListener( listener : TickListener ) : void
		{
			_oED.addEventListener( TICK, listener.onTick, false, 0, true );
		}
		public function removeTickListener( listener : TickListener ) : void
		{
			_oED.removeEventListener( TICK, listener.onTick );
		}
		
		public function fireOnTickEvent ( e : Event ) : void
		{
			var evt : BasicEvent = new BasicEvent( TICK, this );
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