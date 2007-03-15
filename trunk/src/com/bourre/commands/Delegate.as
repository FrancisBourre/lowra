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

/**
 * @author Francis Bourre
 * @version 1.0
 */

package com.bourre.commands
{
	import com.bourre.log.*;
	import com.bourre.transitions.FrameListener;
	
	import flash.events.Event;
	import flash.utils.getQualifiedClassName;
	
	public class Delegate 
		implements Command, FrameListener
	{
		private var _f : Function;
		private var _a : Array;
		
		public static function create( scope : Object, method : Function ) : Function 
		{
			var f : * = function() : *
			{    
				var o : * = arguments.callee ;
				var s : Object = o.s ;
				var m : Function = o.m ;
				var a : Array = arguments.concat(o.a) ;
				return m.apply(s, a) ;
			};
				
			f.s = scope ;
			f.m = method ;
			f.a = arguments.splice(2);
			return f;
		} 
		
		public function Delegate( f : Function, ... rest )
		{
			_f = f;
			_a = rest;
		}
		
		public function getArguments() : Array
		{
			return _a;
		}

		public function setArguments( ... rest ) : void
		{
			if ( rest.length > 0 ) _a = rest;
		}
		
		public function setArgumentsArray( a : Array ) : void
		{
			if ( a.length > 0 ) _a = a;
		}

		public function addArguments( ... rest ) : void
		{
			if ( rest.length > 0 ) _a = _a.concat( rest );
		}
		
		public function addArgumentsArray( a : Array ) : void
		{
			if ( a.length > 0 ) _a = _a.concat( a );
		}

		public function execute( e : Event = null ) : void
		{
			_f.apply( null, _a );
		}
		
		public function onEnterFrame( e : Event = null ) : void
		{
			execute( e );
		}
		
		public function handleEvent( e : Event ) : void
		{
			try
			{
				_f.apply( null, _a.length>0?[e].concat(_a):[e] );
				
			}catch( err : Error )
			{

				var msg : String;
				msg = "Delegate.handleEvent() failed, incorrect number of arguments passed";
				PixlibDebug.ERROR( msg );
				throw( new ArgumentError( msg ) );
			}
		}
		
		/**
		 * Returns the string representation of this instance.
		 * @return the string representation of this instance
		 */
		public function toString() : String 
		{
			return PixlibStringifier.stringify( this );
		}
	}
}