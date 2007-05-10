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
	
	public class AbstractDataServiceConnector 
		implements DataServiceConnector
	{
		private var _url 		: String ;
		private var _oService	: DataService ;
		private var _oEB 		: EventBroadcaster ;
		private var _oEBasync 	: EventBroadcaster ;
		
		public function AbstractDataServiceConnector()
		{
			_oEB = new EventBroadcaster(this) ;
		}
		
		public function setURL( url : String ) : void
		{
			_url = url ;
		}
		
		public function fireEvent( e : Event ) : void
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
		
		public function request( e : DataServiceEvent ) : void
		{
			var msg : String = this + ".request() must be implemented in concrete class.";
			PixlibDebug.ERROR( msg );
			throw( new UnimplementedVirtualMethodException( msg ) );
		}
		
		public function release():void 
		{
			var msg : String = this + ".release() must be implemented in concrete class.";
			PixlibDebug.ERROR( msg );
			throw( new UnimplementedVirtualMethodException( msg ) );
		}
		
		public function execute( e : Event = null ) : void
		{
			request(e as DataServiceEvent) ;
		}
		
		public function addASyncCommandListener( listener : ASyncCommandListener ) : Boolean
		{
			return _oEBasync.addListener( listener );
		}

		public function removeASyncCommandListener( listener : ASyncCommandListener ) : Boolean
		{
			return _oEBasync.removeListener( listener );
		}

		public function fireCommandEndEvent() : void
		{
			_oEBasync.broadcastEvent(new ASyncCommandEvent(ASyncCommandEvent.onCommandEndEVENT, this)) ;
		}
	}
}