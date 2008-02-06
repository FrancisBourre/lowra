package com.bourre.plugin 
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
	import com.bourre.events.BasicEvent;		

	public class PluginEvent 
		extends BasicEvent
	{
		public static const onInitPluginEVENT : String = "onInitPlugin";
		public static const onReleasePluginEVENT : String = "onReleasePlugin";

		protected var _plugin : Plugin;

		public function PluginEvent( sType : String, target : Object = null, plugin : Plugin = null )
		{
			super( sType, target );

			_plugin = plugin;
		}

		public function getPlugin() : Plugin
		{
			return _plugin;
		}
	}
}