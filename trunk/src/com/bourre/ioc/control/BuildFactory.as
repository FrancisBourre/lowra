package com.bourre.ioc.control
{
	import com.bourre.collection.HashMap;
	import com.bourre.ioc.parser.ContextTypeList;
	import com.bourre.log.PixlibStringifier;
	
	public class BuildFactory
	{
		private static var _oI : BuildFactory = null;
		
		/**
		 * @return singleton instance of BuildFactory
		 */
		public static function getInstance() : BuildFactory 
		{
			if ( _oI == null ) _oI = new BuildFactory( new PrivateConstructorAccess() );
			return _oI;
		}
		
		private var _m : HashMap;
		
		public function BuildFactory( access : PrivateConstructorAccess )
		{
			init();
		}
		
		public function init() : void
		{
			_m = new HashMap();
			
			addType( ContextTypeList.DEFAULT, new BuildString() );
			addType( ContextTypeList.STRING, new BuildString() );
			addType( ContextTypeList.NUMBER, new BuildNumber() );
			addType( ContextTypeList.BOOLEAN, new BuildBoolean() );
			addType( ContextTypeList.ARRAY, new BuildArray() );
			addType( ContextTypeList.INSTANCE, new BuildInstance() );
			addType( ContextTypeList.NULL, new BuildNull() );
		}
		
		protected function addType( type : String, build : IBuilder ) : void
		{
			_m.put( type, build );
		}
		
		public function getBuilder( type : String ) : IBuilder
		{
			return ( _m.containsKey( type ) ) ? _m.get( type ) as IBuilder : _m.get( ContextTypeList.INSTANCE ) as IBuilder;
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

internal class PrivateConstructorAccess{}