package com.bourre.commands
{
	import com.bourre.transitions.FPSBeacon;
	import com.bourre.transitions.MockBeacon;
	
	public class MockCommandFPS extends CommandFPS
	{
		public function MockCommandFPS ()
		{
			FPSBeacon.getInstance().removeTickListener( this );
			MockBeacon.getInstance().addTickListener( this );
		}
	}
}