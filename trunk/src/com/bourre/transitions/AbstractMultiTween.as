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
	import flash.events.Event;
	
	import com.bourre.commands.AbstractSyncCommand;
	import com.bourre.core.AccessorComposer;
	import com.bourre.core.AccessorFactory;
	import com.bourre.error.IndexOutOfBoundsException;
	import com.bourre.error.UnimplementedVirtualMethodException;
	import com.bourre.log.PixlibDebug;
	import com.bourre.utils.ClassUtils;	

	/**
	 * 
	 * @author	Cédric Néhémie
	 */
	public class AbstractMultiTween extends AbstractSyncCommand	
									implements AdvancedTween, TickListener
	{	
		static public function noEasing( t : Number,  b : Number,  c : Number, d : Number ) : Number 
		{
			return c * t / d + b;
		}
		
		//-------------------------------------------------------------------------
		// Private properties
		//-------------------------------------------------------------------------
		
		protected var _aStart			 : Array; 
		protected var _aEnd				 : Array;
		protected var _aStartValues		 : Array;
		protected var _aEndValues		 : Array;
		protected var _nDuration		 : Number;
		protected var _fEasing			 : Function;	
		protected var _nPlayHead		 : Number;
		protected var _bReversedMotion 	 : Boolean;	
		protected var _oSetter 			 : AccessorComposer;
		protected var _oBeacon 			 : TickBeacon;		
		protected var _eOnStart 		 : TweenEvent;
		protected var _eOnStop 			 : TweenEvent;
		protected var _eOnMotionChanged  : TweenEvent;
		protected var _eOnMotionFinished : TweenEvent;
		
		//-------------------------------------------------------------------------
		// Private implementation
		//-------------------------------------------------------------------------
		
		public function AbstractMultiTween( targets : Object, 
									   		setters : Array, 
									   		endValues : Array, 
									   		duration : Number, 
									   		startValues : Array = null, 
									   		easing : Function = null,
									   		getters : Array = null )
		{
			if( !ClassUtils.isImplementedAll( this, "com.bourre.transitions:AbstractMultiTween", "isMotionFinished", "isReversedMotionFinished" ) )
			{
				PixlibDebug.ERROR ( this + " have to implements virtual methods : isMotionFinished & isReversedMotionFinished" );
				throw new UnimplementedVirtualMethodException ( this + " have to implements virtual methods : isMotionFinished & isReversedMotionFinished" );
			}
			_buildAccessor( targets, setters, getters, startValues );
			
			_bIsRunning = false;
			_aEndValues = endValues;
			_nDuration = duration;
			
			setEasing( easing );
			reset();
			
			_eOnStart = new TweenEvent ( TweenEvent.onStartEVENT, this );
			_eOnStop = new TweenEvent ( TweenEvent.onStopEVENT, this );
			_eOnMotionChanged = new TweenEvent ( TweenEvent.onMotionChangedEVENT, this );
			_eOnMotionFinished = new TweenEvent ( TweenEvent.onMotionFinishedEVENT, this );
		}
		
		/*-----------------------------------------------
		 *	TickListener IMPLEMENTATION
		 *-----------------------------------------------*/
		
		public function onTick( e : Event = null ) : void
		{
			if ( _bReversedMotion ? isReversedMotionFinished() :  isMotionFinished() )
			{
				_onMotionEnd();
			} 
			else
			{
				_update();
			}
		}
		
		/*-----------------------------------------------
		 *	Suspendable IMPLEMENTATION
		 *-----------------------------------------------*/
		
		public function reset() : void
		{
			_nPlayHead = 0;
			_bReversedMotion = false;
			_aStart = _aStartValues;
			_oSetter.setValue( _aStart );
			_aEnd = _aEndValues;
		}
		
		public function start() : void
		{
			if ( !_aStartValues ) 
			{
				PixlibDebug.FATAL( this + " has no start value." );
				
			} 
			else
			{
				_bIsRunning = true;
				_oBeacon.addTickListener(this);
				_oEB.broadcastEvent( _eOnStart );
			}
		}
				
		public function stop() : void
		{
			_oBeacon.removeTickListener(this);
			_bIsRunning = false;
			_oEB.broadcastEvent( _eOnStop );
		}
		
		/*-----------------------------------------------
		 *	Tween IMPLEMENTATION
		 *-----------------------------------------------*/
		
		public function setEasing( f : Function ) : void
		{
			_fEasing = ( f != null ) ?  f : AbstractTween.noEasing;
		}
		
		
		/*-----------------------------------------------
		 *	VIRTUAL MEMBERS
		 *-----------------------------------------------*/
		
		public function isMotionFinished () : Boolean
		{	
			return false;
		}
		
		public function isReversedMotionFinished () : Boolean
		{	
			return false;
		}
		
		/*-----------------------------------------------
		 *	ELSE
		 *-----------------------------------------------*/
		
		public function onUpdate ( sV : Number, eV : Number ) : Number
		{
			return _fEasing( _nPlayHead, sV, eV - sV, _nDuration );
		}
		
		public function _update() : void
		{
			var a : Array = new Array();
			var l : Number = _aEnd.length;
			for ( var i : Number= 0; i < l; i++ ) a.push( onUpdate( _aStart[i], _aEnd[i] ) );
			_oSetter.setValue( a );
			_oEB.broadcastEvent( _eOnMotionChanged );	
		}
		
		public function isReversed() : Boolean
		{
			return _bReversedMotion;
		}
		
		public function setReversed( b : Boolean ) : void
		{
			_bReversedMotion = b;
		}
		
		public function setPlayHeadPosition ( n : Number ) : void
		{
			if ( n < 0 || n > 1 )
				throw new IndexOutOfBoundsException( "The new playhead position must be in the range 0 < n < 1" );
				
			_nPlayHead = Math.floor( n * _nDuration );
		}

		public function getPlayHeadPosition () : Number
		{
			return _nPlayHead / _nDuration;
		}
		
		public function getEasing() : Function
		{
			return _fEasing;
		}
		
		public function getDuration() : Number
		{
			return _nDuration;
		}
				
		public override function execute( e : Event = null ) : void
		{
			reset();
			start();
		}

		public function getTarget () : Object
		{
			return _oSetter.getTarget();
		}
		
		public function setStartValue( a : Array ) : void
		{
			_aStartValues = a;
		}
		
		public function getStartValue () : Array
		{
			return _aStartValues;
		}
		
		public function setEndValue( a : Array ) : void
		{
			_aEndValues = a;
		}
		
		public function getEndValue () : Array
		{
			return _aEndValues;
		}
		
		public function setDuration( n : Number ) : void
		{
			_nDuration = n;
		}
		
		public function addListener( listener : TweenListener ) : Boolean
		{
			return _oEB.addListener( listener );
		}

		public function removeListener( listener : TweenListener ) : Boolean
		{
			return _oEB.removeListener( listener );
		}
		
		public function addEventListener( type : String, listener : Object, ... rest ) : Boolean
		{
			return _oEB.addEventListener.apply( _oEB, rest.length > 0 ? [ type, listener ].concat( rest ) : [ type, listener ] );
		}
		
		public function removeEventListener( type : String, listener : Object ) : Boolean
		{
			return _oEB.removeEventListener( type, listener );
		}
		
		
		//-------------------------------------------------------------------------
		// Private implementation
		//-------------------------------------------------------------------------
		
		protected function _buildAccessor( o : Object, sP  : Array, gP : Array = null, nS : Array = null ) : void
		{
			_oSetter = AccessorFactory.getMultiAccessor( o, sP, gP );
			if (nS) _aStartValues = nS;
			else _aStartValues = _oSetter.getValue();
		}
		
		protected function _onMotionEnd() : void
		{
			_bIsRunning = false;
			_oBeacon.removeTickListener( this );
			
			_nPlayHead = _bReversedMotion ? 0 : _nDuration;
			_update();
			
			fireCommandEndEvent();
			_oEB.broadcastEvent( _eOnMotionFinished );
		}
	}
}