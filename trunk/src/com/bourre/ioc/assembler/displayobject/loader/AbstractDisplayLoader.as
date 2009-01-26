package com.bourre.ioc.assembler.displayobject.loader 
{

	/**
	 * 
	 * <p>This implementations use loader callback definition in xml 
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
	 * <p>Extends class to customize loading renderer.</p>
	 * 
	 * @see DisplayLoader
	 * 
	 * @author Romain Ecarnot
	{
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
		
		/**
		 * Creates instance.
		 */		
		public function AbstractDisplayLoader()
		{
		}
		
		/**
		 * @inheritDoc
		 */
		public function onStartApplication( url : String, size : uint ) : void
		{
		}
		
		/**
		 * @inheritDoc
		 */
		public function onNameCallback( state : String ) : void
		{
		}
		
		/**
		 * @inheritDoc
		 */
		public function onLoadCallback( url : String ) : void
		{
		}
		
		/**
		 * @inheritDoc
		 */
		public function onProgressCallback( url : String, percent : Number ) : void
		{
		}
		
		/**
		 * @inheritDoc
		 */
		public function onTimeoutCallback( url : String ) : void
		{
		}
		
		/**
		 * @inheritDoc
		 */
		public function onErrorCallback( url : String ) : void
		{
		}
		
		/**
		 * @inheritDoc
		 */
		public function onInitCallback( url : String ) : void
		{
		}
		
		/**
		 * @inheritDoc
		 */
		public function onParsedCallback( ) : void
		{
		}
		
		/**
		 * @inheritDoc
		 */
		public function onBuiltCallback( ) : void
		{
		}
		
		/**
		 * @inheritDoc
		 */
		public function onChannelsCallback( ) : void
		{
		}
		
		/**
		 * @inheritDoc
		 */
		public function onMethodsCallback( ) : void
		{
		}
		
		/**
		 * @inheritDoc
		 */
		public function onCompleteCallback( ) : void
		{
		}