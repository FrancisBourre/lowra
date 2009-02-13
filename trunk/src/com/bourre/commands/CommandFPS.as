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
package com.bourre.commands 
{
	import com.bourre.log.PixlibStringifier;
	import com.bourre.transitions.FPSBeacon;
	import com.bourre.transitions.TickListener;
	
	import flash.events.Event;	

	/**
	 * The CommandFPS class manages a Commands list to execute 
	 * on each frame (FPS).
	 * 
	 * @author 	Francis Bourre
	 * 
	 * @see CommandManagerFPS
	 */
	public class CommandFPS	implements TickListener
	{
		/** @private */
		protected var _oT : Object;
			
		/** @private */
		protected var _oS : Object;
		
		/** @private */
		protected var _nID : Number;
		
		/** @private */
		protected var _nL : Number;
		
		/**
		 * Creates new <code>ComandFPS</code> instance.
		 */
		public function CommandFPS()
		{
			_oT = new Object();
			_oS = new Object();
			_nID = 0;
			_nL = 0;
			
			FPSBeacon.getInstance().addTickListener(this);
		}
		
		/**
		 * @inheritDoc
		 */
		public function onTick( e : Event = null ) : void
		{
			for (var s:String in _oT) _oT[s].execute();
		}
		
		/**
		 * Adds passed-in command to execution list and execute it now.
		 * 
		 * <p>An identifier name is automatically build</p>
		 * 
		 * @param	oC	Command to add
		 * 
		 * @return The command identifier name in list
		 * 
		 * @see #pushWithName()
		 */
		public function push(oC:Command) : String
		{
			return _push( oC, _getNameID() );
		}
		
		/**
		 * Adds passed-in command to execution list and executes it now.
		 * 
		 * @param	oC	Command to add		 * @param	sN	Command identifier
		 * 
		 * @return The command identifier name in list
		 */
		public function pushWithName(oC:Command, sN:String = null) : String
		{
			sN = (sN == null) ? _getNameID() : sN;
			return _push(oC, sN);
		}
		
		/**
		 * Stores passed-in command and wait for 
		 * a loop before executes it.<br />
		 * Command is removed after execution.
		 * 
		 * <p>An identifier name is automatically build</p>
		 * 
		 * @param	oC	Command to delayed
		 * 
		 * @return The command identifier name in list
		 */
		public function delay(oC:Command) : String
		{
			var sN:String = _getNameID();
			var d:Delegate = new Delegate( _delay, oC, sN);
			_oT[sN] = d;
			return sN;
		}
		
		/**
		 * Removes passed-in command from execution list.
		 * 
		 * @param	oC	Command to remove
		 * 
		 * @return <code>true</code> if command is removed
		 */
		public function remove(oC:Command) : Boolean
	  	{
			for(var s:String in _oT) if (_oT[s] == oC) return _remove(s);
			return false;
	  	}
		
		/**
		 * Removes command registered with passed-in name from 
		 * execution list.
		 * 
		 * @param	name	Name of the command remove
		 * 
		 * @return <code>true</code> if command is removed
		 * 
		 * @see #push()
		 * @see #pushWithName()
		 * @see #delay()
		 */
		public function removeWithName(sN:String) : Boolean
		{
			return _oT.hasOwnProperty(sN) ? _remove(sN) : false;
		}
		
		/**
		 * Excludes passed-in command from execution list.
		 * 
		 * <p>Command still in buffer, use <code>resume()</code> to 
		 * replace command in execution list.</p>
		 * 
		 * @param	oC	Command to exclude form execution list.
		 */
		public function stop(oC:Command) : Boolean
		{
			for (var s:String in _oT) if (_oT[s] == oC) return _stop(s);
			return false;
		}
		
		/**
		 * Excludes command registered with passed-in name 
		 * from execution list.
		 * 
		 * <p>Command still in buffer, use <code>resumeWithName()</code> to 
		 * replace command in execution list.</p>
		 * 
		 * @param	sN	Command identifier
		 */
		public function stopWithName(sN:String) : Boolean
		{
			return (_oT.hasOwnProperty(sN)) ? _stop(sN) : false;
		}
		
		/**
		 * Submits passed-in command into execution list.
		 * 
		 * @param	oC	Command to submit to execution list.
		 */
		public function resume(oC:Command) : Boolean
		{
			for (var s:String in _oS) if (_oS[s] == oC) return _resume(s);
			return false;
		}
		
		/**
		 * Submits command registered with passed-in name 
		 * into execution list.
		 * 
		 * @param	sN	Command identifier
		 */
		public function resumeWithName(sN:String) : Boolean
		{
			return (_oS.hasOwnProperty(sN)) ? _resume(sN) : false;
		}
		
		/**
		 * Returns execution list length.
		 * 
		 * @return The execution list length.
		 */
		public function getLength() : Number
		{
			return _nL;
		}
		
		/**
		 * Removes all objects from execution list and from buffer.
		 */
		public function removeAll() : void
		{
			_oT = new Object();
			_oS = new Object();
			_nL = 0;
		}
		
		/**
		 * Returns string representation of instance.
		 * 
		 * @return The string representation of instance.
		 */
		public function toString() : String 
		{
			return PixlibStringifier.stringify( this );
		}
		
		/**
		 * Registers passed-in command with passed-in name.
		 * 
		 * @param	oC	Command to push
		 * @param	sN	Command identifier
		 */
		protected function _push(oC:Command, sN:String) : String
		{
			if( _oT.hasOwnProperty( sN ) )
			{
				_oT[sN] = oC;
			}
			else
			{
				_oT[sN] = oC;
				_nL++;
			}
			
			oC.execute();
			return sN;
		}
		
		/**
		 * Returns a unique identifier.
		 */
		protected function _getNameID() : String
		{
			while (_oT.hasOwnProperty('_C_' + _nID)) _nID++;
			return '_C_' + _nID;
		}
		
		/**
		 * Removes command registered with passed-in identifier.
		 * 
		 * @param	s	 Command identifier
		 */
		protected function _remove(s:String) : Boolean
		{
			delete _oT[s];
			_nL--;
			return true;
		}
		
		/**
		 * Excludes command registered with passed-in identifier 
		 * from execution list.
		 * 
		 * @param	s	 Command identifier
		 */
		protected function _stop(s:String) : Boolean
		{
			_oS[s] = _oT[s];
			delete _oT[s];
			return true;
		}
		
		/**
		 * Adds command registered with passed-in identifier into 
		 * execution list.
		 * 
		 * @param	s	 Command identifier
		 */
		protected function _resume(s:String) : Boolean
		{
			var oC:Command = _oS[s];
			delete _oS[s];
			oC.execute();
			_oT[s] = oC;
			return true;
		}
		
		/**
		 * Executes a delay call.
		 * 
		 * @param	oC	Command to execute
		 * @param	sN	Command identifier
		 */
		protected function _delay(oC:Command, sN:String) : void
		{
			removeWithName(sN);
			oC.execute();
		}
	}
}