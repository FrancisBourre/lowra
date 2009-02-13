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
package com.bourre.log 
{
	import com.bourre.error.PrivateConstructorException;
	import com.bourre.events.ChannelBroadcaster;
	import com.bourre.events.EventChannel;	
	
	/**
	 *  Dispatched when a log message is sent.
	 *  
	 *  @eventType com.bourre.log.LogEvent.onLogEVENT
	 */
	[Event(name="onLog", type="com.bourre.log.LogEvent.onLogEVENT")]
	
	/**
	 * The Logger class allow to dispatch log message tl all registered 
	 * Log listeners, in dedicated, or all logging channel.
	 * 
	 * <p>Log level can be also apply to filter logging message.</p>
	 * 
	 * @example
	 * <pre class="prettyprint">
	 * 
	 * //filter level
	 * Logger.getInstance().setLevel( LogLevel.INFO );
	 * 
	 * //Add log listener
	 * Logget.getInstance().addLogListener( SOSLayout.getIntance() );
	 * 
	 * Logger.INFO( "this is a information message" ); //sent to all listeners
	 * Logger.DEBUG( "this is a debug message" ); //Not sent cause of level filter
	 * </pre>
	 * 
	 * @see	LogListener
	 * 
	 * @author Francis Bourre
	 */
	public class Logger
	{
		//--------------------------------------------------------------------
		// Private properties
		//--------------------------------------------------------------------
		
		private static var _oI : Logger = null;
		
		private var _oCB : ChannelBroadcaster;
		private var _oLevel : LogLevel;
		
		
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
		
		/**
		 * Returns unique Logger instance.
		 * 
		 * @return Unique Logger instance.
		 */	
		public static function getInstance() : Logger
		{
			if ( !(Logger._oI is Logger) ) Logger._oI = new Logger( new ConstructorAccess() );
			return Logger._oI;
		}
		
		/**
		 * Sets logging level.
		 * 
		 * @example
		 * <pre class="prettyprint">
		 * 
		 * Logger.getInstance().setLevel( LogLevel.INFO );
		 * </pre>
		 * 
		 * @param	level	LogLevel filter to apply.<br />
		 * 					Possible values are :
		 * 					<ul>
		 * 						<li>LogLevel.ALL</li>		 * 						<li>LogLevel.DEBUG</li>		 * 						<li>LogLevel.WARN</li>		 * 						<li>LogLevel.ERROR</li>		 * 						<li>LogLevel.FATAL</li>		 * 						<li>LogLevel.OFF</li>
		 * 					</ul>
		 * 					
		 * 	@see	LogLevel
		 */
		public function setLevel( level : LogLevel ) : void
		{
			_oLevel = level;
		}
		
		/**
		 * Returns current LogLevel filter used.
		 * 
		 * @return Current LogLevel filter used.
		 */
		public function getLevel() : LogLevel
		{
			return _oLevel;
		}
		
		/**
		 * Braodcasts passed-in <code>e</code> LogEvent in 
		 * <code>oChannel</code> channel.
		 * 
		 * @example
		 * <pre class="prettyprint">
		 * 
		 * var evt : LogEvent = new LogEvent( LogLevel.INFO, "my message" );
		 * 
		 * Logger.getInstance().log( evt, PixlibDebug.CHANNEL );
		 * </pre>
		 * @param	e			LogEvent instance with logging message information.
		 * @param	oChannel	(optional) Event channel to use.<br />
		 * 						If not defined or <code>null</code>, event is 
		 * 						dispatched to all logger listeners.
		 * 	
		 * 	@return	<code>true</code> if success. ( Log level compliant )
		 */
		public function log( e : LogEvent, oChannel : EventChannel = null ) : Boolean
		{	
			if ( e.level.getLevel() >= _oLevel.getLevel() ) 
			{
				if( oChannel != null ) e.channel = oChannel.toString();
				
				_oCB.broadcastEvent( e, oChannel );
				return true;
			} else
			{
				return false;
			}
		}
		
		/**
		 * Adds an event listener for the specified event type of the
		 * specified channel. There is two behaviors for the 
		 * <code>addEventListener</code> function : 
		 * <ol>
		 * <li>The passed-in listener is an object : 
		 * The object is added as listener only for the specified event, the object
		 * must have a function with the same name than <code>type</code> or at least
		 * a <code>handleEvent</code> function.</li>
		 * <li>The passed-in listener is a function : 
		 * A <code>Delegate</code> object is created and then
		 * added as listener for the event type . There is no restriction on the name
		 * of the function.
		 * </ol>
		 * 
		 * @param 	type		name of the event for which register the listener
		 * @param 	listener	object or function which will receive this event
		 * @param	channel		event channel for which the listener listen
		 * @return	<code>true</code> if the function have been succesfully added as
		 * 			listener fot the passed-in event
		 * @throws 	<code>UnsupportedOperationException</code> — If the listener is an object
		 * 			which have neither a function with the same name than the event type nor
		 * 			a function called <code>handleEvent</code>
		 * @see		Broadcaster#addEventListener()
		 */
		public function addLogListener( listener : LogListener, oChannel : EventChannel = null ) : void
		{
			_oCB.addEventListener( LogEvent.onLogEVENT, listener, oChannel );
		}
		
		/**
		 * Removes the passed-in listener for listening the specified event of
		 * the specified channel. The listener could be either an object or a function.
		 * 
		 * @param 	type		name of the event for which unregister the listener
		 * @param 	listener	object or function to be unregistered
		 * @param	channel		event channel on which unregister the listener
		 * @return	<code>true</code> if the listener have been successfully removed
		 * 			as listener for the passed-in event
		 * 	@see	Broadcaster#removeEventListener()
		 */
		public function removeLogListener( listener : LogListener, oChannel : EventChannel = null ) : void
		{
			_oCB.removeEventListener( LogEvent.onLogEVENT, listener, oChannel );
		}
		
		/**
		 * Returns <code>true</code> if the passed-in <code>listener</code>
		 * is registered as listener for the passed-in event <code>type</code>
		 * in the passed-in <code>channel</code>.
		 * 
		 * @param	listener	LogListener to look for registration
		 * @param	type		event type to look at
		 * @param	channel		channel onto which look at
		 * @return	<code>true</code> if the passed-in <code>listener</code>
		 * 			is registered as listener for the passed-in event
		 * 			<code>type</code> in the passed-in <code>channel</code>
		 * @see		Broadcaster#isRegistered()
		 */
		public function isRegistered( listener : LogListener, oChannel : EventChannel ) : Boolean
		{
			return _oCB.isRegistered( listener, LogEvent.onLogEVENT, oChannel );
		}
		
		/**
		 * Returns <code>true</code> if there is a <code>Broadcaster</code> instance
		 * registered for the passed-in channel, and if this broadcaster has registered
		 * listeners.
		 * 
		 * @param	type		event type to look at
		 * @param	channel		channel onto which look at
		 * @return	<code>true</code> if there is a <code>Broadcaster</code>
		 * 			instance registered for the passed-in channel, and if this
		 * 			broadcaster has registered listeners
		 */
		public function hasListener( oChannel : EventChannel = null ) : Boolean
		{
			return _oCB.hasChannelListener( LogEvent.onLogEVENT, oChannel );
		}
		
		/**
		 * Removes all listeners object from this event
		 * channel broadcaster. The object is removed as listener
		 * for all events the broadcaster may dispatch on this
		 * channel.
		 */ 
		public function removeAllListeners() : void
		{
			_oCB.empty();
		}
		
		/**
		 * Returns the string representation of this instance.
		 * 
		 * @return the string representation of this instance
		 */
		public function toString() : String 
		{
			return PixlibStringifier.stringify( this );
		}
		
		/**
		 * @see #log()
		 */
		public static function LOG( o : *, level : LogLevel, oChannel : EventChannel = null ) : Boolean
		{
			return Logger.getInstance().log( new LogEvent(level, o ), oChannel );
		}
		
		/**
		 * Logs passed-in <code>o</code> message into <code>oChannel</code> logging 
		 * channel using <code>LogLevel.DEBUG</code> level filter.
		 * 
		 * @param	o			Message to log
		 * @param	oChannel	(optional) Event channel to use.<br />
		 * 						If not defined or <code>null</code>, event is 
		 * 						dispatched to all logger listeners.	
		 * 						
		 * 	@return	<code>true</code> if success. ( Log level compliant )
		 */
		public static function DEBUG( o : *, oChannel : EventChannel = null ) : Boolean
		{
			return Logger.LOG( o, LogLevel.DEBUG, oChannel  );
		}
		
		/**
		 * Logs passed-in <code>o</code> message into <code>oChannel</code> logging 
		 * channel using <code>LogLevel.INFO</code> level filter.
		 * 
		 * @param	o			Message to log
		 * @param	oChannel	(optional) Event channel to use.<br />
		 * 						If not defined or <code>null</code>, event is 
		 * 						dispatched to all logger listeners.	
		 * 						
		 * 	@return	<code>true</code> if success. ( Log level compliant )
		 */
		public static function INFO( o : *, oChannel : EventChannel = null ) : Boolean
		{
			return Logger.LOG( o, LogLevel.INFO, oChannel  );
		}
		
		/**
		 * Logs passed-in <code>o</code> message into <code>oChannel</code> logging 
		 * channel using <code>LogLevel.WARN</code> level filter.
		 * 
		 * @param	o			Message to log
		 * @param	oChannel	(optional) Event channel to use.<br />
		 * 						If not defined or <code>null</code>, event is 
		 * 						dispatched to all logger listeners.	
		 * 						
		 * 	@return	<code>true</code> if success. ( Log level compliant )
		 */
		public static function WARN( o : *, oChannel : EventChannel = null ) : Boolean
		{
			return Logger.LOG( o, LogLevel.WARN, oChannel );
		}
		
		/**
		 * Logs passed-in <code>o</code> message into <code>oChannel</code> logging 
		 * channel using <code>LogLevel.ERROR</code> level filter.
		 * 
		 * @param	o			Message to log
		 * @param	oChannel	(optional) Event channel to use.<br />
		 * 						If not defined or <code>null</code>, event is 
		 * 						dispatched to all logger listeners.	
		 * 						
		 * 	@return	<code>true</code> if success. ( Log level compliant )
		 */
		public static function ERROR( o : *, oChannel : EventChannel = null ) : Boolean
		{
			return Logger.LOG( o, LogLevel.ERROR, oChannel );
		}
		
		/**
		 * Logs passed-in <code>o</code> message into <code>oChannel</code> logging 
		 * channel using <code>LogLevel.FATAL</code> level filter.
		 * 
		 * @param	o			Message to log
		 * @param	oChannel	(optional) Event channel to use.<br />
		 * 						If not defined or <code>null</code>, event is 
		 * 						dispatched to all logger listeners.	
		 * 						
		 * 	@return	<code>true</code> if success. ( Log level compliant )
		 */
		public static function FATAL( o : *, oChannel : EventChannel = null ) : Boolean
		{
			return Logger.LOG( o, LogLevel.FATAL, oChannel );
		}
		
		
		//--------------------------------------------------------------------
		// Private implementation
		//--------------------------------------------------------------------
		
		/** @private */
		function Logger( access : ConstructorAccess )
		{
			if ( !(access is ConstructorAccess) ) throw new PrivateConstructorException();
			
			setLevel( LogLevel.ALL );
			_oCB = new ChannelBroadcaster();
		}		
	}
}

internal class ConstructorAccess {}