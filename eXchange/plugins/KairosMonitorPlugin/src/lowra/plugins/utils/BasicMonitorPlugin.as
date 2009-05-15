/**
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
package lowra.plugins.utils 
{
	import com.bourre.ioc.bean.BeanFactory;
	import com.bourre.ioc.parser.ContextNodeNameList;
	import com.bourre.plugin.AbstractPlugin;
	import com.kairos.utils.Monitor;
	import com.kairos.utils.MonitorFieldsList;
	
	import flash.display.DisplayObjectContainer;	

	/**
	 * <strong>Kairos Monitor</strong> Plugin.
	 * 
	 * <p>Application monitoring :
	 * <ul>
	 * 	<li>framerate</li>
	 * 	<li>memory</li>
	 * </ul></p>
	 * 
	 * @author Romain Ecarnot
	 */
	public class BasicMonitorPlugin extends AbstractPlugin
	{
		//--------------------------------------------------------------------
		// Protected properties
		//--------------------------------------------------------------------
		
		/** <code>Monitor</code> container. */
		protected var mcTarget : DisplayObjectContainer;

		/** <code>Monitor</code> instance. */
		protected var oMonitor : Monitor;
		
		
		//--------------------------------------------------------------------
		// Public properties
		//--------------------------------------------------------------------
		
		/** Alpha value of monitor. */
		public function get alpha( ) : Number
		{
			return oMonitor.alpha;	
		}
		/** @private */
		public function set alpha( n : Number ) : void
		{
			oMonitor.alpha = n;
		}
		
		/** X position of monitor. */		
		public function get x( ) : Number
		{
			return oMonitor.x;	
		}
		/** @private */
		public function set x( n : Number ) : void
		{
			oMonitor.x = n;
		}

		/** Y position of monitor. */		
		public function get y( ) : Number
		{
			return oMonitor.y;	
		}
		/** @private */
		public function set y( n : Number ) : void
		{
			oMonitor.y = n;
		}
		
		/** Width of monitor. */		
		public function get width( ) : Number
		{
			return oMonitor.width;	
		}
		/** @private */
		public function set width( n : Number ) : void
		{
			oMonitor.width = n;
		}
		
		/** Height value of monitor. */		
		public function get height( ) : Number
		{
			return oMonitor.height;	
		}
		/** @private */
		public function set height( n : Number ) : void
		{
			oMonitor.height = n;
		}
		
		
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
		
		/**
		 * Creates instance.
		 */
		public function BasicMonitorPlugin( layer : DisplayObjectContainer = null )
		{
			super( );
			
			mcTarget = ( layer != null ) ? layer : BeanFactory.getInstance( ).locate( ContextNodeNameList.ROOT ) as DisplayObjectContainer;
			
			oMonitor = new Monitor( );
			oMonitor.mouseChildren = false;
			oMonitor.mouseEnabled = false;
			oMonitor.addField( MonitorFieldsList.FPS );
			oMonitor.addField( MonitorFieldsList.MEMORY );
			
			mcTarget.addChild( oMonitor );
			
			oMonitor.start();
		}	
		
		/**
		 * Shows monitor.
		 */
		public function show( ) : void
		{
			oMonitor.visible = true;
		}

		/**
		 * Hides monitor.
		 */
		public function hide() : void
		{
			oMonitor.visible = false;	
		}
	}
}