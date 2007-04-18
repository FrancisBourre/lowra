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
		
		public final function getArguments( xml : XML, type : String = null ) : Array
		{
			var args : Array = new Array();
			var argList : XMLList = xml.child( ContextNodeNameList.ARGUMENT );
			var length : int = argList.length();

			if ( length > 0 )
			{
				for ( var i : int = 0; i < length; i++ ) 
				{
					var x : XMLList = argList[ i ].attributes();
					var l : int = x.length();

					if ( l > 0 )
					{
						var o : Object = {};
						for ( var j : int = 0; j < l; j++ ) o[ String( x[j].name() ) ]=x[j];
						args.push( o );
					}
				}

			} else
			{
				var value : String = ContextAttributeList.getValue( xml );
				if ( value != null ) args.push( { type:type, value:value } );
			}
			
			return args;
		}
	}
}