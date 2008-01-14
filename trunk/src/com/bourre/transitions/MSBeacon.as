/*
 * Copyright the original author or authors.
 * 
 * Licensed under the MOZILLA PUBLIC LICENSE, Version 1.1 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *      http://www.mozilla.org/MPL/MPL-1.1.html
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package com.bourre.transitions 
{
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import com.bourre.events.BasicEvent;
	import com.bourre.log.PixlibStringifier;	

	/**
	 * 
	 * @author	Cédric Néhémie
	 * @see		TickBeacon
	 */
	public class MSBeacon implements TickBeacon
	{
		/*-----------------------------------------------------
		 * 	CLASS MEMBERS
		 *-----------------------------------------------------*/
		
		private static var _oInstance : MSBeacon;
		
		private static const TICK : String = "onTick";
		
		/**
		 * 
		 * @return
		 */
		public static function getInstance() : MSBeacon
		{
			if( !_oInstance ) _oInstance = new MSBeacon();
			return _oInstance;
		}
		
		/**
		 * 
		 */
		public static function release () : void
		{
			_oInstance.stop();
			_oInstance._oTimer.removeEventListener( TimerEvent.TIMER , _oInstance.timeHandler );
			_oInstance = null;
		}
		
		/*-----------------------------------------------------
		 * 	INSTANCE MEMBERS
		 *-----------------------------------------------------*/
		
		private var _oTimer : Timer; 
		private var _nTickRate : Number;
		private var _bIP : Boolean;
		private var _oED : EventDispatcher;
		
		public function MSBeacon ()
		{
			_nTickRate = 1000/40;
			_oTimer = new Timer( _nTickRate, 0 );
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
		
		public function addTickListener( listener : TickListener ) : void
		{
			if( !_oED.hasEventListener( TICK ) )
				start();
			_oED.addEventListener( TICK, listener.onTick, false, 0, true );
		}
		public function removeTickListener( listener : TickListener ) : void
		{
			_oED.removeEventListener( TICK, listener.onTick );
			if( !_oED.hasEventListener( TICK ) )
				stop();
		}
		
		public function timeHandler ( e : TimerEvent = null ) : void
		{
			var evt : BasicEvent = new BasicEvent( TICK, this );
			_oED.dispatchEvent( evt );
		}
		

		public function setFramerate ( n : Number = 25 ) : void 
		{
			_nTickRate = n;
			_oTimer.delay = _nTickRate;
		}
		public function getFramerate () : Number
		{
			return _nTickRate;
		}
		public function setFPS ( n : Number = 40 ) : void
		{
			setFramerate ( Math.round( 1000/n ) );
		} 
		public function getFPS () : Number
		{
			return Math.round( 1000 / _nTickRate );
		}
		
		public function toString() : String 
		{
			return PixlibStringifier.stringify( this );
		}
	}
}
internal class PrivateMSBeaconConstructorAccess {}