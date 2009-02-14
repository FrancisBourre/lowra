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
	import com.bourre.events.ValueObject;
	import com.bourre.events.ValueObjectEvent;	

	/**
	 * The PluginEvent class represents the event object passed 
	 * to the event listener for <strong>Plugin</strong> events.
	 * 
	 * @see Plugin
	 * 
	 * @author Francis Bourre
	 */
	public class PluginEvent extends ValueObjectEvent
	{
		//--------------------------------------------------------------------
		// Events
		//--------------------------------------------------------------------
		
		/**
		 * Defines the value of the <code>type</code> property of the event 
		 * object for a <code>onInitPlugin</code> event.
		 * 
		 * <p>The properties of the event object have the following values:</p>
	     * <table class="innertable">
	     *     <tr><th>Property</th><th>Value</th></tr>
	     *     <tr>
	     *     	<td><code>type</code></td>
	     *     	<td>Dispatched event type</td>
	     *     </tr>
	     *     
	     *     <tr><th>Method</th><th>Value</th></tr>
	     *     <tr>
	     *     	<td><code>getPlugin()</code>
	     *     	</td><td>The plugin carried by this event</td>
	     *     </tr>
	     * </table>
	     * 
		 * @eventType onInitPlugin
		 */		
		public static const onInitPluginEVENT 		: String = "onInitPlugin";
		
		/**
		 * Defines the value of the <code>type</code> property of the event 
		 * object for a <code>onReleasePlugin</code> event.
		 * 
		 * <p>The properties of the event object have the following values:</p>
	     * <table class="innertable">
	     *     <tr><th>Property</th><th>Value</th></tr>
	     *     <tr>
	     *     	<td><code>type</code></td>
	     *     	<td>Dispatched event type</td>
	     *     </tr>
	     *     
	     *     <tr><th>Method</th><th>Value</th></tr>
	     *     <tr>
	     *     	<td><code>getPlugin()</code>
	     *     	</td><td>The plugin carried by this event</td>
	     *     </tr>
	     * </table>
	     * 
		 * @eventType onReleasePlugin
		 */	
		public static const onReleasePluginEVENT 	: String = "onReleasePlugin";
		
		
		//--------------------------------------------------------------------
		// Protected properties
		//--------------------------------------------------------------------
		
		/** @private */		
		protected var _plugin : Plugin;
		
		
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
		
		/**
		 * Creates a new <code>ConstructorEvent</code> object.
		 * 
		 * @param	sType		Name of the event type
		 * @param	target		Object which dispatch this event		 * @param	plugin		Constructor object carried by this event
		 * @param	valueObject	Plugin carried by this event
		 */	
		public function PluginEvent( sType : String, target : Object = null, plugin : Plugin = null, valueObject : ValueObject = null )
		{
			super( sType, target, valueObject );
			
			_plugin = plugin;
		}
		
		/**
		 * Returns the plugin object carried by this event.
		 * 
		 * @return	The plugin value carried by this event.
		 */
		public function getPlugin() : Plugin
		{
			return ( _plugin != null ) ? _plugin : getTarget() as Plugin;
		}
	}
}