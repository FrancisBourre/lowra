package com.bourre.ioc.assembler.property
{
	import com.bourre.ioc.bean.BeanEvent;
	import com.bourre.ioc.bean.BeanFactoryListener;
	import com.bourre.collection.HashMap;
	import com.bourre.ioc.bean.BeanFactory;
	import com.bourre.events.* ;
	import com.bourre.ioc.parser.ContextAttributeList ;
	import com.bourre.ioc.parser.ContextTypeList ;
	import com.bourre.log.PixlibStringifier ;

	public class PropertyExpert 
		extends Property 
		implements BeanFactoryListener
	{
		private static var _oI : PropertyExpert;
		private var _oEB : EventBroadcaster;
		private var _mProperty : HashMap;
		private var _aProperty : Array;
		
		public static function getInstance():PropertyExpert
		{
			if (!_oI) _oI = new PropertyExpert(new ConstructorAccess()) ;
			return _oI ;
		}
		
		public function PropertyExpert(o : ConstructorAccess)
		{
			_oEB = new EventBroadcaster(this) ;
			_mProperty = new HashMap() ;
			_aProperty = new Array() ;
			BeanFactory.getInstance().addListener(this) ;

			addListener(IDExpert.getInstance()) ;
		}
		
		public function deserializeArguments(a:Array):Array
		{
			var r : Array;
			var l : Number = a.length;
			
			if ( l > 0 ) r = new Array();
			
			for ( var i : Number = 0; i < l; i++ ) r.push( getValue( a[i] ) );
			
			return r;
		}
		
		public function setPropertyValue(p:Property, target):void
		{
			target[p.name] = getValue(p) ;
		}
		
		// pb : _aProperty non rempli 
		/*public function setAllProperties():void
		{
			var l:int = _aProperty.length ;
			for (var i:int = 0 ; i < l ; i++)
			{
				var a:Array = _aProperty[i]; 
				var m : Number = a.length ;
				
				for (var j:int = 0 ; j < m ; j++)
				{
					var p:Property = a[j] ;
					var o = BeanFactory.getInstance().locate(p.ownerID) ;
					setPropertyValue(p, o) ;
				}
			}
		}*/
		
		public function getValue( p : Property ):Object
		{
			if ( p.method ) 
			{
				var a : Array = p.method.split(".");
				return BeanFactory.getInstance().locate( a[0] )[ a[1] ];
			
			} else if ( p.ref )
			{
				var ref : String = p.ref;
	
				if ( ref.indexOf(".") == -1 )
				{
					return BeanFactory.getInstance().locate( p.ref );
					
				} 
				//TODO change "eval"
				/*else
				{
					var a : Array = ref.split(".");
					var oRef = BeanFactory.getInstance().locate( String(a.shift()) );
					return eval( oRef + "." + (a.join(".")) );
				}*/
				
			} 
			else
			{
				var type : String = p.type;
				if (type == undefined ) type = ContextTypeList.STRING;
				return BuildFactory.getInstance().getBuilder( type ).build( p.type, [p.value] );
			}
		}
		
		public function getType( p : Property ) : String
		{
			return p.type;
		}
		
		public function getPropertyVO( ownerID : String, property ) : Array
		{
			var a : Array;
			
			if ( property )
			{
				a = new Array();
				var l : Number = property.length;
				
				if ( l > 0 ) 
				{
					for ( var i : Number = 0; i < l; i++ ) a.push( _buildProperty( ownerID, property[i].attribute) );
					
				} else
				{
					a.push( _buildProperty( ownerID, property.attribute ) );
				}
			}
			
			return a;
		}
		
		public function buildProperty( ownerID : String, property ) : void
		{
			_mProperty.put( ownerID, getPropertyVO( ownerID, property ) );
		}
		
		public function buildObjectProperty( ownerID : String, property ):void
		{
			_mProperty.put( ownerID, getPropertyVO( ownerID, property ) );
		}

		private function _buildProperty( ownerID : String, rawProperty : Object ) : Property
		{
			var p : Property =  new Property( 	
												ownerID,
												ContextAttributeList.getName( rawProperty ),
												ContextAttributeList.getValue( rawProperty ),
												ContextAttributeList.getType( rawProperty ),
												ContextAttributeList.getRef( rawProperty ),
												ContextAttributeList.getMethod( rawProperty )
											);
	
			_oEB.broadcastEvent( new PropertyEvent( p, p.ownerID, p.ref  ) );
			return p;
		}
		
		/**
		 * Event system
		 */
		public function addListener( oL : PropertyExpertListener ) : void
		{
			_oEB.addListener( oL );
		}
		
		public function removeListener( oL : PropertyExpertListener ) : void
		{
			_oEB.removeListener( oL );
		}
		
		public function addEventListener( e : BasicEvent, oL, f : Function ) : void
		{
			_oEB.addEventListener.apply( _oEB, arguments );
		}
		
		public function removeEventListener( e : BasicEvent, oL ) : void
		{
			_oEB.removeEventListener( e.type, oL );
		}
		
		/**
		 * IBeanFactoryListener callbacks
		 */
		public function onRegisterBean( e : BeanEvent ) : void
		{
			var id : String = e.getID();
			var o = e.getBean();
			
			if ( _mProperty.containsKey( id ) )
			{
				var props : Array = _mProperty.get( id );
				var l : Number = props.length;
				while( -- l > - 1 ) setPropertyValue( props[l], o );
			}
		}
		
		public function onUnregisterBean(e:BeanEvent):void
		{
			
		}
		
		/**
		 * Returns the string representation of this instance.
		 * @return the string representation of this instance
		 */
		public override function toString() : String 
		{
			return PixlibStringifier.stringify( this );
		}
		
	}
}
internal class ConstructorAccess {}