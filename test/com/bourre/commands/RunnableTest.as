package com.bourre.commands 
{
	import flexunit.framework.TestCase;	

	/**
	 * @author Cédric Néhémie
	 */
	public class RunnableTest extends TestCase 
	{
		private var _oRunnable : Runnable;

		public function RunnableTest ( methodName : String = null )
		{
			super( methodName );
		}
		
		protected function setRunnableObject ( runnable : Runnable ) : void
		{
			_oRunnable = runnable;
		}
		
		public function testRunnableRun () : void
		{
			_oRunnable.run();
			
			assertTrue( _oRunnable + ".run() failed to change its running state to true", _oRunnable.isRunning() );
			
			var b : Boolean = false;
			
			try
			{
				_oRunnable.run();
			}
			catch( e : Error )
			{
				b = true;
			}
			assertTrue( _oRunnable + " doesn't throw an exception when attempting to run a running operation", b );
		}
	}
}
