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
	
	import flash.utils.clearInterval;
	import flash.utils.setInterval;

	/**
	 * The CommandMS class manages a Commands list to execute 
	 * on using timer tick.
	 * 
	 * @author 	Francis Bourre
	 * 
	 * @see CommandManagerMS
	 */
	public class CommandMS
	{
		/** @private */
		protected var _oT:Object;
		
		/** @private */
		protected var _nID:Number;
		
		/** @private */
		protected var _nL : Number;
		
		/** @private */
		protected static var _EXT:String = '_C_';
		
		/**
		 * Creates new <code>CommandMS</code> instance.
		 */
		public function CommandMS()
		{
			_oT = new Object();
			_nID = 0;
			_nL = 0;
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
		public function push(oC:Command, nMs:Number) : String
		{
			var sN:String = _getNameID();
			if (_oT.hasOwnProperty(sN)) _remove(sN);
			
			return _push( oC, nMs, sN );
		}
		
		/**
		 * Adds passed-in command to execution list and executes it now.
		 * 
		 * @param	oC	Command to add		 * @param	nMs	Command execution timer
		 * @param	sN	Command identifier
		 * 
		 * @return The command identifier name in list
		 */
		public function pushWithName(oC:Command, nMs:Number, sN:String=null) : String
		{
			if (sN == null) 
			{
				sN =_getNameID();
			} 
			else if (_oT.hasOwnProperty(sN)) 
			{
				_remove(sN);
			}
			
			return _push( oC, nMs, sN );
		}
		
		/**
		 * Stores passed-in command and wait for 
		 * passed-in timer before executes it.<br />
		 * Command is removed after execution.
		 * 
		 * <p>An identifier name is automatically build</p>
		 * 
		 * @param	oC	Command to delayed		 * @param	nMs	Command execution timer
		 * 
		 * @return The command identifier name in list
		 */
		public function delay(oC:Command, nMs:Number) : String
		{
			var sN:String = _getNameID();
			var o:Object = _oT[sN] = new Object();
			o.cmd = oC;
			o.ID = setInterval( _delay, nMs, sN);
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
			for (var s:String in _oT) if (_oT[s].cmd == oC) return _remove(s);
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
			return (_oT.hasOwnProperty(sN)) ? _remove(sN) : false;
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
			for (var s:String in _oT) if (_oT[s].cmd == oC) return _stop(s);
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
			for (var s:String in _oT) if (_oT[s].cmd == oC) return _notify(s);
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
			return (_oT.hasOwnProperty(sN)) ? _notify(sN) : false;
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
			for (var s:String in _oT) _remove(s);
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
		 * @param	nMs	Command execution timer
		 * @param	sN	Command identifier
		 */
		protected function _push(oC:Command, nMs:Number, sN:String) : String
		{
			var o:Object = new Object();
			o.cmd = oC;
			o.ms = nMs;
			o.ID = setInterval( oC.execute , nMs);
			_oT[sN] = o;
			_nL++;
			
			oC.execute();
			
			return sN;
		}
		
		/**
		 * Returns a unique identifier.
		 */
		protected function _getNameID() : String
		{
			while (_oT.hasOwnProperty(CommandMS._EXT + _nID)) _nID++;
			return CommandMS._EXT + _nID;
		}
		
		protected function _remove(s:String) : Boolean
		{
			clearInterval(_oT[s].ID);
			delete _oT[s];
			_nL--;
			return true;
		}
		
		/**
		 * Removes command registered with passed-in identifier.
		 * 
		 * @param	s	 Command identifier
		 */
		protected function _stop(s:String) : Boolean
		{
			clearInterval(_oT[s].ID);
			return true;
		}
		
		/**
		 * Adds command registered with passed-in identifier into 
		 * execution list.
		 * 
		 * @param	s	 Command identifier
		 */
		protected function _notify(s:String) : Boolean
		{
			_oT[s].ID = setInterval( Command(_oT[s].cmd).execute, _oT[s].ms);
			return true;
		}
		
		/**
		 * Executes a delay call.
		 * 
		 * @param	oC	Command to execute
		 * @param	sN	Command identifier
		 */
		protected function _delay(sN:String) : void
		{
			var o:Object = _oT[sN];
			clearInterval(o.ID);
			o.cmd.execute();
			delete _oT[sN];
		}
	}
}