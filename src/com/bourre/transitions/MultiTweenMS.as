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
	import flash.utils.getTimer;
	
	import com.bourre.log.PixlibStringifier;	
	/**
	 * @author Francis Bourre
	 * @version 1.0
	 */
	public class MultiTweenMS extends AbstractMultiTween
	{
		//-------------------------------------------------------------------------
		// PRIVATE MEMBERS
		//-------------------------------------------------------------------------
		
		private var _nStopTime : Number;
		
		//-------------------------------------------------------------------------
		// PUBLIC API
		//-------------------------------------------------------------------------
				
		public function MultiTweenMS(  targets : Object, 
								   		setters : Array, 
								   		endValues : Array, 
								   		duration : Number, 
								   		startValues : Array = null, 
								   		easing : Function = null,
								   		getters : Array = null )
		{
			super( targets, setters, endValues, duration, startValues, easing, getters );
			_oBeacon = MSBeacon.getInstance();
		}
		
		override public function start() : void
		{
			if( _nStopTime != 0 )
				_nPlayHead = getTimer() - ( _nStopTime - _nPlayHead );
			else
				_nPlayHead = 0;
			
			super.start();
		}
		
		override public function stop() : void
		{
			super.stop();
			_nStopTime = getTimer();
		}
		
		override public function reset() : void
		{
			_nStopTime = 0;
			super.reset();
		}

		//-------------------------------------------------------------------------
		// VIRTUAL METHODS IMPLEMENTATION
		//-------------------------------------------------------------------------
		
		public override function isMotionFinished() : Boolean
		{
			return getTimer() - _nPlayHead >= _nDuration;
		}
		
		public override function isReversedMotionFinished() : Boolean
		{
			return _nPlayHead - getTimer() <= 0;
		}
	}
}