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
	import com.bourre.commands.AbstractSyncCommand;
	import com.bourre.core.Accessor;
	import com.bourre.core.AccessorFactory;
	import com.bourre.core.PropertyAccessor;
	import com.bourre.error.IndexOutOfBoundsException;
	import com.bourre.error.UnimplementedVirtualMethodException;
	import com.bourre.log.PixlibDebug;
	import com.bourre.utils.ClassUtils;
	
	import flash.events.Event;		

	/**
	 * @author	Cédric Néhémie
	 */
	public class AbstractTween 
		extends AbstractSyncCommand 
		implements AdvancedTween, TickListener
	{	
		static public function noEasing( t : Number,  b : Number,  c : Number, d : Number ) : Number 
		{
			return c * t / d + b;
		}
		
		//-------------------------------------------------------------------------
		// INSTANCES MEMBERS
		//-------------------------------------------------------------------------
		
		protected var _nStart	   		 : Number; 
		protected var _nEnd		   		 : Number;
		protected var _nStartValue 		 : Number;
		protected var _nEndValue   		 : Number;
		protected var _nDuration   		 : Number;
		protected var _nPlayHead   		 : Number;
		protected var _fEasing	   	  	 : Function;
		protected var _bReversedMotion 	 : Boolean;
		protected var _oSetter 			 : Accessor;
		protected var _oBeacon  		 : TickBeacon;
		protected var _eOnStart 		 : TweenEvent;
		protected var _eOnStop 			 : TweenEvent;
		protected var _eOnMotionChanged  : TweenEvent;
		protected var _eOnMotionFinished : TweenEvent;
		
		//-------------------------------------------------------------------------
		// PUBLIC MEMBERS
		//-------------------------------------------------------------------------
			
		public function AbstractTween( 	target : Object,
										setter : String, 
										endValue : Number,
										duration : Number, 
										startValue : Number = NaN, 
										easing : Function = null, 
										getter : String = null )
		{			
			if( !ClassUtils.isImplementedAll( this, "com.bourre.transitions::AbstractTween", "isMotionFinished", "isReversedMotionFinished" ) )
			{
				PixlibDebug.ERROR ( this + " have to implements virtual methods : isMotionFinished & isReversedMotionFinished " );
				throw new UnimplementedVirtualMethodException ( this + " have to implements virtual methods : isMotionFinished & isReversedMotionFinished" );
			}
			
			_buildAccessor( target, setter, getter, startValue );
			
			_bIsRunning = false;
			_nEndValue = endValue;
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
			if ( _bReversedMotion ? isReversedMotionFinished() : isMotionFinished() )
			{
				_onMotionEnd();
			} 
			else
			{
				onUpdate();
			}
		}
		
		/*-----------------------------------------------
		 *	Tween IMPLEMENTATION
		 *-----------------------------------------------*/
		
		public function setEasing( f : Function ) : void
		{
			_fEasing = ( f != null ) ?  f : AbstractTween.noEasing;
		}
		
		/*-----------------------------------------------
		 *	Suspendable IMPLEMENTATION
		 *-----------------------------------------------*/
		
		public function reset() : void
		{
			_nPlayHead = 0;
			_bReversedMotion = false;
			_nStart = _nStartValue;
			_nEnd = _nEndValue;
			
			_oSetter.setValue( _nStart );
		}

		public function start() : void
		{
			if ( isNaN( _nStartValue ) ) 
			{
				PixlibDebug.WARN( this + " has no start value." );
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
		 *	Command IMPLEMENTATION
		 *-----------------------------------------------*/
		 
		override public function execute( e : Event = null ) : void
		{
			reset();
			start();
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
		
		public function onUpdate () : void
		{
			_oSetter.setValue( _fEasing( _nPlayHead, _nStart, _nEnd - _nStart, _nDuration ) );
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
		
		public function setDuration( n : Number ) : void
		{
			_nDuration = n;
		}
		
		public function getDuration() : Number
		{
			return _nDuration;
		}
		
		public function getTarget() : Object
		{
			return _oSetter.getTarget();
		}
		
		public function setTarget( o : Object ) : void
		{
			if ( isRunning() )
			{
				PixlibDebug.WARN( this + ".setTarget() invalid call while playing." );
			} 
			else
			{
				_buildAccessor( o, _oSetter.getSetterHelper(), _oSetter.getGetterHelper() );
			}
		}
		
		public function getProperty() : String
		{
			return PropertyAccessor(_oSetter).getProperty();
		}
		
		public function setProperty( p : String ) : void
		{
			if ( isRunning() )
			{
				PixlibDebug.WARN( this + ".setProperty() invalid call while playing." );
			} 
			else
			{
				var target : Object = _oSetter.getTarget();
				_buildAccessor( target, p,  target[p] );
			}
		}		
		
		public function setStartValue( n : Number ) : void
		{
			_nStartValue = n;
		}
		
		public function getStartValue () : Number
		{
			return _nStartValue;
		}
		
		public function setEndValue( n : Number ) : void
		{
			_nEndValue = n;
		}
		
		public function getEndValue () : Number
		{
			return _nEndValue;
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
		// PROTECTED MEMBERS
		//-------------------------------------------------------------------------
		
		protected function _buildAccessor( o : Object, sP : String, gP : String = null, nS : Number = NaN ) : void
		{
			_oSetter = AccessorFactory.getAccessor( o, sP, gP );
			if (!isNaN(nS)) _nStartValue = nS;
			else _nStartValue = _oSetter.getValue();
		}
		
		protected function _onMotionEnd() : void
		{			
			_bIsRunning = false;
			_oBeacon.removeTickListener( this );
			
			_nPlayHead = _bReversedMotion ? 0 : _nDuration;
			onUpdate();
			
			fireCommandEndEvent();
			_oEB.broadcastEvent( _eOnMotionFinished );
		}
	}
}