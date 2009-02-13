package com.bourre.ioc.assembler.displayobject.loader 
{	/**	 * Display loader interface.
	 * 
	 * <p>This interface use loader callback definition in xml 
	 * context file as :
	 * <pre class="prettyprint lang-xml">
	 * &lt;application-loader url="loader.swf" 
	 *		start-callback="onStartApplication" 
	 *		name-callback="onNameCallback"
	 *	
	 *		load-callback="onLoadCallback"
	 *		progress-callback="onProgressCallback"
	 *		timeout_callback="onTimeoutCallback"
	 *		error-callback="onErrorCallback"
	 *		init-callback="onInitCallback"
	 *	
	 *		parsed-callback="onParsedCallback"
	 *		objects-built-callback="onBuiltCallback"
	 *		channels-assigned-callback="onChannelsCallback"
	 *		methods-call-callback="onMethodsCallback"
	 *	
	 *		complete-callback="onCompleteCallback"
	 * /&gt;</pre>
	 * </p>
	 * 
	 * @author Romain Ecarnot
	 * 
	 * @see AbstractDisplayLoader
	 * @see DisplayLoaderProxy	 */	public interface DisplayLoader
	{
		/**
		 * Triggered when 'start-callback' is called from IoC engine.
		 * 	
		 * @param	url		Context file currently in use
		 * @pram	size	Elements queues size
		 */
		function onStartApplication( url : String, size : uint = 0 ) : void;
		
		/**
		 * Triggered when 'name-callback' is called from IoC engine.
		 * 	
		 * @param	state	IoC engine state<br />
		 * Possible values are : 
		 * <dl>
		 * 	<dt>PARSE
		 * 	<dd>Engine parse the xml context file
		 * 	
		 * 	<dt>DLL
		 * 	<dd>DLL section starts loading
		 * 	
		 * 	<dt>RSC
		 * 	<dd>Resources section starts loading
		 * 	
		 * 	<dt>GFX
		 * 	<dd>Display tree starts loading
		 * 	
		 * 	<dt>BUILD
		 * 	<dd>Engine build objects, assign channels, and call method-call
		 * 	
		 * 	<dt>RUN
		 * 	<dd>Loading, parsing, building are finished; application is ready.
		 * </dl>
		 */
		function onNameCallback( state : String ) : void;
		
		/**
		 * Triggered when 'load-callback' is called from IoC engine.
		 * 	
		 * @param	url		File loaded
		 */
		function onLoadCallback( url : String ) : void;
		
		/**
		 * Triggered when 'progress-callback' is called from IoC engine.
		 * 	
		 * @param	url			File loaded		 * @param	percent		Loading progression
		 */
		function onProgressCallback( url : String, percent : Number ) : void;
		
		/**
		 * Triggered when 'timeout-callback' is called from IoC engine.
		 * 	
		 * @param	url		File loaded
		 */
		function onTimeoutCallback( url : String ) : void;
		
		/**
		 * Triggered when 'error-callback' is called from IoC engine.
		 * 	
		 * @param	url		File loaded
		 */
		function onErrorCallback( url : String ) : void;
		
		/**
		 * Triggered when 'init-callback' is called from IoC engine.
		 * 	
		 * @param	url		File loaded
		 */
		function onInitCallback( url : String ) : void;
		
		/**
		 * Triggered when 'parsed-callback' is called from IoC engine.
		 */
		function onParsedCallback( ) : void;
		
		/**
		 * Triggered when 'objects-built-callback' is called from IoC engine.
		 */
		function onBuiltCallback( ) : void;
		
		/**
		 * Triggered when 'channels-assigned-callback' is called from IoC engine.
		 */
		function onChannelsCallback( ) : void;
		
		/**
		 * Triggered when 'methods-call-callback' is called from IoC engine.
		 */
		function onMethodsCallback( ) : void;
		
		/**
		 * Triggered when 'complete-callback' is called from IoC engine.
		 */
		function onCompleteCallback( ) : void;
	}}