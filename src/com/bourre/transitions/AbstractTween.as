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
	import com.bourre.log.PixlibDebug;
	import com.bourre.log.PixlibStringifier;
	
	import flash.events.Event;
	import com.bourre.utils.ClassUtils;
	import com.bourre.error.UnimplementedVirtualMethodException;
	
	public class AbstractTween extends AbstractSyncCommand
		implements Tween, FrameListener
	{	
		//-------------------------------------------------------------------------
		// Private properties
		//-------------------------------------------------------------------------
		protected var abstractTweenConstructorAccess : AbstractTweenConstructorAccess = new AbstractTweenConstructorAccess ();	
		
		protected var _nS:Number; 
		protected var _nE:Number;
		protected var _nRS:Number;
		protected var _nRE:Number;
		protected var _nRate:Number;
		protected var _fE:Function;
		protected var _bP:Boolean;
		
		protected var _oSetter:Accessor;
		protected var _oBeacon : FrameBeacon;
		
		protected var _eOnStart : TweenEvent;
		protected var _eOnStop : TweenEvent;
		protected var _eOnMotionChanged : TweenEvent;
		protected var _eOnMotionFinished : TweenEvent;
		
		//-------------------------------------------------------------------------
		// Private implementation
		//-------------------------------------------------------------------------
		
		public function AbstractTween( o : AbstractTweenConstructorAccess, 
									   oT : Object, 
									   sP : String, 
									   nE : Number, 
									   nRate : Number, 
									   nS : Number = NaN, 
									   fE : Function = null,
									   gP : String = null )
		{
			super ( abstractSyncCommandConstructorAccess );
			
			if( !ClassUtils.isImplementedAll( this, "com.bourre.transitions:AbstractTween", "isMotionFinished", "onUpdate" ) )
			{
				PixlibDebug.ERROR ( this + " have to implements virtual methods : isMotionFinished & onUpdate" );
				throw new UnimplementedVirtualMethodException ( this + " have to implements virtual methods : isMotionFinished & onUpdate" );
			}
			
			_buildAccessor( oT, sP, gP, nS );
			
			_bP = false;
			_nRE = nE;
			_nRate = nRate;
			setEasing(fE);
			
			_eOnStart = new TweenEvent ( TweenEvent.onStartEVENT, this );
			_eOnStop = new TweenEvent ( TweenEvent.onStopEVENT, this );
			_eOnMotionChanged = new TweenEvent ( TweenEvent.onMotionChangedEVENT, this );
			_eOnMotionFinished = new TweenEvent ( TweenEvent.onMotionFinishedEVENT, this );
		}
		
		public static function noEasing( t : Number,  b : Number,  c : Number, d : Number ) : Number 
		{
			return c * t / d + b;
		}
		
		public function onEnterFrame( e : Event = null ) : void
		{
			if ( isMotionFinished() )
			{
				_onMotionEnd();
			} 
			else
			{
				onUpdate();
			}
		}
		
		public function isMotionFinished () : Boolean
		{	
			return false;
		}
		
		public function onUpdate () : void
		{
			_oEB.broadcastEvent( _eOnMotionChanged );	
		}
		
		public function setEasing( f : Function ) : void
		{
			_fE = ( f != null ) ?  f : AbstractTween.noEasing;
		}
		
		public function getEasing() : Function
		{
			return _fE;
		}
		
		public function getDuration() : Number
		{
			return _nRate;
		}
		
		public function start() : void
		{
			execute();
			_oEB.broadcastEvent( _eOnStart );
		}
		
		public function yoyo() : void
		{
			stop();
			
			setEndValue( _nRS );
			setStartValue( _oSetter.getValue() );
			
			start();
		}
		
		public function stop() : void
		{
			_oBeacon.removeFrameListener(this);
			_bP = false;
			_oEB.broadcastEvent( _eOnStop );
		}
		
		public function resume() : void
		{
			_bP = true;
			_oBeacon.addFrameListener(this);
			
		}
		
		public override function execute( e : Event = null ) : void
		{
			if ( isNaN(_nRS) ) 
			{
				PixlibDebug.FATAL( this + " has no start value." );
				
			} else
			{
				_nS = _nRS;
				_oSetter.setValue( _nS );
				_nE = _nRE;
				_bP = true;
				_oBeacon.addFrameListener(this);
			}
		}
		
		public function getTarget() : Object
		{
			return _oSetter.getTarget();
		}
		
		public function setTarget( o : Object ) : void
		{
			if ( isPlaying() )
			{
				PixlibDebug.WARN( this + ".setTarget() invalid call while playing." );
			} else
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
			if ( isPlaying() )
			{
				PixlibDebug.WARN( this + ".setProperty() invalid call while playing." );
			} else
			{
				var target : Object = _oSetter.getTarget();
				_buildAccessor( target, p,  target[p] );
			}
		}		
		
		public function setStartValue( n : Number ) : void
		{
			_nRS = n;
		}
		
		public function getStartValue () : Number
		{
			return _nRS;
		}
		
		public function setEndValue( n : Number ) : void
		{
			_nRE = n;
		}
		
		public function getEndValue () : Number
		{
			return _nRE;
		}
		
		public function isPlaying() : Boolean
		{
			return _bP;	
		}
		
		public override function toString() : String 
		{
			return PixlibStringifier.stringify( this );
		}

		public function setDuration( n : Number ) : void
		{
			_nRate = n;
		}
		
		public function addListener( listener : TweenListener ) : Boolean
		{
			return _oEB.addListener( listener );
		}

		public function removeListener( listener : TweenListener ) : Boolean
		{
			return _oEB.removeListener( listener );
		}
		
		public function addEventListener( type : String, listener : Object, ...rest ) : Boolean
		{
			return _oEB.addEventListener.apply( _oEB, [type, listener, rest] );
		}
		
		public function removeEventListener( type : String, listener : Object ) : Boolean
		{
			return _oEB.removeEventListener( type, listener );
		}
		
		
		//-------------------------------------------------------------------------
		// Private implementation
		//-------------------------------------------------------------------------
		
		protected function _buildAccessor( o : Object, sP : String, gP : String = null, nS : Number = NaN ) : void
		{
			_oSetter = AccessorFactory.getAccessor( o, sP, gP );
			if (!isNaN(nS)) _nRS = nS;
			else _nRS = _oSetter.getValue();
		}
		
		protected function _onMotionEnd() : void
		{
			_bP = false;
			_oBeacon.removeFrameListener( this );
			_oSetter.setValue( _nE );
			
			onUpdate();
			fireCommandEndEvent();
			_oEB.broadcastEvent( _eOnMotionFinished );
		}
	}
}

internal class AbstractTweenConstructorAccess {}