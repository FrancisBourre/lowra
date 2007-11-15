package com.bourre.transitions
{
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import com.bourre.events.BasicEvent;
	import com.bourre.log.PixlibStringifier;
	
	public class FPSBeacon implements FrameBeacon
	{
		private static var _oInstance : FPSBeacon;
		
		private var _oShape : Shape; 
		private var _bIP : Boolean;
		private var _oED : EventDispatcher;
		
		public function FPSBeacon ( o : PrivateFPSBeaconConstructorAccess )
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
			if( !_oED.hasEventListener( Event.ENTER_FRAME ) )
				start();

			_oED.addEventListener( Event.ENTER_FRAME, listener.onEnterFrame, false, 0, true );
		}
		public function removeFrameListener( listener : FrameListener ) : void
		{
			_oED.removeEventListener( Event.ENTER_FRAME, listener.onEnterFrame );
			if( !_oED.hasEventListener( Event.ENTER_FRAME ) )
				stop();
		}
		
		public function enterFrameHandler ( e : Event = null ) : void
		{
			var evt : BasicEvent = new BasicEvent( Event.ENTER_FRAME, this );
			_oED.dispatchEvent( evt );
		}
		
		public static function getInstance() : FPSBeacon
		{
			if( !_oInstance ) _oInstance = new FPSBeacon( new PrivateFPSBeaconConstructorAccess () );
			return _oInstance;
		}
		
		public static function release () : void
		{
			_oInstance.stop();
			_oInstance = null;
		}
		
		public function toString() : String 
		{
			return PixlibStringifier.stringify( this );
		}
	}
}
internal class PrivateFPSBeaconConstructorAccess {}