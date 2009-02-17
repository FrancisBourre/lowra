package com.bourre.ioc.bean 
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;	

	/**
	 * Some IoC bean util methods.
	 * 
	 * @author Romain Ecarnot
	 */
	public class BeanUtils 
	{
		//--------------------------------------------------------------------
		// Constants
		//--------------------------------------------------------------------
		
		/** @private */
		public static const APPLICATION_CONTAINER_NAME : String = "__AppContainer";

		
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
		
		/**
		 * Returns the main application container.
		 * 
		 * <p>This container is the one you pass to your ApplicationLoader used 
		 * to load the main IoC xml context file.</p>
		 * 
		 * @return The main application container.
		 */
		public static function getApplicationContainer(  ) : DisplayObjectContainer
		{
			var rootID : String = BeanFactory.getInstance().locate( APPLICATION_CONTAINER_NAME ) as String;
			return BeanFactory.getInstance( ).locate( rootID ) as DisplayObjectContainer;
		}
		
		/**
		 * Returns bean registered object using passed-in <code>id</code> 
		 * identifier.
		 * 
		 * @return The registered bean object using DisplayObject type
		 */
		public static function getDisplayObject( id : String ) : DisplayObject
		{
			return BeanFactory.getInstance().locate( id ) as DisplayObject;	
		}
		
		/**
		 * Returns bean registered object using passed-in <code>id</code> 
		 * identifier.
		 * 
		 * @return The registered bean object using DisplayObjectContainer type
		 */
		public static function getDisplayContainer( id : String ) : DisplayObjectContainer
		{
			return BeanFactory.getInstance().locate( id ) as DisplayObjectContainer;
		}

		
		//--------------------------------------------------------------------
		// Private implementation
		//--------------------------------------------------------------------
		
		/** @private */
		function BeanUtils()
		{
		}			
	}
}
