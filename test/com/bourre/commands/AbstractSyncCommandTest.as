package com.bourre.commands
{
	import flexunit.framework.TestCase;
	import flash.utils.describeType;

	public class AbstractSyncCommandTest extends TestCase
	{
		private var _c : MockAbstractSyncCommand;

		public override function setUp () : void
		{
			_c = new MockAbstractSyncCommand();
		}
		
		public function testConstruct () : void
		{
			assertNotNull ( "MockAbstractSyncCommand constructor returns null - test1 failed", _c );
			
			trace( describeType( this ) );
		}
		
		public function testListenerRegister () : void
		{
			var mock : MockASyncCommandListener = new MockASyncCommandListener();
			
			_c.addASyncCommandListener( mock );			
			assertTrue ( _c + ".addASyncCommandListener failed to add the mock as listener - test1 failed", _c.isRegistered( mock ) );
			
			_c.execute();			
			assertTrue ( mock + ".onCommandEnd haven't been called by " + _c + ".execute() - test2 failed", mock.called );
			
			_c.removeASyncCommandListener( mock );
			assertFalse ( _c + ".removeASyncCommandListener failed to remove the mock from listeners - test3 failed", _c.isRegistered( mock ) );
		}
	}
}