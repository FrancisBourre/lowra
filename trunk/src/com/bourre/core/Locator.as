package com.bourre.core
{
	import flash.utils.Dictionary;	
	
	/**
	 * A <code>Locator</code> is an entity that points to specific kind
	 * of ressources within an application. All ressources stored by a
	 * locator is identified with a unique key.
	 * <p>
	 * All concret locators implementations are associated with a specific
	 * types of ressources. For example, the <code>GraphicLoaderLocator</code>
	 * allow a single access point for all <code>*.swf</code> files loaded
	 * by an application. 
	 * </p>
	 * @author	Francis Bourre
	 */
	public interface Locator
	{
		/**
		 * Returns <code>true</code> is there is a ressource associated
		 * with the passed-in <code>key</code>. To avoid errors when
		 * retreiving ressources from a locator you should systematically
		 * use the <code>isRegistered</code> function to check if the
		 * ressource you would access is already accessible before any
		 * call to the <code>locate</code> function.
		 * 
		 * @return 	<code>true</code> is there is a ressource associated
		 * 			with the passed-in <code>key</code>.
		 */
		function isRegistered( key : String ) : Boolean;
		
		/**
		 * Returns the ressource associated with the passed-in <code>key</code>.
		 * If there is no ressource identified by the passed-in key, the
		 * function will fail with an error. To avoid the throw of an exception
		 * when attempting to access to a ressource, take care to check the
		 * existence of the ressource before trying to access to it.
		 * 
		 * @param	key	identifier of the ressource to access
		 * @return	the ressource associated with the passed-in <code>key</code>
		 * @throws 	<code>NoSuchElementException</code> — There is no ressource
		 * 			associated with the passed-in key
		 */
		function locate( key : String ) : Object;
		
		/**
		 * Adds all ressources contained in the passed-in dictionnary
		 * into this locator instance. If there is keys used both in
		 * the locator and in the dictionnary an exception is thrown.
		 * 
		 * @param	d	dictionnary instance which contains ressources
		 * 				to be added
		 * @throws 	<code>IllegalArgumentException</code> — One or more
		 * 			keys present in the dictionnary already exist in this
		 * 			locator instance.
		 */
		function add( d : Dictionary ) : void;
	}
}