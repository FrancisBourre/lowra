package com.bourre.ioc.parser
{
	import com.bourre.error.*;
	import com.bourre.ioc.assembler.*;
	import com.bourre.log.PixlibDebug;
	import com.bourre.utils.ClassUtils;

	public class AbstractParser
	{
		private var _oAssembler : ApplicationAssembler;

		public function AbstractParser( assembler : ApplicationAssembler = null )
		{
			if( !( ClassUtils.isImplemented( this, "com.bourre.ioc.parser:AbstractParser", "parse" ) ) )
			{
				PixlibDebug.ERROR ( this + " have to implement virtual method : parse" );
				throw new UnimplementedVirtualMethodException ( this + " have to implement virtual method : parse" );
			}

			setAssembler( ( assembler != null ) ? assembler : new DefaultApplicationAssembler() );
		}
		
		public function getAssembler() : ApplicationAssembler
		{
			return _oAssembler;
		}
		
		public function setAssembler( assembler : ApplicationAssembler ) : void
		{
			if ( assembler != null )
			{
				_oAssembler = assembler;

			} else
			{
				throw new IllegalArgumentException( this + ".setAssembler() failed. Assembler can't be null" );
			}
		}
		
		public function parse( xml : * ) : void
		{
			//
		}
	}
}