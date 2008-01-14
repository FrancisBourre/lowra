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
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import com.bourre.events.BasicEvent;
	import com.bourre.log.PixlibStringifier;	

	/**
	 * 
	 * 
	 * @author	Cédric Néhémie
	 */
	public class FPSBeacon implements TickBeacon
	{
		/*-----------------------------------------------------
		 * 	CLASS MEMBERS
		 *-----------------------------------------------------*/
		
		private static var _oInstance : FPSBeacon;
		private static const TICK : String = "onTick";
		
		/**
		 * 
		 * @return
		 */
		public static function getInstance() : FPSBeacon
		{
			if( !_oInstance ) _oInstance = new FPSBeacon();
			return _oInstance;
		}
		
		/**
		 * 
		 */
		public static function release () : void
		{
			_oInstance.stop();
			_oInstance = null;
		}
		
		/*-----------------------------------------------------
		 * 	INSTANCE MEMBERS
		 *-----------------------------------------------------*/
		
		private var _oShape : Shape; 
		private var _bIP : Boolean;
		private var _oED : EventDispatcher;
		
		/**
		 * 
		 * @param	o
		 */
		public function FPSBeacon ()
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
		
		public function enterFrameHandler ( e : Event = null ) : void
		{
			var evt : BasicEvent = new BasicEvent( TICK, this );
			_oED.dispatchEvent( evt );
		}
	
		
		public function toString() : String 
		{
			return PixlibStringifier.stringify( this );
		}
	}
}