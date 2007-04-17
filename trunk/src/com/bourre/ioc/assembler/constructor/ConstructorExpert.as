package com.bourre.ioc.assembler.constructor
{
	import com.bourre.events.EventBroadcaster;
	
	public class ConstructorExpert
	{
		private static var _oI : ConstructorExpert;
	
		private var _oEB : EventBroadcaster;
		//private var _mConstructor : Ma;
		
		public static function getInstance() : ConstructorExpert 
		{
			if (_oI == null) _oI = new ConstructorExpert();
			return _oI;
		}
		
		private function ConstructorExpert()
		{
			_oEB = new EventBroadcaster( this );
			//_mConstructor = new Map();
		}
	
		public function addConstructor( 	id : String, 
										type : String, 
										args, 
										factory : String, 
										singleton : String,
										channel : String ) : Constructor
		{
			
		}
		
		public function buildObject( o : Constructor ) : *
		{
			
		}
		
		public function buildAllObjects() : void
		{
			
		}
		
		public function addListener( oL : ConstructorExpertListener ) : void
		{
			
		}
		
		public function removeListener( oL : ConstructorExpertListener ) : void
		{
			
		}
		
		public function addEventListener( e : EventType, oL, f : Function ) : void
		{
			
		}
		
		public function removeEventListener( e : EventType, oL ) : void
		{
			
		}
	}
}