package com.bourre.request
{
	import flash.events.Event;
	import com.bourre.utils.SharedObjectUtils;
	
	public class SharedObjectLoadRequest extends AbstractDataRequest
	{
		private var _sCookieName : String;
		private var _sTargetName : String;
	
		public function SharedObjectLoadRequest(cookieName : String, targetName : String )
		{
			super(this.abstractDataRequestConstructorAccess);
			
			setURL( cookieName );
			setArguments( targetName );
		}
		
		override public function setURL( url : String ) : void
		{
			_sCookieName = url;
		}
	
		override public function setArguments( targetName : String ) : void
		{
			_sTargetName = targetName;
		}
	
		override public function execute( e : Event = null ) : void
		{
			_oResult = null;
			_oResult = SharedObjectUtils.loadLocal(_sCookieName,_sTargetName)
			if ( _oResult )
			{
				fireEvent( _eResult );
				
			} else
			{
				fireEvent( _eError );
			}
		}
	}
}