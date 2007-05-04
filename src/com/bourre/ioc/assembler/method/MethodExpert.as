package com.bourre.ioc.assembler.method
{
	import com.bourre.ioc.parser.ContextAttributeList ;
	import com.bourre.ioc.parser.ContextNodeNameList ;
	import com.bourre.ioc.assembler.property.PropertyExpert ;
	import com.bourre.ioc.bean.BeanFactory ;
	import com.bourre.log.PixlibStringifier ;
	import com.bourre.log.PixlibDebug ;
	import com.bourre.events.EventBroadcaster ;
	
	public class MethodExpert
	{
		private static var	_oI		: MethodExpert;
		private var 		_oEB 	: EventBroadcaster;
		private var 		_aMethod: Array;
		
		public static function getInstance() : MethodExpert
		{
			if ( !(MethodExpert._oI is MethodExpert) ) 
				MethodExpert._oI = new MethodExpert( new PrivateConstructorAccess() );

			return MethodExpert._oI;
		}
		
		
		public function MethodExpert( access : PrivateConstructorAccess )
		{
			_oEB = new EventBroadcaster( this );
			_aMethod = new Array();
		}
		
		public function addMethod (ownerID:String, name:String, args:Array):Method
		{
			var _method:Method = new Method(ownerID, name, args) ;
			_aMethod.push(_method) ;
			_oEB.broadcastEvent(new MethodEvent(_method)) ;
			return _method ;
		}
		
		public function callMethod( m : Method ) : void
		{
			var owner:Object = BeanFactory.getInstance().locate( m.ownerID );

			var f : Function = owner[ m.name ];
			
			if (f != null)
			{
				owner[ m.name ].apply( owner, PropertyExpert.getInstance().deserializeArguments( m.args ) );
			} else
			{
				PixlibDebug.FATAL( this + ".callMethod() failed. " + m.ownerID + "." + m.name + "() can't be called." );
			}
		}
		
		public function callAllMethods() : void
		{
			var l : Number = _aMethod.length;
			for ( var i : Number = 0; i < l; i++ ) callMethod( _aMethod[i] );
		}
		
		/**
		 * Event system
		 */
		public function addListener( oL : MethodExpertListener ) : void
		{
			_oEB.addListener( oL );
		}
		
		public function removeListener( oL : MethodExpertListener ) : void
		{
			_oEB.removeListener( oL );
		}
		
		public function addEventListener( e : String, oL:*, f : Function ) : void
		{
			_oEB.addEventListener.apply( _oEB, arguments );
		}
		
		public function removeEventListener( e : String, oL:* ) : void
		{
			_oEB.removeEventListener( e, oL );
		}
		
		public static function release() : void
		{
			if ( MethodExpert._oI is MethodExpert ) MethodExpert._oI = null;
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

internal class PrivateConstructorAccess {}