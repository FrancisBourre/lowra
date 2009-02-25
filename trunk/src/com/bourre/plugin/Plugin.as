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
	 * The Plugin interface defines rules for IoC plugin implementation.
	 * 
	 * @author 	Francis Bourre
	 */
	public interface Plugin 
	{
		/**
		 * Fires events using dedicated event channel.
		 * 
		 * <p>Only listeners on this event channel can receive 
		 * the event.</p>
		 */
		function fireExternalEvent( e : Event, channel : EventChannel ) : void;
		
		/**
		 * Fires events using public event channel.
		 * 
		 * <p>Each plugin who listen this type of event will be 
		 * triggered.</p>
		 */
		function firePublicEvent( e : Event ) : void;
		
		/**
		 * Fires events using private ( internal ) event channel.
		 * 
		 * <p>These events can be only handled by this plugin itself.<br />
		 * Others plugins in context can't listen this event.</p>
		 */
		function firePrivateEvent( e : Event ) : void;
		
		/**
		 * Returns plugin's event channel.
		 */
		function getChannel() : EventChannel;
		
		/**
		 * Returns plugin's debug channel.
		 */
		function getLogger() : PluginDebug;
		
		/**
		 * Returns an <code>AbstractModel</code> instance if it is 
		 * registered in model locator with passed-in <code>key</code> 
		 * identifier.
		 * 
		 * @param	key	Model identifier to return.
		 * 
		 * @return	The model registered with passed-in key or <code>null</code>
		 */
		function getModel( key : String ) : AbstractModel;
		
		/**
		 * Returns an <code>AbstractView</code> instance if it is 
		 * registered in view locator with passed-in <code>key</code> 
		 * identifier.
		 * 
		 * @param	key	View identifier to return.
		 * 
		 * @return	The view registered with passed-in key or <code>null</code>
		 */
		function getView( key : String ) : AbstractView;
		
		/**
		 * Returns <code>true</code> if a model is registered in model 
		 * locator with passed-in <code>name</code>.
		 * 
		 * @param	name	Model identifier to search
		 * 
		 * @return <code>true</code> if a model is registered in model 
		 * locator with passed-in <code>name</code>.
		 */
		function isModelRegistered( name : String ) : Boolean;
		
		/**
		 * Returns <code>true</code> if a view is registered in view 
		 * locator with passed-in <code>name</code>.
		 * 
		 * @param	name	View identifier to search
		 * 
		 * @return <code>true</code> if a view is registered in model 
		 * locator with passed-in <code>name</code>.
		 */
		function isViewRegistered( name : String ) : Boolean;
		
		/**
		 * Triggered when all IoC processing is finished.
		 */
		function onApplicationInit( ) : void;
	}
}