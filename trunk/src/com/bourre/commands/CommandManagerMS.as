package com.bourre.commands
{
	public class CommandManagerMS extends CommandMS
	{
		private static var _oInstance:CommandManagerFPS;
	
		public static function getInstance() : CommandManagerMS
		{
			return (_oInstance) ? _oInstance : CommandManagerMS._init();
		}
		private static function _init() : CommandManagerMS
		{
			_oInstance = new CommandManagerMS( new PrivateCommandManagerMSConstructorAccess() );
			return _oInstance;
		}
		public static function release() : Void
		{
			_oInstance.removeAll();
			delete _oInstance;
		}
		public function CommandManagerMS ( o : PrivateCommandManagerMSConstructorAccess )
		{}
	}
}
internal class PrivateCommandManagerMSConstructorAccess {}