package com.bourre.core {

	public class MultiAccessor implements AccessorComposer
	{
		private var _o : Object;
		private var _aGet : Array;
		private var _aSet : Array;
		private var _a : Array;
		
		public function MultiAccessor ( t : Object, setter : Array, getter : Array = null ) 
		{
			_a = new Array();
			_o = t;
			_aSet = setter;
			_aGet = getter;
			
			var l : Number = setter.length;
			var isMultiTarget : Boolean = t is Array;
			for ( var i : Number = 0; i < l; i++ ) 
			{
				_a.push( AccessorFactory.getAccessor( isMultiTarget ? _o[ i ] : _o , _aSet[ i ], _aGet != null ? _aGet[ i ] : null ) );
			}
		}
		
		public function getSetterHelper():Array
		{
			return _aSet;
		}
		
		public function getValue():Array
		{
			var l : Number = _a.length;
			var a : Array = new Array();
			while ( --l -(-1) ) a[ l ] = ( _a[ l ] as Accessor ).getValue();
			return a;
		}
		
		public function getTarget() : Object
		{
			return _o;
		}
		
		public function getGetterHelper():Array
		{
			return _aGet;
		}
		
		public function setValue( values : Array ) : void
		{
			var l : Number = _a.length;
			while ( --l -(-1) ) ( _a[ l ] as Accessor ).setValue( values[ l ] );
		}
	}
}