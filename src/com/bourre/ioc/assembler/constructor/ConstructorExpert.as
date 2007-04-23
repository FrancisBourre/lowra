package com.bourre.ioc.assembler.constructor
{
	import com.bourre.events.EventBroadcaster;
	import com.bourre.collection.HashMap;
	import com.bourre.ioc.assembler.property.PropertyExpert;
	import com.bourre.ioc.control.BuildFactory;
	import com.bourre.ioc.bean.BeanFactory;
	import com.bourre.ioc.core.IDExpert;
	import com.bourre.collection.Set;
	import com.bourre.collection.Iterator;
	
	public class ConstructorExpert
	{
		private static var _oI : ConstructorExpert;
	
		private var _oEB : EventBroadcaster;
		private var _mConstructor : HashMap;
		
		public static function getInstance() : ConstructorExpert 
		{
			if (_oI == null) _oI = new ConstructorExpert();
			return _oI;
		}
		
		public static  function release() : void
		{
			_oI = null
		}
		
		public function ConstructorExpert()
		{
			_oEB = new EventBroadcaster( this );
			_mConstructor = new HashMap();
		}
	
		public function addConstructor( id : String, 
										type : String = null, 
										args : Array = null, 
										factory : String = null , 
										singleton : String = null ,
										channel : String = null ) : Constructor
		{
			var cons : Constructor = new Constructor( id, type, args, factory, singleton, channel );
			_mConstructor.put( id, cons );
			_oEB.broadcastEvent( new ConstructorEvent( cons ) );
			return cons;
		}
		
		public function buildObject( o : Constructor ) : *
		{
			var args : Array = PropertyExpert.getInstance().deserializeArguments( o.arguments );
			return BuildFactory.getInstance().getBuilder( o.type ).build( o.type, args, o.factory, o.singleton, o.channel );
		}
		
		public function buildAllObjects() : void
		{
			var bf : BeanFactory = BeanFactory.getInstance();
			var a : Set = IDExpert.getInstance().getReferenceList();
			var iter : Iterator = a.iterator()
			
			while(iter.hasNext())
			{
				var id : String = iter.next() as String
				if ( _mConstructor.containsKey( id ) ) bf.register( id, buildObject( _mConstructor.get( id ) ) );
			}
		}
		
		public function addListener( oL : ConstructorExpertListener ) : void
		{
			_oEB.addListener( oL );
		}
		
		public function removeListener( oL : ConstructorExpertListener ) : void
		{
			_oEB.removeListener( oL );
		}
		
		public function addEventListener( e : String, oL : *, f : Function ) : void
		{
			_oEB.addEventListener.apply( _oEB, arguments );
		}
		
		public function removeEventListener( e : String, oL : * ) : void
		{
				_oEB.removeEventListener( e, oL );
		}

	}
}