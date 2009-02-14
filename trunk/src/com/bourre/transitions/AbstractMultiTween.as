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
	import com.bourre.core.AccessorComposer;
	import com.bourre.core.AccessorFactory;
	import com.bourre.error.IndexOutOfBoundsException;
	import com.bourre.error.UnimplementedVirtualMethodException;
	import com.bourre.log.PixlibDebug;
	import com.bourre.utils.ClassUtils;
	
	import flash.events.Event;	

	/**
	 *  Dispatched when tween start.
	 *  
	 *  @eventType com.bourre.transitions.TweenEvent.onStartEVENT
	 */
	[Event(name="onStart", type="com.bourre.transitions.TweenEvent")]
	
	/**
	 *  Dispatched when tween stop.
	 *  
	 *  @eventType com.bourre.transitions.TweenEvent.onStopEVENT
	 */
	[Event(name="onStop", type="com.bourre.transitions.TweenEvent")]
	
	/**
	 *  Dispatched when tweened property value change.
	 *  
	 *  @eventType com.bourre.transitions.TweenEvent.onMotionChangedEVENT
	 */
	[Event(name="onMotionChanged", type="com.bourre.transitions.TweenEvent")]
	
	/**
	 * The AbstractMultiTween class allow tweening of many object properties 
	 * at the same time.
	 * 
	 * @author 	Cédric Néhémie
	 */
	public class AbstractMultiTween 
		extends AbstractSyncCommand	
		implements AdvancedTween, TickListener
	{	
		/**
		 * Returns a no easing function for tweening process.
		 * 
		 * @return A no easing function for tweening process.
		 */
		static public function noEasing( t : Number,  b : Number,  c : Number, d : Number ) : Number 
		{
			return c * t / d + b;
		}
		
		//-------------------------------------------------------------------------
		// Private properties
		//-------------------------------------------------------------------------
		
		/** @private */
		protected var _aStart			 : Array; 
		/** @private */
		protected var _aEnd				 : Array;
		/** @private */
		protected var _aStartValues		 : Array;
		/** @private */
		protected var _aEndValues		 : Array;
		/** @private */
		protected var _nDuration		 : Number;
		/** @private */
		protected var _fEasing			 : Function;	
		/** @private */
		protected var _nPlayHead		 : Number;
		/** @private */
		protected var _bReversedMotion 	 : Boolean;	
		/** @private */
		protected var _oSetter 			 : AccessorComposer;
		/** @private */
		protected var _oBeacon 			 : TickBeacon;		
		/** @private */
		protected var _eOnStart 		 : TweenEvent;
		/** @private */
		protected var _eOnStop 			 : TweenEvent;
		/** @private */
		protected var _eOnMotionChanged  : TweenEvent;
		/** @private */
		protected var _eOnMotionFinished : TweenEvent;
		
		
		//-------------------------------------------------------------------------
		// Private implementation
		//-------------------------------------------------------------------------
		
		/**
		 * Creates new <code>AbstractMultiTween</code> instance.
		 * 
		 * @param	targets		Tween target
		 * @param	setters		Setter accessor list
		 * @param	endValues	End values for all tweened properties
		 * @param	startValues	Start values for all tweened properties
		 * @param	easing		Easing function to use for tweening
		 * @param	getters		Getter accessor list
		 */
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
		
		/**
		 * @inheritDoc
		 */	
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
		
		/**
		 * @inheritDoc
		 */	
		public function reset() : void
		{
			_nPlayHead = 0;
			_bReversedMotion = false;
			_aStart = _aStartValues;
			_oSetter.setValue( _aStart );
			_aEnd = _aEndValues;
		}
		
		/**
		 * @inheritDoc
		 */	
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
		
		/**
		 * @inheritDoc
		 */	
		public function stop() : void
		{
			_oBeacon.removeTickListener(this);
			_bIsRunning = false;
			_oEB.broadcastEvent( _eOnStop );
		}
		
		/*-----------------------------------------------
		 *	Tween IMPLEMENTATION
		 *-----------------------------------------------*/
		
		/**
		 * @inheritDoc
		 */	
		public function setEasing( f : Function ) : void
		{
			_fEasing = ( f != null ) ?  f : AbstractTween.noEasing;
		}
		
		
		/*-----------------------------------------------
		 *	VIRTUAL MEMBERS
		 *-----------------------------------------------*/
		
		/**
		 * Returns <code>true</code> if tweening is finished.
		 * 
		 * @return <code>true</code> if tweening is finished
		 */
		public function isMotionFinished () : Boolean
		{	
			return false;
		}
		
		/**
		 * Returns <code>true</code> if tweening is finished.
		 * 
		 * <p>Reverse mode only.</code>
		 * 
		 * @return <code>true</code> if tweening is finished
		 */
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
		
		/**
		 * Returns <code>true</code> if the motion is in reverse mode.
		 * 
		 * @return <code>true</code> if the motion is in reverse mode
		 */
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
		
		/**
		 * @inheritDoc
		 */		
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
		
		/**
		 * @copy com.bourre.events.Broadcaster#addListener()
		 */
		public function addListener( listener : TweenListener ) : Boolean
		{
			return _oEB.addListener( listener );
		}
		
		/**
		 * @copy com.bourre.events.Broadcaster#removeListener()
		 */
		public function removeListener( listener : TweenListener ) : Boolean
		{
			return _oEB.removeListener( listener );
		}
		
		/**
		 * @copy com.bourre.events.Broadcaster#addEventListener()
		 */
		public function addEventListener( type : String, listener : Object, ... rest ) : Boolean
		{
			return _oEB.addEventListener.apply( _oEB, rest.length > 0 ? [ type, listener ].concat( rest ) : [ type, listener ] );
		}
		
		/**
		 * @copy com.bourre.events.Broadcaster#removeEventListener()
		 */
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