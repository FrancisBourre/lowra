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
	
	public class AbstractDataRequest 
		extends AbstractSyncCommand
		implements DataRequest
	{
		protected var _oResult : Object;
		private var _eResult : DataRequestEvent;
		private var _eError : DataRequestEvent;
		
		public function AbstractDataRequest() 
		{
			_eResult = new DataRequestEvent( DataRequestEvent.onDataResultEVENT, this );
			_eError = new DataRequestEvent( DataRequestEvent.onDataErrorEVENT, this );
		}
		
		public function getResult() : Object
		{
			return _oResult;
		}
		
		public function addDataRequestListener( listener : DataRequestListener ) : Boolean
		{
			return _oEB.addListener( listener );
		}
		
		public function removeDataRequestListener( listener : DataRequestListener ) : Boolean
		{
			return _oEB.removeListener( listener );
		}
		
		public function fireEvent( e : Event ) : void
		{
			_oEB.broadcastEvent( e );
		}
		
		public override function execute( e : Event = null ) : void
		{
			request( e as DataRequestEvent );
		}

		/*
		 * virtual methods
		 */
		public function request( e : DataRequestEvent ) : void
		{
			var msg : String = this + ".request() must be implemented in concrete class.";
			PixlibDebug.ERROR( msg );
			throw( new UnimplementedVirtualMethodException( msg ) );
		}

		public function setURL( url : String ) : void
		{
			var msg : String = this + ".setURL() must be implemented in concrete class.";
			PixlibDebug.ERROR( msg );
			throw( new UnimplementedVirtualMethodException( msg ) );
		}
		
		public function setArguments(...rest) : void
		{
			var msg : String = this + ".setArguments() must be implemented in concrete class.";
			PixlibDebug.ERROR( msg );
			throw( new UnimplementedVirtualMethodException( msg ) );
		}
	}
}