package com.bourre.request
{
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

	import com.bourre.events.EventBroadcaster;
	import flash.events.Event;
	import com.bourre.log.*;
	import com.bourre.commands.ASyncCommandListener;
	import com.bourre.commands.ASyncCommandEvent;
	import com.bourre.commands.AbstractSyncCommand;
	import com.bourre.error.UnimplementedVirtualMethodException;
	import com.bourre.collection.Collection;
	
	public class AbstractDataServiceConnector 
		implements DataServiceConnector
	{
		protected var _url 		: String ;
		protected var _port 	: uint ;
		private var _queue		: Array ;
		private var _hasRequestRunning : Boolean;
		
		private var _oEB 		: EventBroadcaster ;
		private var _oEBasync 	: EventBroadcaster ;
		
		public function AbstractDataServiceConnector(url : String)
		{
			setURL( url )
			_oEB = new EventBroadcaster(this) ;
			_oEBasync = new EventBroadcaster(this) ;
			this._queue = new Array()
			_hasRequestRunning = false
		}
		
		public function setURL( url : String ) : void
		{
			var tab:Array = url.split(":");
			_url = tab[0];
			_port = parseInt(tab[1]);
			//_port = (isNaN(_port))? 80 : _port;
		}
		
		public function fireEvent( e : DataServiceEvent ) : void
		{
			_oEB.broadcastEvent( e );
		}
		
		public function addServiceListener( listener : DataServiceListener ) : Boolean
		{
			return _oEB.addListener( listener );
		}
		
		public function removeServiceRequestListener( listener : DataServiceListener ) : Boolean
		{
			return _oEB.removeListener( listener );
		}
		protected function doRequest(e : DataService):void
		{
			var msg : String = this + ".doRequest() must be implemented in concrete class.";
			PixlibDebug.ERROR( msg );
			throw( new UnimplementedVirtualMethodException( msg ) );
		}
		
		public function request( e : DataService ) : void
		{
			store(e);
			if ( !_hasRequestRunning )
			{
				_hasRequestRunning = true;
				doRequest(this.unstore());
			}
		}
		
		public function release():void 
		{
			var msg : String = this + ".release() must be implemented in concrete class.";
			PixlibDebug.ERROR( msg );
			throw( new UnimplementedVirtualMethodException( msg ) );
		}
		
		public function execute( e : Event = null ) : void
		{
			request((e as DataServiceEvent).getDataService()) ;
		}
		
		public function addASyncCommandListener( listener : ASyncCommandListener, ...rest ) : Boolean
		{
			return _oEBasync.addEventListener.apply( _oEBasync, rest.length > 0 ? 
												[ ASyncCommandEvent.onCommandEndEVENT, listener ].concat( rest )
												: [ ASyncCommandEvent.onCommandEndEVENT, listener ] );
		}

		public function removeASyncCommandListener( listener : ASyncCommandListener ) : Boolean
		{
			return _oEBasync.removeEventListener( ASyncCommandEvent.onCommandEndEVENT, listener );
		}

		public function fireCommandEndEvent() : void
		{
			_oEBasync.broadcastEvent(new ASyncCommandEvent(ASyncCommandEvent.onCommandEndEVENT, this)) ;
		}
		
		protected function doNextRequest() : void
		{
			
			if( hasRequest())
			{
				doRequest( unstore())
			}
			else
			{
				_hasRequestRunning = false;
			}
		}
		
		public function store ( dre : DataService ) : void
		{
			_queue.push(dre) ;
		}
		
		public function hasRequest():Boolean
		{
		 	return _queue.length > 0 ;
		}
		
		
		public function unstore() : DataService
		{
			if(hasRequest())
				return _queue.shift() as DataService ;
			else 
				return null
		}
		
		/**
		 
		 * */
		public function onDataResult( event : DataServiceEvent) : void
		{
			doNextRequest()
		}
		
		public function onDataError( event : DataServiceEvent) : void
		{
			doNextRequest()
		}
	}
}