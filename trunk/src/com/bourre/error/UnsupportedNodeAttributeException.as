package com.bourre.error
{
	import com.bourre.log.PixlibStringifier ;
	
	public class UnsupportedNodeAttributeException extends Error
	{
		public function UnsupportedNodeAttributeException ( message : String = "" )
		{
			super( message );
		}
		
		/**
		 * Returns the string representation of this instance.
		 * @return the string representation of this instance
		 */
		public function toString() : String 
		{
			return PixlibStringifier.stringify( this );
		}
		
	}
}