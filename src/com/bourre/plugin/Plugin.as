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
package com.bourre.plugin
{
	import com.bourre.events.EventChannel;
	import com.bourre.model.AbstractModel;
	import com.bourre.view.AbstractView;
	
	import flash.events.Event;	
	
	/**
	 * The Plugin interface.
	 * 
	 * <p>TODO Documentation.</p>
	 * 
	 * @author 	Francis Bourre
	 */
	public interface Plugin 
	{
		function fireExternalEvent( e : Event, channel : EventChannel ) : void;
		function firePublicEvent( e : Event ) : void;
		function firePrivateEvent( e : Event ) : void;

		function getChannel() : EventChannel;
		function getLogger() : PluginDebug;
		
		function getModel( key : String ) : AbstractModel;
		function getView( key : String ) : AbstractView;
		function isModelRegistered( name : String ) : Boolean;
		function isViewRegistered( name : String ) : Boolean;
	}
}