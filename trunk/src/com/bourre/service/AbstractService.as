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
 
package com.bourre.service 
{
	import com.bourre.collection.Collection;
	import com.bourre.commands.ASyncCommandListener;
	import com.bourre.commands.AbstractCommand;
	import com.bourre.commands.AbstractSyncCommand;
	import com.bourre.events.BasicEvent;
	import com.bourre.events.EventBroadcaster;	

	/**
	 * The AbstractService class implements basic Service interface.
	 * 
	 * @author 	Francis Bourre
	 */
	public class AbstractService 
		extends AbstractCommand implements Service
	{
		/** @private */
		protected var _oEB 		: EventBroadcaster;
		
		/** @private */
		protected var _args 	: Array;
		
		/** @private */
		protected var _result 	: Object;
		
		/**
		 * Creates new <code>AbstractService</code> instance.
		 */
		public function AbstractService() 
		{
			_oEB = new EventBroadcaster( this );
		}
		
		/**
		 * @inheritDoc
		 */
		public function setResult( result : Object ) : void
		{
			_result = result;
		}
		
		/**
		 * @inheritDoc
		 */
		public function getResult() : Object
		{
			return _result;
		}
		
		/**
		 * @inheritDoc
		 */
		public function addServiceListener( listener : ServiceListener ) : Boolean
		{
			return _oEB.addListener( listener );
		}
		
		/**
		 * @inheritDoc
		 */
		public function removeServiceListener( listener : ServiceListener ) : Boolean
		{
			return _oEB.removeListener( listener );
		}
		
		/**
		 * @inheritDoc
		 */
		public function getServiceListener() : Collection
		{
			return _oEB.getListenerCollection();
		}
		
		/**
		 * @inheritDoc
		 */
		public function setArguments(...rest) : void
		{
			_args = rest.concat();
		}
		
		/**
		 * @inheritDoc
		 */
		public function getArguments() : Object
		{
			return _args;
		}
		
		/**
		 * @inheritDoc
		 */
		public function fireResult() : void
		{
			_oEB.broadcastEvent( new ServiceEvent( ServiceEvent.onDataResultEVENT, this ) );
		}
		
		/**
		 * @inheritDoc
		 */
		public function fireError() : void
		{
			_oEB.broadcastEvent( new ServiceEvent( ServiceEvent.onDataErrorEVENT, this ) );
		}
		
		/**
		 * @inheritDoc
		 */
		public function addASyncCommandListener( listener : ASyncCommandListener, ...rest ) : Boolean
		{
			var type : String =  AbstractSyncCommand.onCommandEndEVENT;
			return _oEB.addEventListener.apply( _oEB, rest.length > 0 ? [ type, listener ].concat( rest ) : [ type, listener ] );
		}
		
		/**
		 * @inheritDoc
		 */
		public function removeASyncCommandListener( listener : ASyncCommandListener ) : Boolean
		{
			return _oEB.removeEventListener( AbstractSyncCommand.onCommandEndEVENT, listener ); 
		}
		
		/**
		 * @inheritDoc
		 */
		public function fireCommandEndEvent() : void
		{
			_oEB.broadcastEvent( new BasicEvent(  AbstractSyncCommand.onCommandEndEVENT, this ) );
		}
		
		/**
		 * @inheritDoc
		 */
		public function release() : void
		{
			_oEB.removeAllListeners( );
			_args = null;
			_result = null;
		}
			
		/**
		 * @inheritDoc
		 */
		public function run () : void
		{
		}
		
		/**
		 * @inheritDoc
		 */
		public function isRunning () : Boolean
		{
			return false;
		}
		
		/**
		 * @inheritDoc
		 */
		public function addEventListener( type : String, listener : Object, ... rest ) : Boolean
		{
			return _oEB.addEventListener.apply( _oEB, rest.length > 0 ? [ type, listener ].concat( rest ) : [ type, listener ] );
		}
		
		/**
		 * @inheritDoc
		 */
		public function removeEventListener( type : String, listener : Object ) : Boolean
		{
			return _oEB.removeEventListener( type, listener );
		}	}}