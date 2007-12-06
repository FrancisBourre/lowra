package com.bourre.transitions {
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import com.bourre.events.BasicEvent;
	import com.bourre.log.PixlibStringifier;	

	public class MSBeacon implements FrameBeacon
	{
		private static var _oInstance : MSBeacon;
		
		private var _oTimer : Timer; 
		private var _nFramerate : Number;
		private var _bIP : Boolean;
		private var _oED : EventDispatcher;
		
		public function MSBeacon ()
		{
			_nFramerate = 1000/40;
			_oTimer = new Timer( _nFramerate, 0 );
			_oTimer.addEventListener( TimerEvent.TIMER , timeHandler );
			_bIP = false;
			_oED = new EventDispatcher ();
		}
		
		public function start() : void
		{
			if( !_bIP )
			{
				_bIP = true;
				_oTimer.start();
			}
		}
		
		public function stop() : void
		{
			if( _bIP )
			{
				_bIP = false;
				_oTimer.stop();
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
		
		public function timeHandler ( e : TimerEvent = null ) : void
		{
			var evt : BasicEvent = new BasicEvent( Event.ENTER_FRAME, this );
			_oED.dispatchEvent( evt );
		}
		
		public static function getInstance() : MSBeacon
		{
			if( !_oInstance ) _oInstance = new MSBeacon();
			return _oInstance;
		}
		public function setFramerate ( n : Number = 25 ) : void 
		{
			_nFramerate = n;
			_oTimer.delay = _nFramerate;
		}
		public function getFramerate () : Number
		{
			return _nFramerate;
		}
		public function setFPS ( n : Number = 40 ) : void
		{
			setFramerate ( Math.round( 1000/n ) );
		} 
		public function getFPS () : Number
		{
			return Math.round(1000/_nFramerate);
		}
		
		public static function release () : void
		{
			_oInstance.stop();
			_oInstance._oTimer.removeEventListener( TimerEvent.TIMER , _oInstance.timeHandler );
			_oInstance = null;
		}
		public function toString() : String 
		{
			return PixlibStringifier.stringify( this );
		}
	}
}
internal class PrivateMSBeaconConstructorAccess {}