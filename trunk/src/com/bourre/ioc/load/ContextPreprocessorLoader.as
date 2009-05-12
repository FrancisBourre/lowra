package com.bourre.ioc.load {
	import com.bourre.core.HashCodeFactory;
	import com.bourre.events.BasicEvent;
	import com.bourre.events.EventBroadcaster;
	import com.bourre.ioc.assembler.constructor.Constructor;
	import com.bourre.ioc.assembler.constructor.ConstructorExpert;
	import com.bourre.ioc.assembler.displayobject.DisplayObjectBuilder;
	import com.bourre.ioc.assembler.property.Property;
	import com.bourre.ioc.assembler.property.PropertyExpert;
	import com.bourre.ioc.control.BuildFactory;
	import com.bourre.ioc.parser.ContextAttributeList;
	import com.bourre.ioc.parser.ContextNodeNameList;
	import com.bourre.load.GraphicLoader;
	import com.bourre.load.QueueLoader;
	import com.bourre.load.QueueLoaderEvent;
	import com.bourre.log.PixlibDebug;
	import com.bourre.log.PixlibStringifier;

	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;

	/**
	 * The ContextPreprocessorLoader class allow xml context pre processing 
	 * from xml context nodes.
	 * 
	 * <p>Context preprocessing order is :
	 * <ul>
	 * 	<li>ApplicationLoader.addProcessingMethod() job</li>
	 * 	<li>ApplicationLoader.addProcessor() job</li>
	 * 	<li>ContextPreprocessorLoader job</li>
	 * </ul>  
	 * 
	 * @example Basic Processor to insert a node into xml context
	 * <pre class="prettyprint">
	 * 
	 * package com.project
	 * {
	 * 	import com.bourre.ioc.context.processor.ContextProcessor;
	 * 	
	 * 	public class TestProcessor implements ContextProcessor 
	 * 	{
	 * 		public function TestProcessor( ...args )
	 * 		{
	 * 		
	 * 		}
	 * 		
	 * 		public function process(xml : XML) : XML
	 * 		{			
	 * 			//do preprocessing here
	 * 			
	 * 			return xml;
	 * 		}
	 * 		
	 * 		public function customMethod( xml : XML ) : XML
	 * 		{
	 * 			return process( xml );
	 * 		}
	 * 	}
	 * }
	 * </pre>
	 * 
	 * <p>Define preprocessing using xml context node</p>
	 * 
	 * @example Preprocessor class is in current application domain and processor is 
	 * <code>ContextProcessor</code> implementation :
	 * <pre class="prettyprint">
	 * 
	 * &lt;preprocessor type="com.project.TestProcessor" /&gt; 
	 * </pre>
	 * 
	 * @example Preprocessor class is not in current application domain, loads it 
	 * from passed-in url ( like DLL library ) :
	 * <pre class="prettyprint">
	 * 
	 * &lt;preprocessor type="com.project.TestProcessor" url="TestProcessorDLL.swf" /&gt; 
	 * </pre>
	 * 
	 * @example Preprocessor class is not in current application domain and it is not a 
	 * <code>ContextProcessor</code> object, use <code>method</code> attribute : 
	 * <pre class="prettyprint">
	 * 
	 * &lt;preprocessor type="com.project.TestProcessor" url="TestProcessorDLL.swf" method="customMethod" /&gt; 
	 * </pre>
	 * 
	 * <p>Instance arguments are allowed, also <code>factory</code> and <code>singleton-access</code> too.
	 * 
	 * @see com.bourre.ioc.context.processor.ContextProcessor
	 * 
	 * @author Romain Ecarnot
	 */
	public class ContextPreprocessorLoader
	{
		//--------------------------------------------------------------------
		// Constants
		//--------------------------------------------------------------------
		
		/**
		 * Method name that processor must implement to 
		 * transform xml context data.
		 * 
		 * <p>Used only when <code>method</code> attribute is not 
		 * defined in preprocessor xml node.
		 * 
		 * @default process
		 * 
		 * @see com.boure.ioc.context.processor.ContextProcessor
		 */
		public static const PROCESS_METHOD_NAME : String = "process";
		
		
		//--------------------------------------------------------------------
		// Events
		//--------------------------------------------------------------------
		
		/**
		 * Defines the value of the <code>type</code> property of the event 
		 * object for a <code>onPreprocessorComplete</code> event.
		 * 
		 * <p>The properties of the event object have the following values:</p>
		 * <table class="innertable">
		 *     <tr><th>Property</th><th>Value</th></tr>
		 *     <tr>
		 *     	<td><code>type</code></td>
		 *     	<td>Dispatched event type</td>
		 *     </tr>
		 *     <tr><th>Method</th><th>Value</th></tr>
		 *     <tr>
		 *     	<td><code>getTarget</code></td>
		 *     	<td>The pre processing xml data</td>
		 *     </tr>
		 * </table>
		 * 
		 * @eventType onLoadstart
		 */	
		public static const onPreprocessorCompleteEVENT : String = "onPreprocessorComplete";

		
		//--------------------------------------------------------------------
		// Private properties
		//--------------------------------------------------------------------

		private var _xml : XML;
		private var _oEB : EventBroadcaster;		private var _loader : QueueLoader;		private var _builder : DisplayObjectBuilder;		private var _mPreprocessor : PreprocessorMap;

		
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
		
		/**
		 * Creates new <code>ContextPreprocessorLoader</code>.
		 * 
		 * @param	owner	ApplicationLoader instance
		 * @param	xml		IoC xml context
		 */
		public function ContextPreprocessorLoader( xml : *, builder : DisplayObjectBuilder )
		{
			_xml = xml;
			_loader = new QueueLoader( );
			_oEB = new EventBroadcaster( this );
			_builder = builder;
			_mPreprocessor = new PreprocessorMap( );
		}
		
		/**
		 * Starts pre processing job.
		 */
		public function load( ) : void
		{
			var processors : XMLList = _xml.child( ContextNodeNameList.PREPROCESSOR ).copy( );
			delete _xml[ ContextNodeNameList.PREPROCESSOR ];
			
			var l : int = processors.length( );
			for ( var i : int = 0; i < l ; i++ ) _parseProcessor( processors[ i ] );
			
			if( _loader.isEmpty( ) )
			{
				fireOnCompleteEvent( );
			}
			else
			{
				_loader.addEventListener( QueueLoaderEvent.onItemLoadInitEVENT, onProcessorInit );
				_loader.addEventListener( QueueLoaderEvent.onLoadErrorEVENT, onProcessorError );
				_loader.addEventListener( QueueLoaderEvent.onLoadInitEVENT, onProcessorComplete );
				_loader.execute( );
			}
		}

		/**
		 * @copy com.bourre.events.Broadcaster#addEventListener()
		 */
		public function addEventListener( type : String, listener : Object, ... rest ) : Boolean
		{
			return _oEB.addEventListener.apply( _oEB, rest.length > 0 ? [ type, listener ].concat( rest ) : [ type, listener ] );
		}

		/**
		 * @copy com.bourre.events.Broadcaster#removeEventListener()
		 */
		public function removeEventListener( type : String, listener : Object ) : Boolean
		{
			return _oEB.removeEventListener( type, listener );
		}

		/**
		 * Returns string representation of passed-in target object.
		 * 
		 * @return String representation of passed-in target object.
		 */
		public function toString() : String
		{
			return PixlibStringifier.stringify( this );
		}

		
		//--------------------------------------------------------------------
		// Protected methods
		//--------------------------------------------------------------------
		
		/**
		 * Triggered when a pre processor dll is loaded.
		 */
		protected function onProcessorInit( event : QueueLoaderEvent ) : void
		{
			var id : String = event.getLoader( ).getName( );
			
			_activePreprocessor( id, _mPreprocessor.getNode( id ) );
		}

		/**
		 * Triggered when error occurs during pre processor dll loading.
		 */
		protected function onProcessorError( event : QueueLoaderEvent ) : void
		{
			PixlibDebug.ERROR( this + "::" + event.getErrorMessage( ) );
		}
		
		/**
		 * Triggered when all context pre processors are loaded. 
		 */
		protected function onProcessorComplete( event : QueueLoaderEvent ) : void
		{
			fireOnCompleteEvent( );
		}

		/**
		 * Triggered when all context pre processors are completed. 
		 */
		protected function fireOnCompleteEvent( ) : void
		{
			ConstructorExpert.getInstance( ).release( );
			
			_loader.removeEventListener( QueueLoaderEvent.onItemLoadInitEVENT, onProcessorInit );
			_loader.removeEventListener( QueueLoaderEvent.onLoadErrorEVENT, onProcessorError );
			_loader.removeEventListener( QueueLoaderEvent.onLoadInitEVENT, onProcessorComplete );
						
			_oEB.broadcastEvent( new BasicEvent( onPreprocessorCompleteEVENT, _xml ) );
			
			_oEB.removeAllListeners( );
		}

		
		//--------------------------------------------------------------------
		// Private implementation
		//--------------------------------------------------------------------

		private function _parseProcessor( node : XML ) : void
		{
			var id : String = ContextNodeNameList.PREPROCESSOR + HashCodeFactory.getNextKey( );
			var url : String = ContextAttributeList.getURL( node );
			
			_buildObject( id, node );
			
			if( url.length > 0 )
			{
				_mPreprocessor.registrer( id, node );
				
				var request : URLRequest = _builder.getURLRequest( new URLRequest( url ), FlashVarsUtil.getDLLPathKey( ) );
				
				_loader.add( new GraphicLoader( null, -1, false ), id, request, new LoaderContext( false, ApplicationDomain.currentDomain ) );
			}
			else
			{
				_activePreprocessor( id, node );
			}
		}	

		private function _activePreprocessor( id : String, node : XML ) : void
		{
			var mN : String = ContextAttributeList.getMethod( node );
			if( mN.length < 1 ) mN = ContextPreprocessorLoader.PROCESS_METHOD_NAME;
			
			try
			{
				var cons : Constructor = ConstructorExpert.getInstance( ).locate( id ) as Constructor;
				if ( cons.arguments != null )  cons.arguments = PropertyExpert.getInstance( ).deserializeArguments( cons.arguments );
				
				var o : Object = BuildFactory.getInstance( ).build( cons, id );
				
				if( o.hasOwnProperty( mN ) )
				{
					o[ mN ].apply( null, [ _xml ] );
				}
				else 
				{
					PixlibDebug.ERROR( this + ":: preprocessor is not compliant " + ContextAttributeList.getType( node ) + "#" + mN + "()" );
				}
			}
			catch( e : Error )
			{
				PixlibDebug.ERROR( this + "::" + e.message );
			}
			finally
			{
				ConstructorExpert.getInstance( ).unregister( id );
			}
		}

		private function _buildObject( id : String, node : XML ) : void
		{
			var type : String = ContextAttributeList.getType( node );
			var args : Array = _getArguments( node, ContextNodeNameList.ARGUMENT, type );
			var factory : String = ContextAttributeList.getFactoryMethod( node );
			var singleton : String = ContextAttributeList.getSingletonAccess( node );
			
			if ( args != null )
			{
				var l : int = args.length;
				
				for ( var i : uint = 0; i < l ; i++ )
				{
					var o : Object = args[ i ];
					var p : Property = PropertyExpert.getInstance( ).buildProperty( id, o.name, o.value, o.type, o.ref, o.method );
					args[ i ] = p;
				}
			}
			
			ConstructorExpert.getInstance( ).register( id, new Constructor( id, type, args, factory, singleton ) );
		}

		private function _getArguments( xml : XML, nodeName : String, type : String = null ) : Array
		{
			var args : Array = new Array( );
			var argList : XMLList = xml.child( nodeName );
			var length : int = argList.length( );
			
			if ( length > 0 )
			{
				for ( var i : int = 0; i < length ; i++ ) 
				{
					var x : XMLList = argList[ i ].attributes( );
					if ( x.length( ) > 0 ) args.push( _getAttributes( x ) );
				}
			} 
			else
			{
				var value : String = ContextAttributeList.getValue( xml );
				if ( value != null ) args.push( { type:type, value:value } );
			}
			
			return args;
		}	

		private function _getAttributes( attributes : XMLList ) : Object
		{
			var l : int = attributes.length( );
			var o : Object = {};
			for ( var j : int = 0; j < l ; j++ ) o[ String( attributes[j].name( ) ) ] = attributes[j];
			return o;
		}
	}
}

import com.bourre.collection.HashMap;

internal class PreprocessorMap
{
	private var _map : HashMap;

	public function PreprocessorMap( )
	{
		_map = new HashMap( );
	}

	public function registrer( id : String, node : XML ) : void
	{
		_map.put( id, node );
	}

	public function getNode( id : String ) : XML
	{
		return _map.get( id );
	}
}
