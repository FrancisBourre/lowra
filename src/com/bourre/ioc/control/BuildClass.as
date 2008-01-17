package com.bourre.ioc.control 
{
import flash.utils.getDefinitionByName;	/**	 * @author Francis Bourre	 */	public class BuildClass 
			implements IBuilder
	{
		import com.bourre.log.*;

		public function build ( type : String = null, 
								args : Array = null,  
								factory : String = null, 
								singleton : String = null, 
								channel : String = null		) : *
		{
			var c : Class;
			var msg : String;
			
			var qualifiedClassName : String = "";
			if ( args != null && args.length > 0 ) qualifiedClassName = ( args[0] ).toString();

			try
			{
				c = getDefinitionByName( qualifiedClassName ) as Class;

			} catch ( e : Error )
			{
				msg = qualifiedClassName + "' class is not available in current domain";
				PixlibDebug.FATAL( msg );
				return null;
			}
	
			return c;
		}

		public function toString() : String 
		{
			return PixlibStringifier.stringify( this );
		}
	}}