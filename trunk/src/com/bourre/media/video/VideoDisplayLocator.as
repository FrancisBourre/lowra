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
	 
package com.bourre.media.video
{
	import com.bourre.core.AbstractLocator;
	import com.bourre.error.PrivateConstructorException;
	import com.bourre.media.SoundTransformInfo;	
	
	/**
	 *  Dispatched when VideoDisplay object is registered in 
	 *  <code>VideoDisplayLocator</code> locator.
	 *  
	 *  @eventType com.bourre.media.video.VideoDisplayLocatorEvent.onRegisterVideoDisplayEVENT
	 */
	[Event(name="onRegisterVideoDisplay", type="com.bourre.media.video.VideoDisplayLocatorEvent")]
	
	/**
	 *  Dispatched when VideoDisplay is unregistered from 
	 *  <code>VideoDisplayLocator</code> locator.
	 *  
	 *  @eventType com.bourre.media.video.VideoDisplayLocatorEvent.onUnregisterVideoDisplayEVENT
	 */
	[Event(name="onUnregisterVideoDisplay", type="com.bourre.media.video.VideoDisplayLocatorEvent")]
	
	/**
	 * The VideoDisplayLocator store and register 
	 * <code>VideoDisplay</code> objects.
	 * 
	 * @example 
	 * <pre class="prettyprint">
	 * 
	 * public function loadFile( ) : void
	 * {
	 * 	var loader : VideoDisplay = new VideoDisplay(, "intro", containerVideo, false, false );
	 * 	loader.load( new URLRequest( "intro.flv" );
	 * }
	 * 
	 * public function anotherFunction( ) :void
	 * {
	 * 	var intro : VideoDisplay = VideoDisplayLocator.getInstance().getVideoDisplay( "intro" );
	 * }
	 * </pre>
	 * 
	 * @author 	Aigret Axel
	 * 
	 * @see VideoDisplay
	 */
	public class VideoDisplayLocator extends AbstractLocator
	{
		private static var _oI : VideoDisplayLocator = null;

		/**
		 * Returns unique <code>GraphicLoaderLocator</code>.
		 * 
		 * @return the unique <code>GraphicLoaderLocator</code>.
		 */			
		public static function getInstance() : VideoDisplayLocator
		{
			if ( !(VideoDisplayLocator._oI is VideoDisplayLocator) ) VideoDisplayLocator._oI = new VideoDisplayLocator( new ConstructorAccess() );
			return VideoDisplayLocator._oI;
		}
		
		/**
		 * Releases instance.
		 */
		public static function release():void
		{
			if ( VideoDisplayLocator._oI is VideoDisplayLocator ) VideoDisplayLocator._oI = null;
		}
		
		/**
		 * Dispatches <code>VideoDisplayLocatorEvent</code> event using passed-in 
		 * arguments as event properties when a <code>VideoDisplay</code> is 
		 * registered in locator.
		 * 
		 * <p>Event type is <code>VideoDisplayLocatorEvent.onRegisterVideoDisplayEVENT</code></p>
		 * 
		 * @param	name	Name of the registered <code>VideoDisplay</code>
		 * @param	o		The registered <code>VideoDisplay</code>
		 * 
		 * @see VideoDisplay
		 * @see VideoDisplayLocatorEvent
		 * @see VideoDisplayLocatorEvent#onRegisterVideoDisplayEVENT
		 */
		override protected function onRegister( name : String = null, o : Object = null ) : void
		{
			broadcastEvent(new VideoDisplayLocatorEvent( VideoDisplayLocatorEvent.onRegisterVideoDisplayEVENT, name, o as VideoDisplay));
		}
		
		/**
		 * Dispatches <code>VideoDisplayLocatorEvent</code> event using passed-in 
		 * arguments as event properties when a <code>VideoDisplay</code> is 
		 * unregistered from locator.
		 * 
		 * <p>Event type is <code>VideoDisplayLocatorEvent.onUnregisterVideoDisplayEVENT</code></p>
		 * 
		 * @param	name	Name of the registredred <code>VideoDisplay</code>
		 * @param	o		The registered <code>VideoDisplay</code>
		 * 
		 * @see VideoDisplay
		 * @see VideoDisplayLocatorEvent
		 * @see VideoDisplayLocatorEvent#onUnregisterGraphicLoaderEVENT
		 */
		override protected function onUnregister( name : String = null ) : void
		{
			broadcastEvent(new VideoDisplayLocatorEvent( VideoDisplayLocatorEvent.onUnregisterVideoDisplayEVENT, name, null ) );
		} 
		
		/**
		 * Returns <code>VideoDisplay</code> object registered with passed-in 
		 * name identifier.
		 * 
		 * @return <code>VideoDisplay</code> object registered with passed-in 
		 * name identifier.
		 * 
		 * @throws 	<code>Error</code> — name is not registered in current 
		 * 			locator
		 */
		public function getVideoDisplay( name : String ) : VideoDisplay
		{
			try
			{
				var videoDisplay : VideoDisplay = locate( name) as VideoDisplay;
				return videoDisplay;

			} catch ( e : Error )
			{
				throw( e );
			}

			return null;
		}
		
		
		/**
		 * @copy com.bourre.events.Broadcaster#addListener()
		 */
		public function addListener( listener : VideoDisplayLocatorListener ) : Boolean
		{
			return getBroadcaster().addListener( listener );
		}
		
		/**
		 * @copy com.bourre.events.Broadcaster#removeListener()
		 */
		public function removeListener( listener : VideoDisplayLocatorListener ) : Boolean
		{
			return getBroadcaster().removeListener( listener );
		}
		
		/**
		 * Applies passed-in SoundTransformInfo properties to all registered VideoDisplay 
		 * objects.
		 * 
		 * @param	soundTransformInfo	SoundTransformInfo properties
		 */
		public function setSoundTransformAll(   soundTransformInfo : SoundTransformInfo ) : void
		{	
			performAll( "setSoundTransform",  soundTransformInfo  ) ;
		}
		
		/**
		 * If id call the function on all id of all SoundMixer
		 * If no id , call the funciton on all sound in all SoundMixer
		 */
		private function performAll( sFunction : String , ... args ) : void 
		{
			for each( var oVideoDisplay : VideoDisplay in getValues() )
			{
				var f : Function  = oVideoDisplay[ sFunction ] as Function ;
				f.apply( null,  args  );
			}		
		}
		
		function VideoDisplayLocator( access : ConstructorAccess )
		{
			super( VideoDisplay, VideoDisplayLocatorListener );
			
			if ( !(access is ConstructorAccess) ) throw new PrivateConstructorException();
		}
	}
}

internal class ConstructorAccess {}