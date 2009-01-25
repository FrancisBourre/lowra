/* * Copyright the original author or authors. *  * Licensed under the MOZILLA PUBLIC LICENSE, Version 1.1 (the "License"); * you may not use this file except in compliance with the License. * You may obtain a copy of the License at *  *      http://www.mozilla.org/MPL/MPL-1.1.html *  * Unless required by applicable law or agreed to in writing, software * distributed under the License is distributed on an "AS IS" BASIS, * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. * See the License for the specific language governing permissions and * limitations under the License. */package com.bourre.ioc.load {	import com.bourre.error.PrivateConstructorException;
	import com.bourre.ioc.bean.BeanFactory;		

	/**	 * <p>FlashVars helper for IoC engine.</p>	 * 	 * <p>TODO Under development</p>	 * 	 * @author Romain Ecarnot	 */	public class FlashVarsUtil 	{		//--------------------------------------------------------------------		// Constants		//--------------------------------------------------------------------				/** Flashvars name prefix for Bean registration. */		public static const FLASHVARS : String = "flashvars::";				/** Flashvars name context file definition. */		public static const CONTEXT_FILE : String = "context";		
		/** Flashvars name configuration files path definition. */		public static const CONFIG_PATH : String = "config";		
		/** Flashvars name DLL files path definition. */		public static const DLL_PATH : String = "dll";		
		/** Flashvars name GFX files path definition. */		public static const GFX_PATH : String = "gfx";		
		/** Flashvars name resources files path definition. */		public static const RSC_PATH : String = "resource";		
		
		//--------------------------------------------------------------------		// Public API		//--------------------------------------------------------------------				/**		 * Returns flashvars registred with passed-in <code>name</code>.		 * 		 * @param	name	Name of flashvars to retreive		 */		public static function getVariable( name : String ) : String		{			if( BeanFactory.getInstance( ).isRegistered( FLASHVARS + name ) )			{				return BeanFactory.getInstance( ).locate( FLASHVARS + name ).toString( );			}			else return null;		}				/**		 * Registers new Flashvars pair into bean factory.		 */		public static function setVariable( name : String, value : Object, overwrite : Boolean = false ) : String		{			var factory : BeanFactory = BeanFactory.getInstance();						if( !factory.isRegistered( FLASHVARS + name ) )			{				if( !factory.isBeanRegistered( value ) )				{					factory.register( FLASHVARS + name, value );					return name;	
				}				else return factory.getKey( value ).substring( FLASHVARS.length );			}			else if( overwrite )			{				factory.unregister( FLASHVARS + name );								if( !factory.isBeanRegistered( value ) )				{					factory.register( FLASHVARS + name, value );					return name;					}				else return factory.getKey( value ).substring( FLASHVARS.length );			}						return null;		}				/**		 * Returns full Bean key for context file name flashvars.		 */		public static function getContextFileKey(  ) : String		{			return FLASHVARS + CONTEXT_FILE;		}
		/**		 * Returns full Bean key for configuration files path flashvars.		 */		public static function getConfigPathKey(  ) : String		{			return FLASHVARS + CONFIG_PATH;		}
		/**		 * Returns full Bean key for DLL files path flashvars.		 */		public static function getDLLPathKey(  ) : String		{			return FLASHVARS + DLL_PATH;		}
		/**		 * Returns full Bean key for GFX files path flashvars.		 */		public static function getGFXPathKey(  ) : String		{			return FLASHVARS + GFX_PATH;		}
		/**		 * Returns full Bean key for resources files path flashvars.		 */		public static function getResourcePathKey(  ) : String		{			return FLASHVARS + RSC_PATH;		}						//--------------------------------------------------------------------		// Private implementation		//--------------------------------------------------------------------				/**		 * @private		 */		function FlashVarsUtil( access : PrivateConstructorAccess )		{			if ( !(access is PrivateConstructorAccess) ) throw new PrivateConstructorException();		}	}}
internal class PrivateConstructorAccess 
{
}