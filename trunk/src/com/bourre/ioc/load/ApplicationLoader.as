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
package com.bourre.ioc.load 
{
	import com.bourre.commands.Delegate;
	import com.bourre.error.NullPointerException;
	import com.bourre.events.BasicEvent;
	import com.bourre.events.ValueObjectEvent;
	import com.bourre.ioc.assembler.ApplicationAssembler;
	import com.bourre.ioc.assembler.DefaultApplicationAssembler;
	import com.bourre.ioc.assembler.channel.ChannelListenerExpert;
	import com.bourre.ioc.assembler.constructor.ConstructorExpert;
	import com.bourre.ioc.assembler.displayobject.DefaultDisplayObjectBuilder;
	import com.bourre.ioc.assembler.displayobject.DisplayLoaderInfo;
	import com.bourre.ioc.assembler.displayobject.DisplayObjectBuilder;
	import com.bourre.ioc.assembler.displayobject.DisplayObjectBuilderEvent;
	import com.bourre.ioc.assembler.displayobject.DisplayObjectBuilderListener;
	import com.bourre.ioc.assembler.displayobject.DisplayObjectEvent;
	import com.bourre.ioc.assembler.displayobject.loader.DisplayLoaderProxy;
	import com.bourre.ioc.assembler.method.MethodExpert;
	import com.bourre.ioc.assembler.plugins.PluginExpert;
	import com.bourre.ioc.assembler.property.PropertyExpert;
	import com.bourre.ioc.assembler.resource.ResourceExpert;
	import com.bourre.ioc.bean.BeanFactory;
	import com.bourre.ioc.context.ContextLoader;
	import com.bourre.ioc.context.ContextLoaderEvent;
	import com.bourre.ioc.context.processor.ContextProcessor;
	import com.bourre.ioc.load.ApplicationLoaderEvent;
	import com.bourre.ioc.load.ApplicationLoaderListener;
	import com.bourre.ioc.load.FlashVarsUtil;
	import com.bourre.ioc.parser.ContextParser;
	import com.bourre.ioc.parser.ContextParserEvent;
	import com.bourre.ioc.parser.DLLParser;
	import com.bourre.ioc.parser.DisplayObjectParser;
	import com.bourre.ioc.parser.LoaderParser;
	import com.bourre.ioc.parser.ObjectParser;
	import com.bourre.ioc.parser.ParserCollection;
	import com.bourre.ioc.parser.RSCParser;
	import com.bourre.load.AbstractLoader;
	import com.bourre.load.LoaderEvent;
	import com.bourre.load.LoaderListener;
	import com.bourre.log.PixlibDebug;
	
	import flash.display.DisplayObjectContainer;
	import flash.external.ExternalInterface;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;	

	/**
	 *  Dispatched when a context item file starts loading.
	 *  
	 *  @eventType com.bourre.ioc.load.ApplicationLoaderEvent.onLoadStartEVENT
	 */
	[Event(name="onLoadStart", type="com.bourre.ioc.load.ApplicationLoaderEvent")]
	
	/**
	 *  Dispatched when a context item file loading is finished
	 *  
	 *  @eventType com.bourre.ioc.load.ApplicationLoaderEvent.onLoadInitEVENT
	 */
	[Event(name="onLoadInit", type="com.bourre.ioc.load.ApplicationLoaderEvent")]
	
	/**
	 *  Dispatched during context item file loading progression
	 *  
	 *  @eventType com.bourre.ioc.load.ApplicationLoaderEvent.onLoadProgressEVENT
	 */
	[Event(name="onLoadProgress", type="com.bourre.ioc.load.ApplicationLoaderEvent")]
	
	/**
	 *  Dispatched when a timeout occurs during context item file loading.
	 *  
	 *  @eventType com.bourre.ioc.load.ApplicationLoaderEvent.onLoadTimeOutEVENT
	 */
	[Event(name="onLoadTimeOut", type="com.bourre.ioc.load.ApplicationLoaderEvent")]
	
	/**
	 *  ispatched when an error occurs during context item file loading.
	 *  
	 *  @eventType com.bourre.ioc.load.ApplicationLoaderEvent.onLoadErrorEVENT
	 */
	[Event(name="onLoadError", type="com.bourre.ioc.load.ApplicationLoaderEvent")]
	
	/**
	 *  Dispatched when context files loading starts.
	 *  
	 *  @eventType com.bourre.ioc.load.ApplicationLoaderEvent.onApplicationStartEVENT
	 */
	[Event(name="onApplicationStart", type="com.bourre.ioc.load.ApplicationLoaderEvent")]
	
	/**
	 *  Dispatched when IoC engien state change
	 *  
	 *  Possible values for state are : 
	 * <ul>
	 * 	<li>ApplicationLoaderEvent.LOAD_STATE</li>	 * 	<li>ApplicationLoaderEvent.PREPROCESS_STATE</li>
	 * 	<li>ApplicationLoaderEvent.PARSE_STATE</li>
	 * 	<li>ApplicationLoaderEvent.DLL_STATE</li>
	 * 	<li>ApplicationLoaderEvent.RSC_STATE</li>
	 * 	<li>ApplicationLoaderEvent.GFX_STATE</li>
	 * 	<li>ApplicationLoaderEvent.BUILD_STATE</li>
	 * 	<li>ApplicationLoaderEvent.RUN_STATE</li>
	 * </ul>.
	 *  
	 *  @eventType com.bourre.ioc.load.ApplicationLoaderEvent.onApplicationStateEVENT
	 */
	[Event(name="onApplicationState", type="com.bourre.ioc.load.ApplicationLoaderEvent")]
	
	/**
	 *  Dispatched when context file is parsed.
	 *  
	 *  @eventType com.bourre.ioc.load.ApplicationLoaderEvent.onApplicationParsedEVENT
	 */
	[Event(name="onApplicationParsed", type="com.bourre.ioc.load.ApplicationLoaderEvent")]
	
	/**
	 *  Dispatched when all context objects are built.
	 *  
	 *  @eventType com.bourre.ioc.load.ApplicationLoaderEvent.onApplicationObjectsBuiltEVENT
	 */
	[Event(name="onApplicationObjectsBuilt", type="com.bourre.ioc.load.ApplicationLoaderEvent")]
	
	/**
	 *  Dispatched when all communication channels are assigned.
	 *  
	 *  @eventType com.bourre.ioc.load.ApplicationLoaderEvent.onApplicationChannelsAssignedEVENT
	 */
	[Event(name="onApplicationChannelsAssigned", type="com.bourre.ioc.load.ApplicationLoaderEvent")]
	
	/**
	 *  Dispatched when all methods defined in context are called.
	 *  
	 *  @eventType com.bourre.ioc.load.ApplicationLoaderEvent.onApplicationMethodsCalledEVENT
	 */
	[Event(name="onApplicationMethodsCalled", type="com.bourre.ioc.load.ApplicationLoaderEvent")]
	
	/**
	 *  Dispatched when application is ready.<br />
	 *  IoC engine complete.
	 *  
	 *  @eventType com.bourre.ioc.load.ApplicationLoaderEvent.onApplicationInitEVENT
	 */
	[Event(name="onApplicationInit", type="com.bourre.ioc.load.ApplicationLoaderEvent")]
	
	/**
	 * IoC Context loader.
	 * 
	 * @author Francis Bourre
	 */
	public class ApplicationLoader	extends AbstractLoader
		implements LoaderListener, DisplayObjectBuilderListener
	{
		//--------------------------------------------------------------------
		// Constants
		//--------------------------------------------------------------------
		
		/** Default URL Request for applicationContext file. */
		public static const DEFAULT_URL : URLRequest = new URLRequest( "applicationContext.xml" );
		
		/** 
		 * Defines wildcard to search to identify an absolute path.
		 * 
		 * @default ://
		 */
		public static const ABSOLUTE_PATH : String = "://";
		
		/** Enabled or not the debugging feature during application loading. */
		public static var DEBUG_LOADING_ENABLED : Boolean = false;	
		
		
		//--------------------------------------------------------------------
		// Private properties
		//--------------------------------------------------------------------
		
		private var _oProxy : ApplicationLoaderListener;
		
		
		//--------------------------------------------------------------------
		// Protected properties
		//--------------------------------------------------------------------
		
		/** @private */
		protected var _oRootTarget : DisplayObjectContainer;
		
		/** @private */
		protected var _oDisplayObjectBuilder : DisplayObjectBuilder;
		
		/** @private */
		protected var _oApplicationAssembler : ApplicationAssembler;
		
		/** @private */
		protected var _oParserCollection : ParserCollection;
		
		/** @private */
		protected var _aVariables : Array;

		/** @private */
		protected var _aMethods : Array;

		/** @private */
		protected var _aProcessor : Array;
		
		
		//--------------------------------------------------------------------
		// Public properties
		//--------------------------------------------------------------------
		
		/** Default URL for applicationContext file. */
		public static var DEFAULT_CONTEXT_FILE : String = DEFAULT_URL.url;

		/** Default path for applicationContext file. */
		public static var DEFAULT_CONFIG_PATH : String = "";

		/** Default path for dll files. */
		public static var DEFAULT_DLL_PATH : String = "";

		/** Default path for gfx ( display tree ) files. */
		public static var DEFAULT_GFX_PATH : String = "";

		/** Default path for resources files. */
		public static var DEFAULT_RSC_PATH : String = "";
		
		/**
		 * Defines wildcard to search to identify a forced relative path.
		 * 
		 * @default #//
		 */
		public static var RELATIVE_PATH : String = "#//";
		
		
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
		
		/**
		 * Returns clean URL address using passed-in base url and optional prefix one.
		 * 
		 * @param	request		Original request defined in xml context
		 * @param	optional	Prefix to insert to build correct url link
		 */
		public static function getURLRequest( request : URLRequest, prefix : String = "") : URLRequest
		{
			if( request.url.indexOf( ABSOLUTE_PATH ) < 0 && request.url.indexOf( RELATIVE_PATH ) < 0 )
			{
				if( BeanFactory.getInstance().isRegistered( prefix ) )
				{
					request.url = BeanFactory.getInstance( ).locate( prefix ).toString( ) + request.url;
				}
			}
			else if( request.url.indexOf( RELATIVE_PATH ) == 0 )
			{
				request.url = request.url.substr( RELATIVE_PATH.length );
			}
			
			return request;
		}
		
		/**
		 * Creates loader instance.
		 * 
		 * @param	rootTarget	Main sprite target for display tree creation.
		 * @param	autoExecute	(optional) <code>true</code> to start loading 
		 * 						just after loader instanciation.
		 * @param	url			URL request for 'applicationContext' file 
		 * 						to load.
		 */
		public function ApplicationLoader(	rootTarget : DisplayObjectContainer, 
											autoExecute : Boolean = false, 
											url : URLRequest = null )
		{
			setListenerType( ApplicationLoaderListener );
			_oRootTarget = rootTarget;
			setURL( url ? url : ApplicationLoader.DEFAULT_URL );
			
			initQueryURL( );
			initContext( );
			
			_aVariables = new Array( );
			_aMethods = new Array( );
			_aProcessor = new Array( );
			
			setApplicationAssembler( new DefaultApplicationAssembler( ) );
			
			_initParserCollection( );
			if ( autoExecute ) execute( );
		}

		/**
		 * Returns <code>ApplicationAssembler</code> used in by this loader.
		 */
		public function getApplicationAssembler() : ApplicationAssembler
		{
			return _oApplicationAssembler;
		}

		/**
		 * Sets the <code>ApplicationAssembler</code> to use by this loader.
		 */
		public function setApplicationAssembler( assembler : ApplicationAssembler ) : void
		{
			_oApplicationAssembler = assembler;
		}

		/**
		 * Returns parser collection used by assembler.
		 */
		public function getParserCollection() : ParserCollection
		{
			return _oParserCollection;
		}

		/**
		 * Sets the parsers collection to use in order to build context.
		 */
		public function setParserCollection( pc : ParserCollection ) : void
		{
			_oParserCollection = pc;
		}
		
		/**
		 * Sets new pair name / value for variable replacement when context 
		 * file will be laoded.
		 * 
		 * @param	name	Name of the variable to replace.
		 * @param	value	New value for this variable.
		 * 
		 * @example Variable definition somewhere in the xml context :
		 * <pre class="prettyprint">
		 * 
		 * ${POSITION_X}
		 * </pre>
		 * 
		 * @example Setting this variable using setVariable() method :
		 * <pre class="prettyprint">
		 * 
		 * rtLoader.setVariable( "POSITION_X", 200 );
		 * </pre>
		 */
		public function setVariable( name : String, value : Object ) : void
		{
			_aVariables.push( new Variable( name, value ) );
		}
		
		/**
		 * Adds new preprocessing method.
		 * 
		 * <p>Preprocessing act after xml loading and before context parsing.<br />
		 * Used to transform context data on fly.</p>
		 * 
		 * @param	processingMethod	Method to call.<br/>
		 * 								Method must accept an XML object as first argument 
		 * 								and return an XML object when completed.
		 * 	@param	...					Additionals parameters to pass to method when 
		 * 								executing.
		 * 								
		 * @example
		 * <pre class="prettyprint">
		 * 
		 * var oLoader : ApplicationLoader = new ApplicationLoader( this, false );
		 * oLoader.addProcessingMethod( ProcessingHelper.changeObjectAttribute, "cross", "visible", "false" );
		 * oLoader.addProcessingMethod( ProcessingHelper.changePropertyValue, "cross", "x", 600 );
		 * oLoader.addProcessingMethod( ProcessingHelper.addResource, "newStyle", "myStyle.css" );
		 * </pre>
		 * 
		 * @see com.bourre.ioc.context.processor.ProcessingHelper 
		 */
		public function addProcessingMethod( processingMethod : Function, ...args ) : void
		{
			var d : Delegate = new Delegate( processingMethod );
			d.setArgumentsArray( args );
			
			_aMethods.push( d );
		}
		
		/**
		 * Adds new pre processing processor.
		 * 
		 * <p>Preprocessing act after xml loading and before context parsing.<br />
		 * Used to transform context data on fly.</p>
		 * 
		 * @example
		 * <pre class="prettyprint">
		 * 
		 * var oLoader : ApplicationLoader = new ApplicationLoader( this, false );
		 * oLoader.addProcessor( new LocalisationProcessor() );
		 * </pre>
		 */
		public function addProcessor( processor : ContextProcessor ) : void
		{
			_aProcessor.push( processor );
		}

		/**
		 * Returns the <code>DisplayObjectBuilder</code> used by this loader 
		 * to load and build all context elements.
		 */
		public function getDisplayObjectBuilder() : DisplayObjectBuilder
		{
			return _oDisplayObjectBuilder;
		}

		/**
		 * Sets the <code>DisplayObjectBuilder</code> to use by this loader 
		 * to load and build all context elements.
		 */
		public function setDisplayObjectBuilder( displayObjectBuilder : DisplayObjectBuilder ) : void
		{
			_oDisplayObjectBuilder = displayObjectBuilder;
		}

		/**
		 * Adds the passed-in <code>listener</code> as listener for all 
		 * events dispatched by loader.
		 * 
		 * @param	listener	<code>ApplicationLoaderListener</code> instance.
		 */
		public function addApplicationLoaderListener( listener : ApplicationLoaderListener ) : Boolean
		{
			return addListener( listener );
		}

		/**
		 * Removes the passed-in <code>listener</code> object from loader. 
		 * 
		 * @param	listener	<code>ApplicationLoaderListener</code> instance.
		 */
		public function removeApplicationLoaderListener( listener : ApplicationLoaderListener ) : Boolean
		{
			return removeListener( listener );
		}

		/**
		 * Starts loading.
		 * 
		 * @param	url		(optional) URL request for 'applicationContext' file 
		 * 					to load.
		 * 	@paam	context	(optional) <code>LoaderContext</code> definition.
		 */
		override public function load( url : URLRequest = null, context : LoaderContext = null ) : void
		{
			if ( url != null ) setURL( url );

			if ( getURL( ).url.length > 0 )
			{
				var cl : ContextLoader = new ContextLoader( );
				cl.setURL( getURL( ) );

				cl.addEventListener( ContextLoaderEvent.onLoadInitEVENT, _onContextLoaderLoadInit );
				cl.addEventListener( ContextLoaderEvent.onLoadProgressEVENT, this );
				cl.addEventListener( ContextLoaderEvent.onLoadTimeOutEVENT, this );
				cl.addEventListener( ContextLoaderEvent.onLoadErrorEVENT, this );
				
				fireOnApplicationState( ApplicationLoaderEvent.LOAD_STATE ); 
				
				cl.load( getURL( ), context );
			} 
			else
			{
				var msg : String = this + ".load() can't retrieve file url.";
				PixlibDebug.ERROR( msg );
				throw new NullPointerException( msg );
			}
		}
		
		/**
		 * @private
		 * 
		 * Parses the loaded xml.
		 * 
		 * <p>Checks for context include before parsing the context.</p>
		 */
		public function parseContext( xml : * ) : void
		{
			if ( getDisplayObjectBuilder( ) == null ) setDisplayObjectBuilder( new DefaultDisplayObjectBuilder( ) );
			
			runPreprocessor( xml );
		}
		
		/**
		 * Starts IoC pre processing.
		 * 
		 * @param	xml	IoC xml context
		 * 
		 * @see #onPreprossorComplete()
		 */
		public function runPreprocessor( xml : * ) : void
		{
			fireOnApplicationState( ApplicationLoaderEvent.PREPROCESS_STATE );
			
			xml = preprocess( xml );
			
			var cl : ContextPreprocessorLoader = new ContextPreprocessorLoader( xml, getDisplayObjectBuilder( ) ); 
			cl.addEventListener( ContextPreprocessorLoader.onPreprocessorCompleteEVENT, onPreprossorComplete );
			cl.load( );
		}
		
		/**
		 * Preprocessing is completed.
		 * 
		 * <p>Starts the IoC parsing.</p>
		 * 
		 * @param	xml	IoC xml context
		 * 
		 * @see #processParsing()
		 */
		public function onPreprossorComplete( event : BasicEvent ) : void
		{
			processParsing( XML( event.getTarget() ) );	
		}
		
		/**
		 * Parses the xml context.
		 * 
		 * <p>Include files are loaded and preprocessing is done.</p>
		 */
		public function processParsing( xml : * ) : void
		{
			ChannelListenerExpert.getInstance( ).release( );
			ConstructorExpert.getInstance( ).release( );
			MethodExpert.getInstance( ).release( );
			PropertyExpert.getInstance( ).release( );
			ResourceExpert.getInstance( ).release( );
			
			var cp : ContextParser = new ContextParser( getParserCollection( ) );
			cp.addEventListener( ContextParserEvent.onContextParsingEndEVENT, _onContextParsingEnd );
			
			if ( getDisplayObjectBuilder( ) == null ) setDisplayObjectBuilder( new DefaultDisplayObjectBuilder( ) );
			if ( isAntiCache( ) ) getDisplayObjectBuilder( ).setAntiCache( true );
			getDisplayObjectBuilder( ).setRootTarget( _oRootTarget );
			getApplicationAssembler( ).setDisplayObjectBuilder( getDisplayObjectBuilder( ) );
			
			fireOnApplicationState( ApplicationLoaderEvent.PARSE_STATE ); 
			
			if( ApplicationLoader.DEBUG_LOADING_ENABLED ) //ADD TO LOWRA
			{
				PixlibDebug.DEBUG( this + ":: xml context to parse" );
				PixlibDebug.DEBUG( xml.toString( ) );
			}
			
			cp.parse( xml );
		}
		
		/**
		 * Broadcasts <code>ApplicationLoaderEvent.onApplicationStartEVENT</code> 
		 * event type when xml is parsed.
		 */
		public function fireOnApplicationStart() : void
		{
			fireEvent( new ApplicationLoaderEvent( ApplicationLoaderEvent.onApplicationStartEVENT, this ) );
		}
		
		/**
		 * Broadcasts <code>ApplicationLoaderEvent.onApplicationStateEVENT</code> when IOC engine 
		 * processing change his state ( DLL, Resources, GFX, etc. )
		 */
		public function fireOnApplicationState( state : String ) : void
		{
			var e : ApplicationLoaderEvent = new ApplicationLoaderEvent( ApplicationLoaderEvent.onApplicationStateEVENT, this );
			e.setApplicationState( state );	
			
			fireEvent( e );
		}

		/**
		 * Broadcasts <code>ApplicationLoaderEvent.onApplicationParsedEVENT</code> 
		 * event type when xml is parsed.
		 */
		public function fireOnApplicationParsed() : void
		{
			fireEvent( new ApplicationLoaderEvent( ApplicationLoaderEvent.onApplicationParsedEVENT, this ) );
		}

		/**
		 * Broadcasts <code>ApplicationLoaderEvent.onApplicationObjectsBuiltEVENT</code> 
		 * event type when all elements in xml are built.
		 */
		public function fireOnObjectsBuilt() : void
		{
			fireEvent( new ApplicationLoaderEvent( ApplicationLoaderEvent.onApplicationObjectsBuiltEVENT, this ) );
		}

		/**
		 * Broadcasts <code>ApplicationLoaderEvent.onApplicationChannelsAssignedEVENT</code> 
		 * event type when all plugin channels are initialized.
		 */
		public function fireOnChannelsAssigned() : void
		{
			fireEvent( new ApplicationLoaderEvent( ApplicationLoaderEvent.onApplicationChannelsAssignedEVENT, this ) );
		}

		/**
		 * Broadcasts <code>ApplicationLoaderEvent.onApplicationMethodsCalledEVENT</code> 
		 * event type when all <code>method-call</code> are executed.
		 */
		public function fireOnMethodsCalled() : void
		{
			fireEvent( new ApplicationLoaderEvent( ApplicationLoaderEvent.onApplicationMethodsCalledEVENT, this ) );
		}

		/**
		 * Broadcasts <code>ApplicationLoaderEvent.onApplicationInitEVENT</code> 
		 * event type when application is ready.
		 */
		public function fireOnApplicationInit() : void 
		{
			fireEvent( new ApplicationLoaderEvent( ApplicationLoaderEvent.onApplicationInitEVENT, this ) );
			
			fireOnApplicationState( ApplicationLoaderEvent.RUN_STATE );
			
			if( _oProxy != null ) removeListener( _oProxy );
			
			release();
			
			PluginExpert.getInstance( ).notifyAllPlugins( );
		}
		
		
		//------------------------------------
		// Loader callbacks
		//------------------------------------
		
		/**
		 * @inheritdoc
		 */
		public function onLoadStart( e : LoaderEvent ) : void
		{
			fireEvent( e );
		}

		/**
		 * @inheritdoc
		 */
		public function onLoadInit( e : LoaderEvent ) : void
		{
			fireEvent( e );
		}

		/**
		 * @inheritdoc
		 */
		public function onLoadProgress( e : LoaderEvent ) : void
		{
			fireEvent( e );
		}

		/**
		 * @inheritdoc
		 */
		public function onLoadTimeOut( e : LoaderEvent ) : void
		{
			fireEvent( e );
		}

		/**
		 * @inheritdoc
		 */
		public function onLoadError( e : LoaderEvent ) : void
		{
			fireEvent( e );
			
			PixlibDebug.ERROR( e.getErrorMessage( ) );
		}
		
		
		//------------------------------------
		// DisplayObjectExpert callbacks
		//------------------------------------
		 
		/**
		 * @inheritDoc
		 */
		public function onBuildDisplayObject( e : DisplayObjectEvent ) : void
		{
			if( DEBUG_LOADING_ENABLED )
				PixlibDebug.INFO( "onBuildDisplayObject()" );
		}

		/**
		 * @inheritDoc
		 */             
		public function onDisplayObjectBuilderLoadStart( e : DisplayObjectBuilderEvent ) : void
		{
			fireOnApplicationStart( );
		}

		/**
		 * @inheritDoc
		 */
		public function onDisplayLoaderInit( e : ValueObjectEvent ) : void
		{
			if( DEBUG_LOADING_ENABLED )
				PixlibDebug.INFO( "Display Loader ready" );
			
			_oProxy = new DisplayLoaderProxy( e.getTarget( ) as DisplayObjectContainer, e.getValueObject() as DisplayLoaderInfo );
			addListener( _oProxy );
		}
		
		/**
		 * @inheritDoc
		 */
		public function onDLLLoadStart( e : DisplayObjectBuilderEvent ) : void
		{
			fireOnApplicationState( ApplicationLoaderEvent.DLL_STATE );
		}

		/**
		 * @inheritDoc
		 */
		public function onDLLLoadInit( e : DisplayObjectBuilderEvent ) : void
		{
			if( DEBUG_LOADING_ENABLED )
				PixlibDebug.INFO( "onDLLLoadInit()" );
		}
		
		/**
		 * @inheritDoc
		 */
		public function onRSCLoadStart( e : DisplayObjectBuilderEvent ) : void
		{
			fireOnApplicationState( ApplicationLoaderEvent.RSC_STATE );
		}
		/**
		 * @inheritDoc
		 */
		public function onRSCLoadInit( e : DisplayObjectBuilderEvent ) : void
		{
			if( DEBUG_LOADING_ENABLED )
				PixlibDebug.INFO( "onRSCLoadInit()" );
		}

		/**
		 * @inheritDoc
		 */
		public function onDisplayObjectLoadStart( e : DisplayObjectBuilderEvent ) : void
		{
			fireOnApplicationState( ApplicationLoaderEvent.GFX_STATE );
		}

		/**
		 * @inheritDoc
		 */
		public function onDisplayObjectLoadInit( e : DisplayObjectBuilderEvent ) : void
		{
			if( DEBUG_LOADING_ENABLED )
				PixlibDebug.INFO( "onDisplayObjectLoadInit()" );
		}

		/**
		 * @inheritDoc
		 */
		public function onDisplayObjectBuilderLoadInit( e : DisplayObjectBuilderEvent ) : void
		{
			fireOnApplicationParsed( );
			
			fireOnApplicationState( ApplicationLoaderEvent.BUILD_STATE );
			
			ConstructorExpert.getInstance( ).buildAllObjects( );
			fireOnObjectsBuilt( );

			ChannelListenerExpert.getInstance( ).assignAllChannelListeners( );
			fireOnChannelsAssigned( );
			
			try
			{
				MethodExpert.getInstance( ).callAllMethods( );
				fireOnMethodsCalled( );
			}
			catch( err : Error )
			{
				PixlibDebug.ERROR( MethodExpert.getInstance( ) + " callAllmethods failed" );
			}
			finally
			{
				fireOnApplicationInit( );
			}
		}

		
		//--------------------------------------------------------------------
		// Protected methods
		//--------------------------------------------------------------------
		
		/**
		 * Do preprocessing actions on xml context before parsing.
		 * 
		 * @param	xml	Content to process
		 */
		protected function preprocess( xml : XML ) : XML
		{
			fireOnApplicationState( ApplicationLoaderEvent.PREPROCESS_STATE );
			
			//Variables
			if( _aVariables.length > 0 )
			{
				var src : String = xml.toString( );
				for each (var variable : Variable in _aVariables) 
				{
					src = src.split( variable.name ).join( variable.value );
				}
				xml = new XML( src );
			}
			
			//Methods
			for each (var method : Delegate in _aMethods) 
			{
				method.setArgumentsArray( [ xml ].concat( method.getArguments( ) ) );
				
				var mr : XML = xml;
				
				try
				{
					mr = method.callFunction( );
				}
				catch( e : Error ) 
				{
				}
				finally
				{
					xml = mr;
				}
			}
			
			//Processors
			for each (var processor : ContextProcessor in _aProcessor ) 
			{
				var pr : XML = xml;
				
				try
				{
					pr = processor.process( xml );
				}
				catch( e : Error ) 
				{
				}
				finally
				{
					xml = pr;
				}
			}
			
			return xml;
		}
		
		/**
		 * Retreives Query URL.
		 * 
		 * <p>Uses query URL to overwrite existing Flashvars for exemple.</p>
		 */
		protected function initQueryURL() : void
		{
			if( ExternalInterface.available )
			{
				var url : String = ExternalInterface.call( "eval", "document.location.href" ); 
				var args : String = url.split( "?" )[1];

				if ( args != null )
				{
					args = args.split( "#" )[0]; //SWFAddress deep link exception
					
					var params : Array = args.split( "&" );
					for (var i : int = 0; i < params.length ; i++)
					{
						var pair : Array = params[i].split( "=" );
						
						if( DEBUG_LOADING_ENABLED )
							PixlibDebug.DEBUG( this + "::registred dynamic flashvars ::" + pair[0] + " -> " + pair[1] );
						
						var key : String = FlashVarsUtil.FLASHVARS + pair[0];
						
						if( !BeanFactory.getInstance( ).isRegistered( key ) )
						{
							BeanFactory.getInstance( ).register( key, pair[1] );
						}
					}
				} 
			}
		}

		/**
		 * 
		 */
		protected function initContext( ) : void
		{
			var param : Object;
			
			try
			{
				param = _oRootTarget.root.loaderInfo.parameters;
			}
			catch( e : Error )
			{
				param = {};
			}
			finally
			{	
				var contextFile : String;
				if( BeanFactory.getInstance( ).isRegistered( FlashVarsUtil.getContextFileKey( ) ) )
				{
					contextFile = BeanFactory.getInstance( ).locate( FlashVarsUtil.getContextFileKey( ) ) as String;	
				}
				else
				{
					contextFile = param.hasOwnProperty( FlashVarsUtil.CONTEXT_FILE ) ? param[ FlashVarsUtil.CONTEXT_FILE ] : DEFAULT_CONTEXT_FILE;	
					BeanFactory.getInstance().register( FlashVarsUtil.getContextFileKey(), contextFile );
				}
				
				var contextPath : String;
				if( BeanFactory.getInstance( ).isRegistered( FlashVarsUtil.getConfigPathKey( ) ) )
				{
					contextPath = BeanFactory.getInstance( ).locate( FlashVarsUtil.getConfigPathKey( ) ) as String;	
				}
				else
				{
					contextPath = param.hasOwnProperty( FlashVarsUtil.CONFIG_PATH ) ? param[ FlashVarsUtil.CONFIG_PATH ] : DEFAULT_CONFIG_PATH;	
					BeanFactory.getInstance().register( FlashVarsUtil.getConfigPathKey(), contextPath );
				}
				
				var contextURL : URLRequest = new URLRequest( contextPath + contextFile );
				setURL( contextURL );
				
				PixlibDebug.DEBUG( this + "::load context " + contextURL.url );
			}
		}

		protected function _initParserCollection() : void
		{
			var pc : ParserCollection = new ParserCollection( );

			pc.push( new LoaderParser( getApplicationAssembler( ) ) );
			pc.push( new DLLParser( getApplicationAssembler( ) ) );			pc.push( new RSCParser( getApplicationAssembler( ) ) );
			pc.push( new DisplayObjectParser( getApplicationAssembler( ) ) );
			pc.push( new ObjectParser( getApplicationAssembler( ) ) );
			
			setParserCollection( pc );
		}

		protected function _onContextLoaderLoadInit( e : ContextLoaderEvent ) : void
		{
			e.getContextLoader( ).removeListener( this );
			parseContext( e.getContext( ) );
		}

		protected function _onContextParsingEnd( e : ContextParserEvent ) : void
		{
			e.getContextParser( ).removeEventListener( ContextParserEvent.onContextParsingEndEVENT, this );
			getDisplayObjectBuilder( ).addListener( this );
			getDisplayObjectBuilder( ).execute( );
		}

		override protected function getLoaderEvent( type : String, errorMessage : String = "" ) : LoaderEvent
		{
			return new ApplicationLoaderEvent( type, this, errorMessage );
		}
	}
}

internal class Variable
{
	private var _name : String;
	private var _value : Object;

	public function get name( ) : String
	{
		return _name;
	}

	public function get value( ) : String
	{
		return _value.toString( );
	}

	public function Variable( name : String, value : Object )
	{
		_name = "${" + name + "}";
		_value = value;
	}
}