package com.bourre.commands 
{
	import com.bourre.commands.RunnableTest;
	
	/**
	 * @author Cédric Néhémie
	 */
	public class CancelableTest extends RunnableTest 
	{
		private var _oCancelable : Cancelable;

		public function CancelableTest (methodName : String = null)
		{
			super( methodName );
		}		
		protected function setCancelableObject ( o : Cancelable ) : void
		{
			setRunnableObject( o );
		}		
		public function testCancelableCancel () : void
		{
			_oCancelable.run();
			
			assertTrue( _oCancelable + ".run() doesn't change its running state to true", _oCancelable.isRunning() );
			
			_oCancelable.cancel();
			
			assertFalse( _oCancelable + ".cancel() doesn't change its running state to false", _oCancelable.isRunning() );
			
			var b : Boolean = false;
			try
			{
				_oCancelable.cancel();
			}
			catch( e : Error )
			{
				b = true;
			}
			assertTrue( _oCancelable + ".cancel() doesn't throw an exception when attempting to cancel a previously cancelled operation", b );
			
			b = false;
			try
			{
				_oCancelable.run();
			}
			catch( e : Error )
			{
				b = true;
			}
			assertTrue( _oCancelable + ".run() doesn't throw an exception when attempting to run a cancelled operation", b );
		}
	}
}
