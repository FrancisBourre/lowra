package com.bourre.ioc.load 
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
	import flash.display.DisplayObjectContainer;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	
	import com.bourre.error.NullPointerException;
	import com.bourre.ioc.assembler.ApplicationAssembler;
	import com.bourre.ioc.assembler.DefaultApplicationAssembler;
	import com.bourre.ioc.assembler.channel.ChannelListenerExpert;
	import com.bourre.ioc.assembler.constructor.ConstructorExpert;
	import com.bourre.ioc.assembler.displayobject.DisplayObjectEvent;
	import com.bourre.ioc.assembler.displayobject.DisplayObjectExpert;
	import com.bourre.ioc.assembler.displayobject.DisplayObjectExpertEvent;
	import com.bourre.ioc.assembler.displayobject.DisplayObjectExpertListener;
	import com.bourre.ioc.assembler.method.MethodExpert;
	import com.bourre.ioc.context.ContextLoader;
	import com.bourre.ioc.context.ContextLoaderEvent;
	import com.bourre.ioc.parser.ContextParser;
	import com.bourre.ioc.parser.ContextParserEvent;
	import com.bourre.ioc.parser.DLLParser;
	import com.bourre.ioc.parser.DisplayObjectParser;
	import com.bourre.ioc.parser.ObjectParser;
	import com.bourre.ioc.parser.ParserCollection;
	import com.bourre.load.AbstractLoader;
	import com.bourre.load.LoaderEvent;
	import com.bourre.load.LoaderListener;
	import com.bourre.log.PixlibDebug;	

	public class ApplicationLoader
		extends AbstractLoader
		implements LoaderListener, DisplayObjectExpertListener
	{
		public static const DEFAULT_URL : URLRequest = new URLRequest( "applicationContext.xml" );

		protected var _oApplicationAssembler : ApplicationAssembler;
		protected var _oParserCollection : ParserCollection;

		public function ApplicationLoader( target : DisplayObjectContainer, url : URLRequest = null )
		{
			setListenerType( ApplicationLoaderListener );

			setURL( url? url : ApplicationLoader.DEFAULT_URL );

			setApplicationAssembler( new DefaultApplicationAssembler() );
			DisplayObjectExpert.getInstance().setRootTarget( target );
			_initParserCollection();
		}

		protected function _initParserCollection() : void
		{
			var pc : ParserCollection = new ParserCollection();

			pc.push( new DLLParser( getApplicationAssembler() ) );
			pc.push( new DisplayObjectParser( getApplicationAssembler() ) );
			pc.push( new ObjectParser( getApplicationAssembler() ) );

			setParserCollection( pc );
		}

		public function getApplicationAssembler() : ApplicationAssembler
		{
			return _oApplicationAssembler;
		}

		public function setApplicationAssembler( assembler : ApplicationAssembler ) : void
		{
			_oApplicationAssembler = assembler;
		}

		public function getParserCollection() : ParserCollection
		{
			return _oParserCollection;
		}

		public function setParserCollection( pc : ParserCollection ) : void
		{
			_oParserCollection = pc;
		}

		public function addApplicationLoaderListener( listener : ApplicationLoaderListener ) : Boolean
		{
			return addListener( listener );
		}

		public function removeApplicationLoaderListener( listener : ApplicationLoaderListener ) : Boolean
		{
			return removeListener( listener );
		}

		/**
		 * loading
		 */
		override public function load( url : URLRequest = null, context : LoaderContext = null ) : void
		{
			if ( url != null ) setURL( url );

			if ( getURL().url.length > 0 )
			{
				var cl : ContextLoader = new ContextLoader();
				cl.setURL( getURL() );

				cl.addEventListener( ContextLoaderEvent.onLoadInitEVENT, _onContextLoaderLoadInit );
				cl.addEventListener( ContextLoaderEvent.onLoadProgressEVENT, this );
				cl.addEventListener( ContextLoaderEvent.onLoadTimeOutEVENT, this );
				cl.addEventListener( ContextLoaderEvent.onLoadErrorEVENT, this );

				cl.load( getURL(), context );

			} else
			{
				var msg : String = this + ".load() can't retrieve file url.";
				PixlibDebug.ERROR( msg );
				throw new NullPointerException( msg );
			}
		}

		protected function _onContextLoaderLoadInit( e : ContextLoaderEvent ) : void
		{
			e.getContextLoader().removeListener( this );
			parseContext( e.getContext() );
		}

		/**
		 * parsing
		 */
		public function parseContext( xml : * ) : void
		{
			var cp : ContextParser = new ContextParser( getParserCollection() );
			cp.addEventListener( ContextParserEvent.onContextParsingEndEVENT, _onContextParsingEnd );
			cp.parse( xml );
		}

		protected function _onContextParsingEnd( e : ContextParserEvent ) : void
		{
			e.getContextParser().removeEventListener( ContextParserEvent.onContextParsingEndEVENT, this );

			DisplayObjectExpert.getInstance().addListener( this );
			DisplayObjectExpert.getInstance().load();
		}

		/**
		 * fire events
		 */
		public function fireOnApplicationParsed() : void
		{
			fireEvent( new ApplicationLoaderEvent( ApplicationLoaderEvent.onApplicationParsedEVENT, this ) );
		}

		public function fireOnObjectsBuilt() : void
		{
			fireEvent( new ApplicationLoaderEvent( ApplicationLoaderEvent.onApplicationObjectsBuiltEVENT, this ) );
		}

		public function fireOnChannelsAssigned() : void
		{
			fireEvent( new ApplicationLoaderEvent( ApplicationLoaderEvent.onApplicationChannelsAssignedEVENT, this ) );
		}

		public function fireOnMethodsCalled() : void
		{
			fireEvent( new ApplicationLoaderEvent( ApplicationLoaderEvent.onApplicationMethodsCalledEVENT, this ) );
		}

		public function fireOnApplicationInit() : void 
		{
			fireEvent( new ApplicationLoaderEvent( ApplicationLoaderEvent.onApplicationInitEVENT, this ) );
		}

		/**
		 * Loader callbacks
		 */
		public function onLoadStart( e : LoaderEvent ) : void
		{
			fireOnLoadStartEvent();
		}

		public function onLoadInit( e : LoaderEvent ) : void
		{
			//
		}

		public function onLoadProgress( e : LoaderEvent ) : void
		{
			fireOnLoadProgressEvent();
		}

		public function onLoadTimeOut( e : LoaderEvent ) : void
		{
			fireOnLoadTimeOut();
		}

		public function onLoadError( e : LoaderEvent ) : void
		{
			fireOnLoadErrorEvent( e.getErrorMessage() );
			PixlibDebug.ERROR( e.getErrorMessage() );
		}

		/**
		 * DisplayObjectExpert callbacks
		 */
		public function onBuildDisplayObject( e : DisplayObjectEvent ) : void
		{
			PixlibDebug.INFO( "onBuildDisplayObject()" );
		}

		public function onDisplayObjectExpertLoadStart(e : DisplayObjectExpertEvent) : void
		{
			PixlibDebug.INFO( "onDisplayObjectExpertLoadStart()" );
		}

		public function onDLLLoadStart(e : DisplayObjectExpertEvent) : void
		{
			PixlibDebug.INFO( "onDLLLoadStart()" );
		}

		public function onDLLLoadInit(e : DisplayObjectExpertEvent) : void
		{
			PixlibDebug.INFO( "onDLLLoadInit()" );
		}

		public function onDisplayObjectLoadStart(e : DisplayObjectExpertEvent) : void
		{
			PixlibDebug.INFO( "onDisplayObjectLoadStart()" );
		}

		public function onDisplayObjectLoadInit(e : DisplayObjectExpertEvent) : void
		{
			PixlibDebug.INFO( "onDisplayObjectLoadInit()" );
		}

		public function onDisplayObjectExpertLoadInit(e : DisplayObjectExpertEvent) : void
		{
			PixlibDebug.INFO( "onDisplayObjectExpertLoadInit()" );

			fireOnApplicationParsed();

			ConstructorExpert.getInstance().buildAllObjects();
			fireOnObjectsBuilt();

			ChannelListenerExpert.getInstance().assignAllChannelListeners();
			fireOnChannelsAssigned();

			MethodExpert.getInstance().callAllMethods();
			fireOnMethodsCalled();

			fireOnApplicationInit();
		}

		//
		override protected function getLoaderEvent( type : String, errorMessage : String = "" ) : LoaderEvent
		{
			return new ApplicationLoaderEvent( type, this, errorMessage );
		}
	}
}