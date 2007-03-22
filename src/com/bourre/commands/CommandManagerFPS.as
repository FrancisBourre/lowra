package com.bourre.commands
{
	public class CommandManagerFPS extends CommandFPS
	{
		private static var _oInstance:CommandManagerFPS;
	
		public static function getInstance() : CommandManagerFPS
		{
			return (_oInstance) ? _oInstance : CommandManagerFPS._init();
		}
		private static function _init() : CommandManagerFPS
		{
			_oInstance = new CommandManagerFPS( new PrivateCommandManagerFPSConstructorAccess() );
			return _oInstance;
		}
		public static function release() : Void
		{
			FPSBeacon.getInstance().removeFrameListener( _oInstance );
			delete _oInstance;
		}
		public function CommandManagerFPS ( o : PrivateCommandManagerFPSConstructorAccess )
		{}
	}
}
internal class PrivateCommandManagerFPSConstructorAccess {}