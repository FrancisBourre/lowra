/** * Copyright the original author or authors. *  * Licensed under the MOZILLA PUBLIC LICENSE, Version 1.1 (the "License"); * you may not use this file except in compliance with the License. * You may obtain a copy of the License at *  *      http://www.mozilla.org/MPL/MPL-1.1.html *  * Unless required by applicable law or agreed to in writing, software * distributed under the License is distributed on an "AS IS" BASIS, * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. * See the License for the specific language governing permissions and * limitations under the License. */package  lowra.plugins.utils.tracking{
	import com.bourre.events.StringEvent;	import com.bourre.plugin.AbstractPlugin;		/**	 * Tracking engine plugin.	 * 	 * @author Romain Ecarnot	 */	public class TrackingPlugin extends AbstractPlugin 	{		//--------------------------------------------------------------------		// Private properties		//--------------------------------------------------------------------		private var _a : Array;				//--------------------------------------------------------------------		// Public properties		//--------------------------------------------------------------------				public var debug : Boolean = false;								//-------------------------------------------------------------------------		// Public API		//-------------------------------------------------------------------------				/**		 * Creates plugin instance.		 */		public function TrackingPlugin(  ) 		{			super();						_a = new Array();		}		/**		 * Registers passed-in <code>strategy</code> to tracking engine.		 * 		 * @param	strategy	<code>TrackingStrategy</code> implementation		 */		public function register(  strategy : TrackingStrategy ) : void		{			_a.push(strategy);		}				/**		 * Tracks passed-in tag.		 */		public function track( tag : String ) : void		{			if( debug )			{				getLogger().debug( this + "::track " + tag );			}			else			{				for each (var tracker : TrackingStrategy in _a) 				{					try					{						if( tracker.isAvailable() )						{							tracker.track(tag);						}					}					catch( e : Error )					{						getLogger().error(this + "::" + e.message);					}				}			}		}				/**		 * Triggered when "onTrack" event is received.		 */		public function onTrack( e : StringEvent ) : void		{			track(e.getString());		}	}}