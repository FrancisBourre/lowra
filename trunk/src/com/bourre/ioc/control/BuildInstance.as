package com.bourre.ioc.control
{
	import com.bourre.core.CoreFactory;
	import com.bourre.log.*;
	import com.bourre.plugin.*;
	
	public class BuildInstance 
		implements IBuilder
	{
		
		public function build ( qualifiedClassName : String = null, 
								args : Array = null, 
								factory : String = null, 
								singleton : String = null, 
								channel : String = null		) : *
		{
			if ( channel.length > 0 ) ChannelExpert.getInstance().registerChannel( new PluginChannel( channel ) );
			var o : * = CoreFactory.buildInstance( qualifiedClassName, args, factory, singleton );
			if ( o == null ) PixlibDebug.FATAL( this + ".build(" + qualifiedClassName + ") failed." );
			return o;
		}
		
		public function toString() : String 
		{
			return PixlibStringifier.stringify( this );
		}
	}
}