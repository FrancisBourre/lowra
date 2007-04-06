package com.bourre.ioc.assembler.channel
{
	import com.bourre.events.* ;
	import com.bourre.ioc.bean.BeanFactory ;
	import com.bourre.ioc.parser.ContextAttributeList ;
	import com.bourre.log.PixlibStringifier;
	
	public class ChannelListenerExpert 
	{
		
		private static var _oI : ChannelListenerExpert;
		
		private var _oEB : EventBroadcaster;
		private var _aChannelListener : Array;
		
		public static function getInstance() : ChannelListenerExpert
		{
			if ( !(ChannelListenerExpert._oI is ChannelListenerExpert) ) ChannelListenerExpert._oI = new ChannelListenerExpert( new PrivateConstructorAccess() );
			return ChannelListenerExpert._oI;
		}
		
		public function ChannelListenerExpert(access:PrivateConstructorAccess)
		{
			_oEB = new EventBroadcaster( this );
			_aChannelListener = new Array();
		}
		
		public function assignAllChannelListeners() : void
		{
			var l : Number = _aChannelListener.length;
			for ( var i : Number = 0; i < l; i++ ) assignChannelListener( _aChannelListener[i] );
		}
		
		public function assignChannelListener( o : ChannelListener ) : void
		{
			var listener:Object = BeanFactory.getInstance().locate( o._sListenerID);
			ApplicationBroadcaster.getInstance().addListener( o._sChannel, listener as EventChannel );
		}
		
		public function buildChannelListener( listenerID : String, channel:* ) : void
		{
			if ( channel.attribute.channel is String ) 
			{
				_aChannelListener.push( _buildChannelListener( listenerID, channel.attribute ) );
							
			} else
			{
				var l : Number = channel.length;
				for ( var i : Number = 0; i < l; i++ ) _aChannelListener.push( _buildChannelListener( listenerID, channel[i].attribute) );
			}
		}
		
		private function _buildChannelListener( listenerID : String, rawInfo : Object ) : ChannelListener
		{
			return new ChannelListener( listenerID, ContextAttributeList.getChannel( rawInfo ) );
		}
		
		/**
		 * Event system
		 */
		public function addListener( oL : ChannelListenerExpertListener ) : void
		{
			_oEB.addListener( oL );
		}
		
		public function removeListener( oL : ChannelListenerExpertListener ) : void
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
		
		/**
		 * Returns the string representation of this instance.
		 * @return the string representation of this instance
		 */
		public function toString() : String 
		{
			return PixlibStringifier.stringify( this );
		}
		
		public static function release():void
		{
			if (ChannelListenerExpert._oI is ChannelListenerExpert) ChannelListenerExpert._oI = null ;
		}
	}
}

internal class PrivateConstructorAccess {}