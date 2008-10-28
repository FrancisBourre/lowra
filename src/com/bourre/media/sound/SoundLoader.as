package com.bourre.media.sound
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
	 * @author Aigret Axel
	 * @version 1.0
	 */
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	
	import com.bourre.error.IllegalArgumentException;
	import com.bourre.load.AbstractLoader;
	import com.bourre.load.LoaderEvent;
	import com.bourre.load.strategy.LoadStrategy;
	import com.bourre.load.strategy.LoaderStrategy;
	import com.bourre.log.PixlibDebug;	

	public class SoundLoader extends AbstractLoader
	{
		private var _oContext : LoaderContext;
		private var _bMustUnregister : Boolean;
		
		public function SoundLoader( strategy : LoadStrategy = null )
		{
			super(strategy );
		}
		
		override protected function onInitialize() : void
		{
			if ( getName() != null ) 
			{
				if ( !(SoundLoaderLocator.getInstance().isRegistered(getName())) )
				{
					_bMustUnregister = true;
					SoundLoaderLocator.getInstance().register( getName(), this );
	
				} else
				{
					_bMustUnregister = false;
					var msg : String = this + " can't be registered to " + SoundLoaderLocator.getInstance() 
										+ " with '" + getName() + "' name. This name already exists.";
					PixlibDebug.ERROR(msg );
					fireOnLoadErrorEvent( msg );
					throw new IllegalArgumentException(msg);
				}
			}
			
			super.onInitialize();
		}
		
		override protected function getLoaderEvent( type : String, errorMessage : String = "" ) : LoaderEvent
		{
			return new SoundLoaderEvent( type, this, errorMessage );
		}
		
		override public function load( url : URLRequest = null, context : LoaderContext = null ) : void
		{
			if ( context ) setContext( context );
			super.load( url, getContext() );
		}
		
		public function getApplicationDomain() : ApplicationDomain
		{
			return ( getStrategy() as LoaderStrategy ).getContentLoaderInfo().applicationDomain;
		}
		
		final public function setContext ( context : LoaderContext ):void
		{
			_oContext = context;
		}

		final public function getContext () : LoaderContext
		{
			return _oContext;
		}
		
		override public function release() : void
		{
			if ( _bMustUnregister ) 
			{
				SoundLoaderLocator.getInstance().unregister( getName() );
				_bMustUnregister = false;
			}

			super.release();
		}
		
	}
}